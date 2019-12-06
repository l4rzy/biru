
using Biru.UI;
using Biru.Utils;
using Biru.Service;

/*
 * this is the UI entry point
 */
namespace Biru.UI.Controllers {
    public class AppController {
        private Gtk.Application app;
        private Windows.Window win { get; private set; default = null; }
        private Widgets.HeaderBar headerbar;
        private Widgets.Loading loading;
        private API api;

        public AppController(Gtk.Application app) {
            // service setup
            this.api = new API();
            
            // window setup
            this.app = app;
            this.win = new Windows.Window(this.app);
            this.headerbar = new Widgets.HeaderBar();
            this.loading = new Widgets.Loading();
            this.win.set_titlebar(this.headerbar);
            this.win.add(loading);

            // signals setup
            this.api.sig_search_ok.connect((lst) => {
                stdout.printf(" api search ok!\n");
                this.loading.stop();
            });

            this.api.sig_error.connect((err) => {
                stdout.printf(" api request error\n");
            });

            this.headerbar.sig_search_activated.connect((query) => {
                this.api.search(query, 2, SORT_DATE);
            });

            // application setup
            this.app.add_window(this.win);
        }

        public void activate() {
            this.win.show_all();
        }

        public void quit() {
            this.win.destroy();
        }
    }
}
