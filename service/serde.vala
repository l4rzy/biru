using Biru.Service.Models;

namespace Biru.Service.Serde {
    public class Parser {
        public static List<Book?> parseSearchResult(string data) throws Error {
            //stdout.printf("%s\n", data);
            var list = new List<Book?>();
            var parser = new Json.Parser();
            try {
                parser.load_from_data(data);

                var node = parser.get_root().get_object();
                //var node = root.get_object();
                // message("node size: %u", node.get_size());
                var result = node.get_array_member("result");
                //var num_pages = (int)node.get_int_member("num_pages");
                //var per_page = (int)node.get_int_member("per_page");
                //message("array size: %u; %d; %d", result.get_length(), num_pages, per_page);

                foreach (var jbook in result.get_elements()) {
                    //var obj = item.get_object();

                    var b = Json.gobject_deserialize(typeof(Book), jbook) as Book;
                    assert(b != null);
                    b.update_from_json(jbook);
                    // message("%d id: %lld", c, b.id)
                    list.append(b);
                }
            } catch (Error e) {
                throw e;
            }

            return list;
        } 
    }
}
