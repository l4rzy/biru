using Biru.Service.Models;

namespace Biru.Service.Serde {
    public class Parser {
        public static Book parse_book(Json.Node jbook) throws Error {
            var b = Json.gobject_deserialize(typeof(Book), jbook) as Book;
            assert(b != null);
            // to deserialize fields that could not be deserialized
            b.update_from_json(jbook);

            return b;
        }
        
        public static List<Book?> parse_search_result(string data) throws Error {
            var list = new List<Book?>();
            var parser = new Json.Parser();
            try {
                parser.load_from_data(data);
                var node = parser.get_root().get_object();
                // per_page is always 25
                // num_pages is currently ignored
                var result = node.get_array_member("result");

                foreach (var jbook in result.get_elements()) {
                    var b = parse_book(jbook);
                    list.append(b);
                }
            } catch (Error e) {
                throw e;
            }

            return list;
        } 
    }
}
