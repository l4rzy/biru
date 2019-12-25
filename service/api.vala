/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 *
 */

using Biru.Service.Configs;
using Biru.Service.Serde;
using Biru.Service.Models;

namespace Biru.Service {
    public errordomain APIError {
        HTTP_ERROR,
        JSON_ERROR
    }

    public enum APIType {
        API_HOME,
        API_SEARCH,
        API_SEARCHTAG
    }

    public enum SortType {
        SORT_POPULAR,
        SORT_DATE;

        public string to_string () {
            if (this == SORT_DATE) {
                return "date";
            } else {
                return "popular";
            }
        }
    }

    public class APIResp {
        public List<Book ? > books;
        public int64 page_count { get; set; default = 0; }
        public APIError ? error;

        public APIResp () {
            this.books = null;
            this.error = null;
        }
    }

    public class URLBuilder {
        // books and galleries are not exchangable terms
        public static string get_search_url (string query, int page_num, SortType sort) {
            // preprocessing query by replacing all whitespaces with '+'
            string formal_query = query.replace (" ", "+");

            return @"$(Constants.NH_HOME)/api/galleries/search?query=$(formal_query)&page=$(page_num.to_string())&sort=$(sort.to_string())";
        }

        public static string get_homepage_url (int page_num, SortType sort) {
            return @"$(Constants.NH_HOME)/api/galleries/all?page=$(page_num.to_string())&sort=$(sort.to_string())";
        }

        // functions that are called from within objects
        public static string get_book_url (int64 book_id) {
            return @"$(Constants.NH_HOME)/api/gallery/$(book_id.to_string())";
        }

        public static string get_tag_url (int64 tag_id, int page_num, SortType sort) {
            return @"$(Constants.NH_HOME)/api/galleries/tagged?tag_id=$(tag_id.to_string())&page=$(page_num.to_string())&sort=$(sort.to_string())";
        }

        public static string __get_t_url (string media_id) {
            return @"$(Constants.NH_THUMB)/galleries/$(media_id)";
        }

        public static string __get_i_url (string media_id) {
            return @"$(Constants.NH_IMG)/galleries/$(media_id)";
        }

        public static string get_book_cover_url (string media_id, string ext) {
            return @"$(__get_t_url(media_id))/cover.$(ext)";
        }

        public static string get_book_thumbnail_url (string media_id, string ext) {
            return @"$(__get_t_url(media_id))/thumb.$(ext)";
        }

        public static string get_book_web_url (int64 book_id) {
            return @"$(Constants.NH_HOME)/g/$(book_id.to_string())";
        }

        public static string get_related_books_url (int64 book_id) {
            return @"$(Constants.NH_HOME)/api/gallery/$(book_id.to_string())/related";
        }
    }

    // to create new API instance, create with `new API()`
    public class API {
        private bool running { get; set; default = false; }
        private Soup.Session session;

        // save api last call params to repeat it if neccessary
        private unowned Cancellable ? last_cancl { get; set; }
        public unowned Tag ? last_tag { get; set; }
        public string last_query { get; set; default = ""; }
        private APIType last_api_type { get; set; }
        public int last_page_num { get; set; default = 1; }
        public SortType last_sort { get; set; default = SORT_DATE; }

        // api functions are called asynchronously from the UI, so it returns
        // by emitting signals
        public signal void sig_search_result (APIResp resp);
        public signal void sig_searchtag_result (APIResp resp);
        public signal void sig_homepage_result (APIResp resp);
        public signal void sig_related_result (APIResp resp);

        // this makes API sharable amongst objects via API.get()
        private static API ? instance;

        // constructor
        public API () {
            this.session = new Soup.Session ();
            this.session.ssl_strict = false;
            this.session.max_conns = 16;
            // this.session.use_thread_context = false;
            this.session.user_agent = Constants.NH_UA;
        }

        public void repeat_last (bool inc_page_num = true) {
            if (inc_page_num) {
                this.last_page_num++;
            }
            switch (this.last_api_type) {
                case API_HOME:
                    this.homepage.begin (this.last_page_num, this.last_sort, this.last_cancl);
                    break;
                case API_SEARCH:
                    this.search.begin (this.last_query, this.last_page_num, this.last_sort, this.last_cancl);
                    break;
                case API_SEARCHTAG:
                    this.searchtag.begin (this.last_tag, this.last_page_num, this.last_sort, this.last_cancl);
                    break;
            }
        }

        // synchronous search function
        public APIResp __search (string query, int page_num, SortType sort, Cancellable ? cancl) {
            var url = URLBuilder.get_search_url (query, page_num, sort);
            var mess = new Soup.Message ("GET", url);

            try {
                InputStream istream = this.session.send (mess, cancl);
                if (mess.status_code != 200) {
                    var ret = new APIResp ();
                    ret.error = new APIError.HTTP_ERROR ("code: $(mess.status_code.to_string())");
                    return ret;
                }
                return Parser.parse_search_result (istream);
            } catch (Error e) {
                var ret = new APIResp ();
                ret.error = new APIError.HTTP_ERROR (e.message);
                return ret;
            }
        }

