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
        public static string getSearchUrl(string query, int page_num, SortType sort) {
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

        public static string getHomePageUrl(int page_num) {
            return @"$(Constants.NH_HOME)/api/galleries/all?page=$(page_num.to_string())";
        }
        
        public static string getBookUrl(int book_id) {
            return Constants.NH_HOME + "/api/gallery/" + book_id.to_string();
        }

        public static string getThumbnailUrl(int64 book_id) {
            return "";
        }
        
        public static string getPictureUrl(int gallery_id, int page_num, string file_type) {
            return getGalleryUrl(gallery_id) + "/" + page_num.to_string()
                + "." + file_type;
        }

        public static string getGalleryUrl(int gallery_id) {
            return @"$(Constants.NH_THUMB)/galleries/$(gallery_id.to_string())";
        }

        public static string getRelatedBooksUrl(int book_id) {
            return @"$(getBookUrl(book_id))/related";
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
            var uri = URLBuilder.getSearchUrl(query, page_num, sort);
            message("url: %s", uri);
            var mess = new Soup.Message("GET", uri);

            // makes api query in background and raises signals when
            // request is done
            this.session.queue_message(mess, (sess, mess) => {
                if (mess.status_code == 200) {
                    try {
                        var ret = Parser.parseSearchResult((string)mess.response_body.flatten().data);
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

        public void homePage(int page_num) {
            var uri = URLBuilder.getHomePageUrl(page_num);
            var mess = new Soup.Message("GET", uri);

            this.session.queue_message(mess, (sess, mess) => {
                if (mess.status_code == 200) {
                    try {
                        var ret = Parser.parseSearchResult((string)mess.response_body.flatten().data);
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
        
        public Book getBook(int book_id) {
            var ret = new Book();
            var uri = URLBuilder.getBookUrl(book_id);
            
            var message = new Soup.Message("GET", uri);
            this.session.send_message(message);

            
            if (message.status_code == 200) {
                stdout.printf("%s\n", (string)message.response_body.flatten().data);
            }
            else {
                stdout.printf("Error happened!\n");
            }
            return ret;
        }

        public List<Book?> getRelatedBooks(int book_id) {
            var ret = new List<Book>();
            var uri = URLBuilder.getRelatedBooksUrl(book_id);

            var mess = new Soup.Message("GET", uri);
            this.session.send_message(mess);
            
            if (mess.status_code == 200) {
                stdout.printf("%s\n", (string)mess.response_body.flatten().data);
            }
            else {
                stdout.printf("Error happened!\n");
            }
            return ret;
        }

        public static unowned API get() {
            if (instance == null) {
                instance = new API();
            }
            return instance;
        }
    }
}
