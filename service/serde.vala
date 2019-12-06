using Biru.Service.Models;

namespace Biru.Service.Serde {
    public class Parser {
        public static List<Book?> parseSearchResult(string data) throws Error {
            stdout.printf("%s\n", data);
            var list = new List<Book>();
            var parser = new Json.Parser();
            try {
                parser.load_from_data(data);

                var root = parser.get_root();
                stdout.printf("%s\n", root.get_string());
            } catch (Error e) {
                throw e;
            }

            return list;
        } 
    }
}
