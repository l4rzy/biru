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
using Biru.UI;

namespace Biru.UI.Reader {
    public class Image : Gtk.Overlay {
        private unowned Cancellable ? cancl;
        private bool loaded { get; set; default = false; }
        private uint page { get; set; }
        private Widgets.Image image;

        public signal void sig_loading_done (uint rpos);

        public Image (Cancellable ? cancl) {
            this.cancl = cancl;
            this.image = new Widgets.Image ();
            this.add (image);
        }

        public void load (string url, uint rpos, uint upos) {
            this.loaded = false;
            this.image.clear ();
            this.page = upos;
            this.image.set_from_url_async.begin (url, Reader.Constants.READER_DEFAULT_W,
                                                 Reader.Constants.READER_DEFAULT_H, true, this.cancl, () => {
                this.loaded = true;
                this.sig_loading_done (rpos);
            });
        }

        public bool is_loaded () {
            return this.loaded;
        }

        public int get_index () {
            return (int) this.page;
        }
    }
}
