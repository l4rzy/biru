using Biru.Service;

public class Application {
    static void main() {
        var query = URLBuilder.getSearchUrl("hentai imouto", 3);
        stdout.printf("your query: %s\n", query);
        query = URLBuilder.getBookDetailsUrl("124193");
        stdout.printf("query: %s\n", query);
    }
}
