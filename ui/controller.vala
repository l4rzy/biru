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
using Biru.UI.Configs;

/*
 * the main UI flow controller of App
 */
namespace Biru.UI {
    public class AppController {
        private unowned Gtk.Application app;
        private Windows.MainWin win { get; private set; default = null; }

        // stack to put all views in that
        private Gtk.Stack stack;
        private StackHist hist;

        // widgets
        private Widgets.HeaderBar headerbar { get; set; }

        // views
        private Views.Home home;
        private Views.Warning warning;

        private API api;

        public AppController (Gtk.Application app) {
            // service setup, this will also initialize the service api
            this.api = API.get ();
            this.app = app;

            // window setup
            this.win = new Windows.MainWin (this.app);
            this.headerbar = new Widgets.HeaderBar ();
            this.home = new Views.Home ();
            this.warning = new Views.Warning ();
            this.win.set_titlebar (this.headerbar);

            this.stack = new Gtk.Stack ();
            this.hist = new StackHist (this.stack, this.headerbar);
            this.stack.transition_duration = 400;
            this.stack.hhomogeneous = false;
            this.stack.interpolate_size = true;

            this.stack.add_named (this.home, Constants.STACK_HOME);
            this.hist.new_right (Constants.STACK_HOME);
            this.stack.add_named (this.warning, Constants.STACK_WARNING);
            this.win.add (this.stack);

            // global signals setup
            this.api.sig_error.connect ((err) => {
                message ("api request error");
                this.headerbar.stop_loading ();
            });

            // signals on headerbar
            this.headerbar.sig_search_activated.connect ((query) => {
                this.home.api_page = 1;
                this.api.search (query, home.api_page, SORT_DATE);
                this.headerbar.start_loading ();
            });

            this.headerbar.sig_btn_home.connect (() => {
                if (this.hist.current () != Constants.STACK_HOME) {
                    this.hist.new_right (Constants.STACK_HOME);
                }
                this.home.reset ();
            });

            this.headerbar.sig_navi.connect ((back) => {
                if (back == true) {
                    message ("go back");
                    this.hist.backward ();
                } else {
                    message ("go fwd");
                    this.hist.forward ();
                }
            });

            this.home.sig_loading.connect ((load) => {
                if (load == true) {
                    this.headerbar.start_loading ();
                    this.block_header (true);
                } else {
                    this.headerbar.stop_loading ();
                    this.block_header (false);
                }
            });

            // application setup
            this.app.add_window (this.win);
        }

        public void block_header (bool block) {
            this.headerbar.block (block);
        }

        public void activate () {
            this.win.show_all ();
            this.stack.set_visible_child_full (Constants.STACK_HOME, Gtk.StackTransitionType.CROSSFADE);
            this.home.reset ();
        }

        public void quit () {
            this.win.destroy ();
        }
    }
}
