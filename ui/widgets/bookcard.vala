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
using Biru.UI.Menus;

namespace Biru.UI.Widgets {
    public enum BookCardOption {
        BOOKCARD_DETAILS,
        BOOKCARD_DOWNLOAD
    }

    public class BookCard : Gtk.Button {
        private Models.Book book;
        // private Gtk.Button cardcon; // this will receive the event and do the hover effect
        private Gtk.Overlay overlay;
        private Gtk.Image lang;
        private Image cimage;

        private Gtk.Box titlecon;
        private Gtk.Label title;
        private int w;
        private int h;

        // signals
        public signal void sig_selected ();
        public signal void sig_favorite ();
        public signal void sig_book_clicked (Models.Book b);

        public BookCard (Models.Book book) {
            Object (
                can_focus: false
            );
            this.book = book;
            this.halign = Gtk.Align.CENTER;
            this.valign = Gtk.Align.START;
            this.margin_start = 8;
            this.margin_end = 8;
            this.margin_top = 12;
            this.margin_bottom = 6;
            // jsons are all about int64
            this.w = (int) book.images.thumbnail.w;
            this.h = (int) book.images.thumbnail.h;
            this.get_style_context ().add_class ("bookcard");

            // container for book card
            this.overlay = new Gtk.Overlay ();
            this.overlay.can_focus = false;
            this.overlay.halign = Gtk.Align.CENTER;
            this.overlay.width_request = Constants.BOOKCARD_MAX_W;
            this.overlay.height_request = Constants.BOOKCARD_MAX_H + Constants.BOOKCARD_TITLE_H;

            // language flag + info
            this.title = new Gtk.Label (book.title.pretty);
            this.title.can_focus = false;
            this.title.margin_start = 10;

            switch (this.book.language ()) {
                case ENGLISH:
                    this.lang = new Gtk.Image.from_resource (Constants.RESOURCE_UK_FLG);
                    break;
                case CHINESE:
                    this.lang = new Gtk.Image.from_resource (Constants.RESOURCE_CN_FLG);
                    break;
                case JAPANESE:
                    this.lang = new Gtk.Image.from_resource (Constants.RESOURCE_JPN_FLG);
                    break;
            }
            this.lang.margin_start = 4;
            this.title.set_tooltip_text (book.title.pretty);

            // image
            this.cimage = new Image ();
            this.cimage.halign = Gtk.Align.CENTER;
            this.cimage.valign = Gtk.Align.START;
            this.cimage.set_from_url_async.begin (book.thumb_url (), Constants.BOOKCARD_MAX_W, Constants.BOOKCARD_MAX_H, true, null, () => {
                this.overlay.width_request = this.cimage.width;
                this.overlay.height_request = this.cimage.height + Constants.BOOKCARD_TITLE_H;
            });

            this.titlecon = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            this.titlecon.halign = Gtk.Align.START;
            this.titlecon.valign = Gtk.Align.END;
            this.titlecon.margin_bottom = 8;

            this.titlecon.pack_start (this.lang);
            this.titlecon.pack_end (this.title);

            this.overlay.add (this.cimage);
            this.overlay.add_overlay (this.titlecon);

            // add widgets to the button
            this.add (this.overlay);
            this.show_all ();

            // signals
            this.button_press_event.connect ((event) => {
                if (event.button == 3) {
                    // right click
                    var menu = new BookCardMenu (this);
                    menu.sig_pop_clicked.connect (() => {
                        message ("book %s download", book.title.pretty);
                    });
                    menu.popup ();
                    return true;
                }
                this.sig_book_clicked (this.book);
                return true;
            });
        }
    }
}
