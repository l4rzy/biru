/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 *
 */

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
                this.home.api_page = 1;
                this.api.search (query, home.api_page, SORT_DATE);
                this.headerbar.start_loading ();
            });

            this.headerbar.sig_btn_home.connect (() => {
                this.home.reset ();
            });

            this.home.sig_loading.connect ((load) => {
                if (load == true) {
                    this.headerbar.start_loading ();
                } else {
                    this.headerbar.stop_loading ();
                }
            });

            // application setup
            this.app.add_window (this.win);
        }

        public void activate () {
            this.win.show_all ();
            this.home.reset ();
        }

        public void quit () {
            this.win.destroy ();
        }
    }
}
