using Biru.Service;

public class Application {
    static void main() {
        var query = URLBuilder.getSearchUrl("hentai imouto", 3);
        stdout.printf("your query: %s\n", query);
        query = URLBuilder.getBookUrl(124193);
        stdout.printf("query: %s\n", query);
        
        var api = new API();
        // api.search("love you", 3);
        api.getRelatedBooks(265890);
        //api.getDetails(38020);
    }
}
