using Biru.Configs;

namespace Biru.Service {
    public class URLBuilder {
        public static string getSearchUrl(string query, int page_num) {
            // preprocessing query by replacing all whitespaces with '+'
            string formal_query = query.replace(" ","+");
            
            return Constants.NH_HOME + "/api/galleries/search?query=" + formal_query
                + "&page=" + page_num.to_string();
        }
        
        public static string getBookDetailsUrl(string book_id) {
            return Constants.NH_HOME + "/api/gallery/" + book_id;
        }
        
        public static string getPictureUrl(string gallery_id, string page_num, string file_type) {
            return Constants.NH_HOME;
        }
    }
    
    public class API {
        
    }
}
