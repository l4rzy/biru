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

namespace Biru.UI.Reader {
    public class ViewPort : Gtk.Stack {
        private Cancellable ? cancl;
        private uint nbase { get; set; }
        private uint cprev { get; set; } // numbers of previous pages to cache
        private uint ringptr { get; set; default = 0; } // points to the circle at which pages are rendered
        private uint urlptr { get; set; } // the rightmost url cached
        private uint num_pages { get; set; }

        private List<string ? > urls;
        private Gtk.StackTransitionType anim;

        private LoadingCircle loading;
        private List<Reader.Image ? > ring;

        private signal void sig_loading_done (uint rpos);
        public signal void sig_viewing_page (int index);

        public ViewPort (int num_prev, int num_next, Cancellable ? cancl) {
            Object ();

            // this.set_events (Gdk.EventMask.SCROLL_MASK | Gdk.EventMask.KEY_PRESS_MASK);
            this.set_events (Gdk.EventMask.ALL_EVENTS_MASK);
            this.cancl = cancl;
            this.nbase = num_prev + num_next;
            this.cprev = num_prev;

            this.anim = Gtk.StackTransitionType.OVER_LEFT;
            this.ring = new List<Reader.Image ? >();
            this.loading = new LoadingCircle ();

            this.add_named (this.loading, "loading");
            for (var i = 0; i < this.nbase; i++) {
                var img = new Reader.Image (this.cancl);
                this.add_named (img, i.to_string ());
                img.sig_loading_done.connect ((rpos) => {
                    if (rpos == this.ringptr) {
                        // loading is done, switch to ring pointer
                        message ("received sig_loading_done");
                        this.loading.stop ();
                        this.set_visible_child_full (rpos.to_string (), this.anim);
                    }
                });
                this.ring.append ((owned) img);
            }
        }

        // associate upos to rpos
        private void prefetch (uint rpos, uint upos) {
            var url = this.urls.nth_data (upos);
            this.ring.nth_data (rpos).load (url, rpos, upos);
            message ("ring pointer %u is associated with url pointer %u", rpos, upos);
        }

        public void load_book (Models.Book book, int index) {
            this.urlptr = (uint) index;
            this.urls = book.get_page_urls ();
            this.num_pages = (uint) book.num_pages;

            // load images to prefetch ring
            for (var rptr = 0; rptr < this.nbase; rptr++) {
                this.prefetch (rptr, this.urlptr);
                this.urlptr++;
            }

            // TODO: better way to do this
            this.urlptr--;
        }

        private void viewloading () {
            message ("view loading");
            this.loading.start ();
            this.set_visible_child_full ("loading", this.anim);
        }

        private void view (uint rpos) {
            var image = this.ring.nth_data (rpos);
            if (image.is_loaded ()) {
                this.loading.stop ();
                this.set_visible_child_full (rpos.to_string (), this.anim);
                message ("viewing ring pointer: %u, index %d", this.ringptr, image.get_index ());
            } else {
                // ring pointer is loading, show loading screen instead
                this.viewloading ();
            }
            this.sig_viewing_page (image.get_index ());
        }

        private uint sub (uint num) {
            // subtract with base = nbase
            return ((this.ringptr + (this.nbase - num)) % (this.nbase));
        }

        private uint plus (uint num) {
            // plus with base = nbase
            return (this.ringptr + (this.nbase + num)) % (this.nbase);
        }

        public void next () {
            // prefetch
            if (this.urlptr == this.num_pages - 1) {
                message ("last image loaded, doing nothing");
            } else {
                this.urlptr++;
                this.prefetch (this.sub (this.cprev), this.urlptr);
            }

            // view the next ptr
            this.ringptr = this.plus (1);
            this.view (this.ringptr);
        }

        public void prev () {
            // prefetch
            if (this.urlptr == 0) {
                message ("first image loaded, doing nothing");
            } else {
                this.urlptr--;
                this.prefetch (this.sub (this.cprev + 1), this.urlptr - (this.nbase - 1));
            }
            // view the previous ptr
            this.ringptr = this.sub (1);
            this.view (this.ringptr);
        }

        public void to_index (int index) {
        }

        public void init () {
            this.view (0);
        }
    }
}
