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

using Biru.Core;
using Biru.UI;
using Biru.Service.Models;

namespace Biru.UI.Windows {
    enum ReaderPage {
        PAGE_PREV,
        PAGE_CURR,
        PAGE_NEXT
    }

    public class ReaderWin : Gtk.Window {
        private Cancellable cancl;
        private int view { get; set; default = 0; }
        private uint page { get; set; default = 0; }
        private unowned Book book;

        private Reader.HeaderBar headerbar;
        // private Gtk.Overlay overlay;
        private Reader.ViewPort viewport;

        public ReaderWin (Book book, int index) {
            Object (
                modal: true
            );
            this.cancl = new Cancellable ();
            this.get_style_context ().add_class ("reader");
            // this.fullscreen();

            this.headerbar = new Reader.HeaderBar (book, 0);
            this.set_titlebar (this.headerbar);

            this.book = book;

            this.viewport = new Reader.ViewPort (Reader.Constants.NUM_PREV_PREFETCH,
                                                 Reader.Constants.NUM_NEXT_PREFETCH, this.cancl);
            this.viewport.load_book (this.book, index);

            this.add (this.viewport);
            this.bind_keys ();

            // signals
            this.destroy.connect (() => {
                message ("quitting, cancelling all async tasks");
                this.cancl.cancel ();
            });

            this.headerbar.sig_navi.connect ((btn) => {
                switch (btn) {
                    case Reader.NaviButton.NAVI_FIRST:
                        message ("go to first page");
                        break;
                    case Reader.NaviButton.NAVI_LAST:
                        message ("go to last page");
                        break;
                    case Reader.NaviButton.NAVI_NEXT:
                        message ("go to next page");
                        this.viewport.next ();
                        break;
                    case Reader.NaviButton.NAVI_PREV:
                        message ("go to prev page");
                        this.viewport.prev ();
                        break;
                }
            });

            this.viewport.sig_viewing_page.connect ((index) => {
                this.headerbar.update (index, (int) this.book.num_pages - 1);
            });
        }

        void bind_keys () {
            this.viewport.key_press_event.connect ((e) => {
                uint keycode = e.hardware_keycode;
                message ("keycode: %u", keycode);
                switch (keycode) {
                    case 9:
                        this.close ();
                        break;
                    case 114:
                        this.viewport.next ();
                        break;
                    case 113:
                        this.viewport.prev ();
                        break;
                }
                return true;
            });

            this.viewport.scroll_event.connect ((e) => {
                switch (e.direction) {
                    case Gdk.ScrollDirection.UP:
                        message ("scrolling up");
                        break;
                    case Gdk.ScrollDirection.DOWN:
                        message ("scrolling down");
                        break;
                }
                return true;
            });
        }

        public void init () {
            this.viewport.init ();
        }
    }
}
