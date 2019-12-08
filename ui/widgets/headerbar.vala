
using Biru.UI.Configs;
using Biru.Service;

namespace Biru.UI.Widgets {
    public class HeaderBar : Gtk.HeaderBar {
        private Gtk.SearchEntry search_entry {get;set;}
        private Loading loading;
        public signal void sig_search_activated(string query);

        public HeaderBar() {
            this.set_title(Constants.APP_NAME);
            this.set_subtitle(Constants.APP_LONGNAME);
            this.show_close_button = true;
            this.loading = new Loading();

            get_style_context().add_class(Gtk.STYLE_CLASS_FLAT);

            search_entry = new Gtk.SearchEntry();
            this.pack_start(this.loading);
            this.pack_start(this.search_entry);

            this.search_entry.activate.connect(() => {
                unowned string query = search_entry.get_text();
                if (query.length > 0) {
                    sig_search_activated(query);
                    this.loading.start();
                    message("search activated");
                }
            });
        }

        public void stop_loading() {
            this.loading.stop();
        }

        public void start_loading() {
            this.loading.start();
        }
    }
}
