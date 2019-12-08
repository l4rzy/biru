
using Biru.UI.Configs;
using Biru.Service;

namespace Biru.UI.Widgets {
    public class HeaderBar : Gtk.HeaderBar {
        private Gtk.SearchEntry search_entry { get; set; }
        private Loading loading;
        private Navigation navi;

        public signal void sig_search_activated (string query);
        public signal void sig_btn_home ();

        public HeaderBar () {
            get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            this.set_title (Constants.APP_NAME);
            this.set_subtitle (Constants.APP_LONGNAME);
            this.show_close_button = true;

            this.navi = new Navigation ();
            this.loading = new Loading ();
            search_entry = new Gtk.SearchEntry ();
            search_entry.margin = 6;
            search_entry.expand = true;
            search_entry.placeholder_text = S.HEADER_PLACEHOLDER;
            // search_entry.sensitive = true;

            // shamelessly copied from github.com/calo001/fondo
            search_entry.button_press_event.connect ((event) => {
                search_entry.grab_focus_without_selecting ();
                if (search_entry.text_length > 0) {
                    return false;
                } else {
                    return true;
                }
            });

            this.pack_start (this.navi);
            this.pack_start (this.loading);
            this.pack_start (this.search_entry);

            // signals
            this.search_entry.activate.connect (() => {
                unowned string query = search_entry.get_text ();
                if (query.length > 0) {
                    sig_search_activated (query);
                    this.loading.start ();
                    message ("search activated");
                }
            });

            this.navi.sig_btn_home.connect (() => {
                message ("home pressed");
                sig_btn_home ();
            });
        }

        public void stop_loading () {
            this.loading.stop ();
        }

        public void start_loading () {
            this.loading.start ();
        }
    }
}
