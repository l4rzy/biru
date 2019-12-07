using Biru.Service.Configs;
using Biru.Service.Serde;
using Biru.Service.Models;

namespace Biru.Service {
    
    errordomain ErrorAPI {
        UNAVAIL,
        UNKNOWN
    }

    public enum SortType {
        SORT_POPULAR,
        SORT_DATE
    }
    
    public class URLBuilder {
        // books and galleries are exchangable terms
        public static string get_search_url(string query, int page_num, SortType sort) {
            // preprocessing query by replacing all whitespaces with '+'
            string formal_query = query.replace(" ","+");
            string sort_type;
            if (sort == SORT_DATE) {
                sort_type = "date";
            }
            else {
                sort_type = "popular";
            }

            return @"$(Constants.NH_HOME)/api/galleries/search?query=$(formal_query)&page=$(page_num.to_string())&sort=$(sort_type)";
        }

        public static string get_homepage_url(int page_num) {
            return @"$(Constants.NH_HOME)/api/galleries/all?page=$(page_num.to_string())";
        }
        
        public static string get_related_books_url(int book_id) {
            return @"";
        }
    }

    public class API {
        private Soup.Session session;

        // api functions are called asynchronously from the UI, so it returns
        // by emitting signals
        public signal void sig_search_ok(List<Book?> lst);
        public signal void sig_homePage_ok(List<Book?> lst);
        public signal void sig_getRelatedBooks_ok(List<Book?> lst);
        public signal void sig_getBook_ok(Book book);
        public signal void sig_error(Error err);

        // this makes API sharable amongst objects via API.get()
        private static API? instance;
        
        public API() {
            this.session = new Soup.Session();
            this.session.ssl_strict = false;
            this.session.user_agent = Constants.NH_UA;
        }
        
        public void search(string query, int page_num, SortType sort) {
            var uri = URLBuilder.get_search_url(query, page_num, sort);
            message("url: %s", uri);
            var mess = new Soup.Message("GET", uri);

            // makes api query in background and raises signals when
            // request is done
            this.session.queue_message(mess, (sess, mess) => {
                if (mess.status_code == 200) {
                    try {
                        var ret = Parser.parse_search_result((string)mess.response_body.flatten().data);
                        sig_search_ok(ret);
                    } catch (Error e) {
                        sig_error(e);
                    }
                }
                else {
                    sig_error(new ErrorAPI.UNKNOWN(@"error loading code: $(mess.status_code)"));
                }
            });
        }

        public void homepage(int page_num) {
            var uri = URLBuilder.get_homepage_url(page_num);
            var mess = new Soup.Message("GET", uri);

            this.session.queue_message(mess, (sess, mess) => {
                if (mess.status_code == 200) {
                    try {
                        var ret = Parser.parse_search_result((string)mess.response_body.flatten().data);
                        sig_homePage_ok(ret);
                    } catch (Error e) {
                        sig_error(e);
                    }
                }
                else {
                    sig_error(new ErrorAPI.UNKNOWN(@"error loading code: $(mess.status_code)"));
                }
            });
        }

        public static unowned API get() {
            if (instance == null) {
                instance = new API();
            }
            return instance;
        }
    }
}
