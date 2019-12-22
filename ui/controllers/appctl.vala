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
namespace Biru.UI.Controllers {
    public class AppCtl {
        private unowned Gtk.Application app;
        private Windows.MainWin win { get; private set; default = null; }

        // stack to put all views in that
        private Gtk.Stack stack;

        // widgets
        private Widgets.HeaderBar headerbar { get; set; }

        // views
        private ViewPort view;
        private Views.Home home;
        private Views.BookDetails details;
        private Views.Warning warning;

        private API api;

        public AppCtl (Gtk.Application app) {
            // service setup, this will also initialize the service api
            this.api = API.get ();
            this.app = app;

            // window setup with headerbar
            this.win = new Windows.MainWin (this.app);
            this.headerbar = new Widgets.HeaderBar ();
            this.win.set_titlebar (this.headerbar);

            // views setup
            this.home = new Views.Home ();
            this.details = new Views.BookDetails ();
            this.warning = new Views.Warning ();

            // views container is a stack
            this.stack = new Gtk.Stack ();
            this.stack.add_named (this.home, Constants.STACK_HOME);
            this.stack.add_named (this.details, Constants.STACK_DETAILS);
            this.stack.add_named (this.warning, Constants.STACK_WARNING);

            // viewport to control stack views
            this.view = new ViewPort (this.stack, this.headerbar);

            this.win.add (this.stack);

            // global signals setup
            this.api.sig_error.connect ((err) => {
                this.view.warning ();
                message ("api request error");
                this.headerbar.stop_loading ();
                this.block_header (false);
            });

            this.view.sig_switch_view.connect ((v) => {
                if (v == Constants.STACK_HOME) {
                    this.headerbar.set_title (Constants.APP_NAME);
                    this.headerbar.set_subtitle (Constants.APP_LONGNAME);
                    return;
                }
                if (v == Constants.STACK_DETAILS) {
                    this.headerbar.set_title (this.details.get_book_name ());
                    if (this.details.get_book_jp_name () != null)
                        this.headerbar.set_subtitle (this.details.get_book_jp_name ());
                }
            });

            // signals on headerbar
            this.headerbar.sig_search_activated.connect ((query) => {
                // cancel all previous image loadings
                this.home.cancel_loading ();
                this.details.cancel_loading ();
                this.home.api_page = 1;
                this.api.search.begin (query, home.api_page, SORT_POPULAR, null);
                this.view.home ();
                this.headerbar.start_loading ();
            });

            this.headerbar.sig_btn_home.connect (() => {
                // cancel all image loadings first
                this.home.cancel_loading ();
                this.details.cancel_loading ();
                this.home.reset ();
                this.view.home ();
            });

            this.headerbar.sig_navi.connect ((back) => {
                if (back == true) {
                    message ("go back to home");
                    this.view.home ();
                } else {
                    message ("go fwd to details");
                    this.view.details ();
                }
            });

            this.headerbar.sig_rightbar.connect ((btn) => {
                switch (btn) {
                    case Widgets.RightBarBtn.RIGHTBAR_READ:
                        AppCtl.spawn_reader (this.details.get_book ());
                        break;
                    default:
                        message ("not implemented yet");
                        break;
                }
            });

            // signals of views
            this.home.sig_loading.connect ((load) => {
                if (load == true) {
                    this.headerbar.start_loading ();
                    this.block_header (true);
                } else {
                    this.headerbar.stop_loading ();
                    this.block_header (false);
                }
            });

            this.home.sig_book_clicked.connect ((book, opt) => {
                switch (opt) {
                    case Widgets.BookCardOption.BOOKCARD_DETAILS:
                        message ("clicked %s", book.title.pretty);
                        this.details.reset ();
                        this.details.load_book (book);
                        this.view.details ();
                        this.headerbar.start_loading ();
                        break;
                    case Widgets.BookCardOption.BOOKCARD_READ:
                        AppCtl.spawn_reader (book);
                        break;
                    default:
                        message ("not implemented yet");
                        break;
                }
            });

            this.details.sig_loaded.connect (() => {
                this.headerbar.stop_loading ();
            });

            this.details.sig_tag_clicked.connect ((tag, opt) => {
                message ("tag %s - opt: %d", tag.name, opt);
            });

            this.details.sig_page_clicked.connect ((book, index, opt) => {
                message ("page %d of %s", index + 1, book.get_web_url ());
            });

            // application setup
            this.app.add_window (this.win);
        }

        public void block_header (bool block) {
            this.headerbar.block (block);
        }

        public void activate () {
            this.win.show_all ();
            this.view.init ();
            this.home.reset ();
        }

        public void quit () {
            this.win.destroy ();
        }

        public static bool spawn_reader (Models.Book book, int index = 0) {
            var reader = new Windows.ReaderWin (book, index);
            reader.show_all ();
            reader.init ();
            return true;
        }
    }
}
