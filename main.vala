using Biru.Service;
using Biru.UI;
using Biru.Utils;

public class Text {
    static int main(string []args) {
        Gtk.init(ref args);
        var app = new App();
        //stdout.printf("your query: %s\n", query);
        var query = URLBuilder.getSearchUrl("imoutot", 3, SORT_POPULAR);
        stdout.printf("query: %s\n", query);

        stdout.printf("HELLO WORLD\n");

        return app.run(args);
        // var books = api.getRelatedBooks(265890);
        // stdout.printf("returned a list of %u book(s)\n", books.length());
        //api.getDetails(38020);

    }
}
