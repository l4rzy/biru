using Biru.Service.Configs;
using Biru.Service.Serde;

namespace Biru.Service {
    public class URLBuilder {
        // books and galleries are exchangable terms
        public static string getSearchUrl(string query, int page_num) {
            // preprocessing query by replacing all whitespaces with '+'
            string formal_query = query.replace(" ","+");
            
            return Constants.NH_HOME + "/api/galleries/search?query=" + formal_query
                + "&page=" + page_num.to_string();
        }
        
        public static string getBookUrl(int book_id) {
            return Constants.NH_HOME + "/api/gallery/" + book_id.to_string();
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
        
        public API() {
            this.session = new Soup.Session();
            this.session.ssl_strict = false;
        }
        
        public void search(string query, int page_num) {
            var uri = URLBuilder.getSearchUrl(query, page_num);
            var message = new Soup.Message("GET", uri);
            this.session.send_message(message);
            
            if (message.status_code == 200) {
                stdout.printf("%s\n", (string)message.response_body.flatten().data);
            }
            else {
                stdout.printf("Error happened!\n");
            }
        }
        
        public void getBook(int book_id) {
            var uri = URLBuilder.getBookUrl(book_id);
            
            var message = new Soup.Message("GET", uri);
            this.session.send_message(message);
            
            if (message.status_code == 200) {
                stdout.printf("%s\n", (string)message.response_body.flatten().data);
            }
            else {
                stdout.printf("Error happened!\n");
            }
        }

        public void getRelatedBooks(int book_id) {
            var uri = URLBuilder.getRelatedBooksUrl(book_id);
            stdout.printf("%s\n", uri);
        }
    }
}
