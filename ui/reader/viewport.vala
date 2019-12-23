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
        private uint cnext { get; set; } // numbers of next pages to cache
        private uint ringptr { get; set; default = 0; } // points to the circle at which the current page is rendered
        private uint num_pages { get; set; }

        private List<string ? > urls;
        private Gtk.StackTransitionType anim_next;
        private Gtk.StackTransitionType anim_prev;
        private Gtk.StackTransitionType anim_load;

        private LoadingCircle loading;

        // since our list is relatively small (<1000)
        // so indexing would be fast enough
        private List<Reader.Image ? > ring;
        private List<Cancellable ? > ring_cancl;

        private signal void sig_loading_done (uint rpos);
        public signal void sig_viewing_page (int index);

        public ViewPort (int num_prev, int num_next, Cancellable ? cancl) {
            Object ();

            this.cancl = cancl;
            this.set_events (Gdk.EventMask.SCROLL_MASK);
            this.set_events (Gdk.EventMask.KEY_PRESS_MASK);

            this.nbase = num_prev + num_next + 1; // one current node
            this.cprev = num_prev;
            this.cnext = num_next;

            this.anim_next = Gtk.StackTransitionType.OVER_LEFT;
            this.anim_prev = Gtk.StackTransitionType.OVER_RIGHT;
            this.anim_load = Gtk.StackTransitionType.CROSSFADE;
            this.transition_duration = 120;

            this.ring = new List<Reader.Image ? >();
            this.loading = new LoadingCircle ();

            this.add_named (this.loading, "loading");
            for (var i = 0; i < this.nbase; i++) {
                var c = new Cancellable ();
                var img = new Reader.Image (c);
                this.add_named (img, i.to_string ());
                img.sig_loading_done.connect ((rpos) => {
                    if (rpos == this.ringptr) {
                        // loading is done, switch to ring pointer
                        message ("received sig_loading_done");
                        this.loading.stop ();
                        this.set_visible_child_full (rpos.to_string (), this.anim_load);
                    }
                });
                this.ring.append ((owned) img);
                this.ring_cancl.append ((owned) c);
            }

            this.cancl.cancelled.connect (() => {
                this.ring_cancl.foreach ((cancl) => {
                    message ("cancelled~");
                    cancl.cancel ();
                });
            });
        }

        // get the index associated with current node in prefetch ring
        private uint index () {
            return this.ring.nth_data (this.ringptr).get_index ();
        }

        // associate upos to rpos
        private void prefetch (uint rpos, uint upos) {
            // first cancel the previous loading if any
            this.ring_cancl.nth_data (rpos).cancel ();
            this.ring_cancl.nth_data (rpos).reset ();

            // then assosiate new index to ring and load it
            // this work with negative index, too, as long as
            // our nbase is not `too` big
            if (upos > this.urls.length () - 1) {
                message ("url out of bound, doing nothing");
                return;
            }

            var url = this.urls.nth_data (upos);
            this.ring.nth_data (rpos).load (url, rpos, upos);
            message ("ring pointer %u is associated with url pointer %u", rpos, upos);
        }

        public void load_book (Models.Book book, int index) {
            this.ringptr = 0; // current page is 0
            this.urls = book.get_page_urls ();
            this.num_pages = (uint) book.num_pages;

            // current page and next cached pages
            for (var i = 0; i <= this.cnext; i++) {
                this.prefetch (this.plus (i), (uint) index + i);
            }

            // previous cached pages
            for (var i = 1; i <= this.cprev; i++) {
                this.prefetch (this.sub (i), (uint) index - i);
            }
        }

        private void viewloading () {
            message ("view loading");
            this.loading.start ();
            this.set_visible_child_full ("loading", this.anim_load);
        }

        private void view (uint rpos, Gtk.StackTransitionType anim) {
            var image = this.ring.nth_data (rpos);
            if (image.is_loaded ()) {
                this.loading.stop ();
                this.set_visible_child_full (rpos.to_string (), anim);
                message ("viewing ring pointer: %u, index %u", this.ringptr, image.get_index ());
            } else {
                // ring pointer is loading, show loading screen instead
                this.loading.update ((int) image.get_index ());
                this.viewloading ();
            }
            this.sig_viewing_page ((int) image.get_index ());
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
            var urlptr = this.index () + this.cnext + 1;
            this.prefetch (this.sub (this.cprev), urlptr);

            // view the next ptr
            this.ringptr = this.plus (1);
            this.view (this.ringptr, this.anim_next);
        }

        public void prev () {
            // prefetch
            var urlptr = this.index () - this.cprev - 1;
            this.prefetch (this.sub (this.cprev + 1), urlptr);


            // view the previous ptr
            this.ringptr = this.sub (1);
            this.view (this.ringptr, this.anim_prev);
        }

        public void to_index (int index) {
        }

        public void init () {
            this.view (0, this.anim_load);
        }
    }
}
