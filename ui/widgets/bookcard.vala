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
    public class BookCard : Gtk.Box {
        private File file;
        private Models.Book book;
        private Image image;

        private Gtk.Box titlecon;
        private Gtk.Button title;
        private int w;
        private int h;

        public BookCard (Models.Book book) {
            this.book = book;
            this.can_focus = false;
            this.orientation = Gtk.Orientation.VERTICAL;
            this.halign = Gtk.Align.CENTER;
            this.valign = Gtk.Align.START;
            this.margin_start = 8;
            this.margin_end = 8;
            this.margin_top = 12;
            this.margin_bottom = 6;

            // jsons are all about int64
            this.w = (int) book.images.thumbnail.w;
            this.h = (int) book.images.thumbnail.h;

            this.titlecon = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            this.title = new Gtk.Button.with_label (book.title.pretty);
            this.title.halign = Gtk.Align.CENTER;
            this.title.margin_top = 10;
            this.title.can_focus = false;

            this.image = new Image ();
            this.file = File.new_for_uri (book.thumb_url ());

            assert (this.file != null);

            this.image.set_from_file_async.begin (this.file, this.w, this.h, true, null);
            this.add (this.image);
            this.titlecon.pack_end (this.title);
            this.add (this.titlecon);
            this.show_all ();
        }
    }
}
