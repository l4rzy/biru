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
using Biru.Service.Models;

namespace Biru.UI.Windows {
    enum ReaderPage {
        PAGE_PREV,
        PAGE_CURR,
        PAGE_NEXT
    }

    public class ReaderImage : Gtk.Overlay {
        private Image image;

        public ReaderImage () {
            this.image = new Image ();
            this.add (image);
        }

        public void load (string url) {
            this.image.clear ();
            this.image.set_from_url_async.begin (url, 800, 1000, true, null, () => {
                stdout.printf ("done\n");
            });
        }
    }

    public class Reader : Gtk.Window {
        private int curr_page { get; set; default = 0; }
        private unowned Book book;
        private Gtk.Stack stack;
        private ReaderImage image[3];
        private int page { get; set; default = 0; }
        private Gtk.StackTransitionType anim;

        public Reader (Book book) {
            Object ();
            this.get_style_context ().add_class ("reader");
            this.fullscreen();
            this.book = book;
            this.anim = Gtk.StackTransitionType.CROSSFADE;
            for (var i = 0; i < 3; i++) {
                image[i] = new ReaderImage ();
            }

            this.stack = new Gtk.Stack ();
            this.stack.set_transition_duration (100);
            for (var i = 0; i < 3; i++) {
                this.stack.add_named (image[i], i.to_string ());
            }

            this.add (stack);
            bind_keys ();
        }

        void bind_keys () {
            this.key_press_event.connect ((e) => {
                uint keycode = e.hardware_keycode;
                switch (keycode) {
                    case 9:
                        this.close ();
                        break;
                    case 114:
                        this.next ();
                        break;
                    case 113:
                        this.prev ();
                        break;
                }
                return true;
            });
        }

        public void next () {
            if (this.curr_page == 2) {
                this.stack.set_visible_child_full ("0", anim);
                message ("preloading 0");
                load (0);
                this.curr_page == 0;
            } else {
                this.stack.set_visible_child_full ((curr_page + 1).to_string (), anim);
                message (@"preloading $(curr_page+1)");
                load (curr_page + 1);
                this.curr_page++;
            }
        }

        public void prev () {
            message ("prev");
        }

        public void load (int num) {
            this.image[num].load (this.book.cover_url ());
        }

        public void init () {
            load (0);
            this.stack.set_visible_child_full ("0", anim);
        }
    }
}
