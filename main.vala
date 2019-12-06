using Biru.Service;
using Biru.UI;
using Biru.Utils;

public class Text {
    static int main(string []args) {
        Gtk.init(ref args);
        var app = new App();
        return app.run(args);
    }
}
