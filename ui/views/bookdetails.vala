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

using Biru.UI.Widgets;
using Biru.Service;

namespace Biru.UI.Views {
    class BookDetails : Gtk.ScrolledWindow {
        private Gtk.Box box;
        private Models.Book ? book;
        private Image cover;

        public BookDetails () {
            this.box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            this.cover = new Image ();
            this.book = null;

            this.box.pack_start (this.cover);
            this.add (box);
            this.show_all ();
        }

        public void load_book (Models.Book b) {
            this.book = b;
            var file = File.new_for_uri (b.cover_url ());
            this.cover.set_from_file_async (file, (int) b.images.cover.w, (int) b.images.cover.h, true, null, () => {
                message ("loaded");
            });
        }
    }
}