        // experimental: bring request to background thread to prevent ui block
        public async void search (string query, int page_num, SortType sort, Cancellable ? cancl) throws Error {
            this.running = true;
            this.last_api_type = API_SEARCH;
            this.last_query = query;
            this.last_page_num = page_num;
            this.last_sort = sort;

            SourceFunc callb = search.callback;
            var resp = new APIResp ();

            new Thread<bool>("request search", () => {
                resp = __search (query, page_num, sort, cancl);
                Idle.add ((owned) callb);
                return true;
            });
            yield;
            // error checking before signalling
            sig_search_result (resp);
            this.running = false;
        }

        // synchronous search function
        public APIResp __searchtag (int64 tag_id, int page_num, SortType sort, Cancellable ? cancl) {
            var url = URLBuilder.get_tag_url (tag_id, page_num, sort);
            var mess = new Soup.Message ("GET", url);

            try {
                InputStream istream = this.session.send (mess, cancl);
                if (mess.status_code != 200) {
                    var ret = new APIResp ();
                    ret.error = new APIError.HTTP_ERROR ("code: $(mess.status_code.to_string())");
                    return ret;
                }
                var ret = Parser.parse_search_result (istream);
                return ret;
            } catch (Error e) {
                var ret = new APIResp ();
                ret.error = new APIError.HTTP_ERROR (e.message);
                return ret;
            }
        }

        // experimental: bring request to background thread to prevent ui block
        public async void searchtag (Tag tag, int page_num, SortType sort, Cancellable ? cancl) throws Error {
            this.running = true;
            this.last_api_type = API_SEARCHTAG;
            this.last_tag = tag;
            this.last_query = @"$(tag._type): $(tag.name)";
            this.last_page_num = page_num;
            this.last_sort = sort;

            SourceFunc callb = searchtag.callback;
            var ret = new APIResp ();

            new Thread<bool>("request searchtag", () => {
                ret = __searchtag (tag.id, page_num, sort, cancl);
                Idle.add ((owned) callb);
                return true;
            });
            yield;
            sig_searchtag_result (ret);
            this.running = false;
        }

        // synchronous function to call in another thread
        public APIResp __homepage (int page_num, SortType sort, Cancellable ? cancl) {
            var url = URLBuilder.get_homepage_url (page_num, sort);
            var mess = new Soup.Message ("GET", url);
            try {
                InputStream istream = this.session.send (mess, cancl);
                if (mess.status_code != 200) {
                    var ret = new APIResp ();
                    ret.error = new APIError.HTTP_ERROR ("code: $(mess.status_code.to_string())");
                    return ret;
                }
                var ret = Parser.parse_search_result (istream);
                return ret;
            } catch (Error e) {
                var ret = new APIResp ();
                ret.error = new APIError.HTTP_ERROR (e.message);
                return ret;
            }
        }

        // experimental: bring request to background thread to prevent ui block
        public async void homepage (int page_num, SortType sort, Cancellable ? cancl) throws Error {
            this.running = true;
            this.last_api_type = API_HOME;
            this.last_page_num = page_num;

            var ret = new APIResp ();
            SourceFunc callb = homepage.callback;

            new Thread<bool>("request home", () => {
                ret = __homepage (page_num, sort, cancl);
                Idle.add ((owned) callb);
                return true;
            });
            yield;
            sig_homepage_result (ret);
            this.running = false;
        }

        // synchronous function to call in another thread
        public APIResp __related (int64 book_id, Cancellable ? cancl) {
            var url = URLBuilder.get_related_books_url (book_id);
            var mess = new Soup.Message ("GET", url);
            try {
                InputStream istream = this.session.send (mess, cancl);
                if (mess.status_code != 200) {
                    var ret = new APIResp ();
                    ret.error = new APIError.HTTP_ERROR ("code: $(mess.status_code.to_string())");
                    return ret;
                }
                var ret = Parser.parse_search_result (istream);
                return ret;
            } catch (Error e) {
                var ret = new APIResp ();
                ret.error = new APIError.HTTP_ERROR (e.message);
                return ret;
            }
        }

        // experimental: bring request to background thread to prevent ui block
        public async void related (int64 book_id, Cancellable ? cancl) throws Error {
            this.running = true;

            var ret = new APIResp ();
            SourceFunc callb = related.callback;

            new Thread<bool>("request related", () => {
                ret = __related (book_id, cancl);
                Idle.add ((owned) callb);
                return true;
            });
            yield;
            sig_related_result (ret);
            this.running = false;
        }

        public bool is_running () {
            return this.running;
        }

        public static unowned API get () {
            if (instance == null) {
                instance = new API ();
            }
            return instance;
        }

        public static unowned Soup.Session get_session () {
            if (instance == null) {
                instance = new API ();
            }

            return instance.session;
        }
    }
}
