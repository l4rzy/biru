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
        private Gtk.Grid grid;

        private Models.Book ? book;
        private Image cover;
        private TagGrid tgrid;
        private BookInfo info;

        public signal void sig_loaded ();
        public signal void sig_tag_clicked (Models.Tag tag);

        public BookDetails () {
            Object ();
            this.book = null;
            this.grid = new Gtk.Grid ();

            this.cover = new Image ();
            this.grid.attach (cover, 0, 0, 1, 1);

            this.tgrid = new TagGrid ();
            this.grid.attach (tgrid, 1, 0, 1, 1);
            this.info = new BookInfo ();

            this.add (grid);
            this.show_all ();

            this.tgrid.sig_tag_clicked.connect ((tag) => {
                this.sig_tag_clicked (tag);
            });
        }

        public string get_book_name () {
            return this.book.title.pretty;
        }

        public string ? get_book_jp_name () {
            return this.book.title.japanese;
        }

        public unowned Models.Book get_book () {
            return this.book;
        }

        public void load_book (Models.Book b) {
            this.cover.clear ();
            this.book = b;
            this.cover.set_from_url_async.begin (b.cover_url (), 600, 800, true, null, () => {
                this.sig_loaded ();
            });

            this.tgrid.insert_tags (b.tags);
            this.info.load_book (b);
        }
    }
}
