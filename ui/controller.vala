using Biru.UI;
using Biru.Utils;
using Biru.Service;

/*
 * the main UI flow controller of App
 */
namespace Biru.UI {
    public class AppController {
        private Gtk.Application app;
        private Windows.MainWin win { get; private set; default = null; }

        // stack to put all views in that
        private Gtk.Stack stack;

        // widgets
        private Widgets.HeaderBar headerbar;
        private Views.Home home;

        private API api;

        public AppController (Gtk.Application app) {
            // service setup, this will also initialize the service api
            this.api = API.get ();

            // window setup
            this.app = app;
            this.win = new Windows.MainWin (this.app);
            this.headerbar = new Widgets.HeaderBar ();
            this.home = new Views.Home ();
            // this.loading = new Widgets.Loading();

            this.win.set_titlebar (this.headerbar);
            // this.win.add(loading);
            this.win.add (home);

            // global signals setup
            this.api.sig_error.connect ((err) => {
                message ("api request error");
                this.headerbar.stop_loading ();
            });

            this.headerbar.sig_search_activated.connect ((query) => {
                this.api.search (query, home.api_page, SORT_DATE);
                this.headerbar.start_loading ();
            });

            this.home.sig_loading.connect (() => {
                message ("home searching");
                this.headerbar.start_loading ();
            });

            this.home.sig_loading_done.connect (() => {
                message ("home loading done");
                this.headerbar.stop_loading ();
            });

            // application setup
            this.app.add_window (this.win);
        }

        public void activate () {
            this.win.show_all ();
            this.home.init ();
        }

        public void quit () {
            this.win.destroy ();
        }
    }
}
