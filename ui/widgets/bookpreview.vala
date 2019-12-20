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
    public class BookPreview : Gtk.FlowBox {
        private unowned Cancellable ? cancl;

        public signal void sig_page_clicked (Models.Book book, int pnum);

        public BookPreview (Cancellable ? cancl) {
            Object ();
            this.cancl = cancl;

            this.cancl = cancl;
            this.margin_end = 40;
            this.margin_start = 40;
            this.set_selection_mode (Gtk.SelectionMode.NONE);
            this.activate_on_single_click = false;
            this.homogeneous = false;
            this.column_spacing = 20;
            this.orientation = Gtk.Orientation.HORIZONTAL;
        }

        public void load_book (Models.Book book) {
            int num_pages = (int) book.num_pages;
            if (num_pages > 100) {
                // TODO: dynamic loading to handle this
                message ("num_pages is %d, exceeded current limit, loading only 100 first pages", num_pages);
                num_pages = 100;
            }

            for (var i = 0; i < num_pages; i++) {
                var pagecard = new PageCard (book, i, this.cancl);
                this.add (pagecard);
            }
        }

        public void clean () {
            this.cancl.cancel ();
            this.cancl.reset ();
            this.@foreach ((w) => {
                w.destroy ();
            });
        }
    }
}
