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
using Biru.UI.Configs;

namespace Biru.UI.Widgets {
    public enum BookCardOption {
        BOOKCARD_DETAILS,
        BOOKCARD_DOWNLOAD
    }

    public class BookCard : Gtk.Box {
        private File file;
        private Models.Book book;
        private Gtk.Button cardcon; // this will receive the event and do the hover effect
        private Gtk.Overlay overlay;
        private Gtk.Image lang;
        private Image image;

        private Gtk.Box titlecon;
        private Gtk.Label title;
        private int w;
        private int h;

        // signals
        public signal void sig_selected ();
        public signal void sig_favorite ();

        public BookCard (Models.Book book) {
            this.book = book;
            this.can_focus = true;
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

            // container for book card
            this.overlay = new Gtk.Overlay ();
            this.overlay.can_focus = false;
            this.overlay.halign = Gtk.Align.CENTER;
            this.overlay.width_request = this.w;
            this.overlay.height_request = this.h + 42; // TODO: handle this better

// this.fav = new Gtk.Image.from_icon_name ("emblem-favorite-symbolic", Gtk.IconSize.DND);
// this.fav.halign = Gtk.Align.END;
// this.fav.valign = Gtk.Align.START;
// this.fav.margin_top = 6;
// this.fav.margin_end = 8;
// this.fav.get_style_context ().add_class ("favbtn");

            // language flag + info
            this.title = new Gtk.Label (book.title.pretty);
            this.title.can_focus = false;
            this.title.margin_start = 10;
            // TODO: get language from book
            this.lang = new Gtk.Image.from_resource (Constants.RESOURCE_JPN_FLG);
            this.lang.margin_start = 4;
            this.title.set_tooltip_text (book.title.pretty);

            // image
            this.image = new Image ();
            this.image.halign = Gtk.Align.CENTER;
            this.image.valign = Gtk.Align.START;
            this.file = File.new_for_uri (book.thumb_url ());
            this.image.set_from_file_async.begin (this.file, this.w, this.h, true, null);

            this.titlecon = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            this.titlecon.halign = Gtk.Align.START;
            this.titlecon.valign = Gtk.Align.END;
            this.titlecon.margin_bottom = 8;

            this.titlecon.pack_start (this.lang);
            this.titlecon.pack_end (this.title);

            this.overlay.add (this.image);
            // this.overlay.add_overlay (this.fav);
            this.overlay.add_overlay (this.titlecon);

            // add widgets to the button
            this.cardcon = new Gtk.Button ();
            this.cardcon.can_focus = false;
            this.cardcon.add (this.overlay);
            this.cardcon.get_style_context ().add_class ("bookcard");

            this.add (this.cardcon);
            this.show_all ();

            // signals
            this.cardcon.clicked.connect ((event) => {
                message ("clicked %s", book.title.pretty);
            });
        }
    }
}
