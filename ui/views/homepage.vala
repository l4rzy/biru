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

using Biru.Service;
using Biru.UI.Widgets;

// home view that partly acts as a controller on its own
namespace Biru.UI.Views {
    public enum HomeType {
        HOME_HOME,
        HOME_SEARCH
    }

    public class Home : Gtk.ScrolledWindow {
        // common fields
        private Cancellable cancl;
        private bool continuous { get; set; default = false; }
        private API api;
        public int api_page { get; set; default = 1; }
        private HomeType home_type { get; set; default = HOME_HOME; }
        private SortType home_sort { get; set; default = SORT_POPULAR; }

        // widgets
        private LabelTop label;
        private BookGrid grid;
        private Gtk.Box content;

        // signals
        public signal void sig_scroll_bottom ();
        public signal void sig_loading (bool load);
        public signal void sig_book_clicked (Models.Book book, BookCardOption opt);

        public Home () {
            this.api = API.get ();
            this.cancl = new Cancellable ();

            this.label = new LabelTop ("Homepage");
            this.content = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
            this.grid = new BookGrid (this.cancl);

            this.content.add (label);
            this.content.add (grid);

            this.add (this.content);

            // connect signals
            this.api.sig_search_result.connect ((resp) => {
                if (resp.error != null) {
                    message (@"API error: $(resp.error.message)");
                }

                this.label.search_result (this.api.last_query, resp.page_count);
                this.home_type = HOME_SEARCH;
                if (!this.continuous) {
                    this.clean ();
                }
                this.continuous = false;
                this.insert_books (resp.books);
            });

            this.api.sig_searchtag_result.connect ((resp) => {
                if (resp.error != null) {
                    message (@"API error: $(resp.error.message)");
                }

                this.label.search_result (this.api.last_query, resp.page_count);
                this.home_type = HOME_SEARCH;
                if (!this.continuous) {
                    this.clean ();
                }
                this.continuous = false;
                this.insert_books (resp.books);
            });

            this.api.sig_homepage_result.connect ((resp) => {
                if (resp.error != null) {
                    // TODO: error processing and show warning view with a reload button
                    message (@"API error: $(resp.error.message)");
                }
                message ("received %lld pages", resp.page_count);
                this.home_type = HOME_HOME;
                if (!this.continuous) {
                    this.clean ();
                }
                this.continuous = false;
                this.insert_books (resp.books);
            });

            this.edge_reached.connect ((pos) => {
                if (pos == Gtk.PositionType.BOTTOM) {
                    message ("scrolling reached bottom");
                    if (!this.api.is_running ()) {
                        sig_scroll_bottom ();
                        this.continuous = true;
                        this.api_page++;

                        this.api.repeat_last (true);
                        this.sig_loading (true);
                    } else {
                        message ("please wait a bit more, api is running");
                    }
                }
            });

            // bood grid
            this.grid.sig_book_clicked.connect ((book, opt) => {
                this.sig_book_clicked (book, opt);
            });
        }

        // to request homepage again
        public void reset () {
            this.api_page = 1;
            this.label.home ();
            this.api.homepage.begin (this.api_page, home_sort, this.cancl);
            this.sig_loading (true);
        }

        public void insert_books (List<Models.Book ? > lst) {
            this.grid.insert_books (lst);
            this.sig_loading (false);
        }

        // cancel all current async task
        public void cancel_loading () {
            this.cancl.cancel ();
            this.cancl.reset ();
        }

        public void pause_loading () {
        }

        public void continue_loading () {
        }

        public void clean () {
            this.api_page = 1;
            this.get_vadjustment ().set_value (0);
            this.grid.clean ();
        }
    }
}
