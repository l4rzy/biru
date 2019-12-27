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
using Biru.UI.Menus;

namespace Biru.UI.Widgets {
    public class PageCard : Gtk.Button {
        private unowned Models.Book book;
        private Gtk.Overlay overlay;
        private Image cimage;

        // signals
        public signal void sig_page_clicked (Models.Book b, int index, PageCardOpt opt);

        public PageCard (Models.Book book, int index, Cancellable ? cancl) {
            Object (
                can_focus: false
            );

            this.book = book;
            this.get_style_context ().add_class ("pagecard");
            this.margin_start = 4;
            this.margin_end = 4;
            this.margin_top = 4;
            this.margin_bottom = 4;

            this.overlay = new Gtk.Overlay ();
            this.overlay.width_request = 180;
            this.overlay.height_request = 280;
            this.overlay.can_focus = false;
            this.overlay.halign = Gtk.Align.CENTER;

            this.cimage = new Image ();

            this.overlay.add (cimage);
            this.add (overlay);

            var page = book.get_pageno_info (index);

            this.cimage.set_from_url_async.begin (page.thumb_url, 180, 280, true, cancl, () => {
                message ("done %s", page.thumb_url);
            });

            this.show_all ();

            this.button_press_event.connect ((event) => {
                if (event.button == 3) {
                    // right click
                    var menu = new PageCardMenu (this);
                    menu.sig_pop_clicked.connect ((opt) => {
                        this.sig_page_clicked (this.book, index, opt);
                    });
                    menu.popup ();
                } else if (event.button == 1) {
                    this.sig_page_clicked (this.book, index, PAGECARD_READ);
                }
                return true;
            });
        }
    }
}
