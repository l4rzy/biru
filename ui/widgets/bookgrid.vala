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

namespace Biru.UI.Widgets {
    public class BookGrid : Gtk.FlowBox {
        private unowned List<Models.Book ? > books;
        // private unowned List<GLib.File ? > files;

        public signal void sig_book_clicked (Models.Book book);

        public BookGrid () {
            this.margin_end = 10;
            this.margin_start = 10;
            this.set_selection_mode (Gtk.SelectionMode.NONE);
            this.activate_on_single_click = false;
            this.homogeneous = false;
            this.column_spacing = 10;
            this.orientation = Gtk.Orientation.HORIZONTAL;
        }

        // TODO: async load image in perceptive field first
        public void insert_books (List<Models.Book ? > books) {
            this.books = books;

            foreach (var b in this.books) {
                var card = new BookCard (b);
                card.sig_book_clicked.connect (() => {
                    sig_book_clicked (b);
                });
                this.add (card);
                card.show_all ();
            }
        }

        public void clean () {
            // TODO: cancel all current async tasks

            this.@foreach ((w) => {
                w.destroy ();
            });
        }
    }
}
