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
        private bool continous { get; set; default = false; }
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
        public signal void sig_book_clicked (Models.Book b);

        public Home () {
            this.api = API.get ();

            this.label = new LabelTop ("Homepage");
            this.content = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
            this.grid = new BookGrid ();

            this.content.add (label);
            this.content.add (grid);

            this.add (this.content);

            // connect signals
            this.api.sig_search_result.connect ((lst) => {
                this.label.search_result (this.api.last_query);
                this.home_type = HOME_SEARCH;
                if (!this.continous) {
                    this.clean ();
                }
                this.continous = false;
                this.insert_books (lst);
            });

            this.api.sig_homepage_result.connect ((lst) => {
                this.home_type = HOME_HOME;
                if (!this.continous) {
                    this.clean ();
                }
                this.continous = false;
                this.insert_books (lst);
            });

            this.edge_reached.connect ((pos) => {
                if (pos == Gtk.PositionType.BOTTOM) {
                    message ("scrolling reached bottom");
                    sig_scroll_bottom ();
                    this.continous = true;
                    this.api_page++;
                    if (this.home_type == HOME_HOME) {
                        this.api.homepage.begin (this.api_page, home_sort);
                    } else {
                        var query = this.api.last_query;
                        this.api.search.begin (query, this.api_page, home_sort);
                    }
                    this.sig_loading (true);
                }
            });

            // bood grid
            this.grid.sig_book_clicked.connect ((book) => {
                this.sig_book_clicked (book);
            });
        }

        // to request homepage again
        public void reset () {
            this.api_page = 1;
            this.label.home ();
            this.api.homepage.begin (this.api_page, home_sort);
            this.sig_loading (true);
        }

        public void insert_books (List<Models.Book ? > lst) {
            this.grid.insert_books (lst);
            this.sig_loading (false);
        }

        public void clean () {
            this.api_page = 1;
            this.get_vadjustment ().set_value (0);
            this.grid.clean ();
            // this.set_placement(Gtk.CornerType.TOP_RIGHT);
        }
    }
}
