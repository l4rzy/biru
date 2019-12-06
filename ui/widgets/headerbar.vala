
using Biru.UI.Configs;

namespace Biru.UI.Widgets {
    public class HeaderBar : Gtk.HeaderBar {
        private Gtk.SearchEntry search_entry {get;set;}
        public signal void sig_search_activated(string query);

        public HeaderBar() {
            this.set_title(Constants.APP_NAME);
            this.set_subtitle(Constants.APP_LONGNAME);
            this.show_close_button = true;

            search_entry = new Gtk.SearchEntry();
            this.pack_start(this.search_entry);

            this.search_entry.activate.connect(() => {
                unowned string query = search_entry.get_text();
                if (query.length > 0) {
                    sig_search_activated(query);
                    stdout.printf("Search activated\n");
                }
            });
        }
    }
}
