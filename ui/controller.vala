
using Biru.UI;
using Biru.Utils;
using Biru.Service;

namespace Biru.UI {
    public class AppController {
        private Gtk.Application app;
        private Windows.Window win { get; private set; default = null; }
        private Widgets.HeaderBar headerbar;
        private Widgets.Loading loading;

        private int api_page;
        
        private API api;

        public AppController(Gtk.Application app) {
            // service setup, this will also initialize the service api
            this.api = API.get();

            // local variables
            this.api_page = 1;
            
            // window setup
            this.app = app;
            this.win = new Windows.Window(this.app);
            this.headerbar = new Widgets.HeaderBar();
            this.loading = new Widgets.Loading();
            
            this.win.set_titlebar(this.headerbar);
            this.win.add(loading);

            // signals setup
            this.api.sig_search_ok.connect((lst) => {
                message("api search ok!");
                this.loading.stop();
                this.loading.hide();
                foreach (var b in lst) {
                    stdout.printf("%s\n", b.title.english);
                }
            });

            this.api.sig_error.connect((err) => {
                message("api request error");
                this.loading.stop();
                this.loading.hide();
            });

            this.headerbar.sig_search_activated.connect((query) => {
                this.api.search(query, this.api_page, SORT_DATE);
                this.loading.start();
                this.loading.show();
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
