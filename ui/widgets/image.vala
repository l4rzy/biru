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

// originally copied and modified from Granite.AsyncImage
// to drop out granite dependency
namespace Biru.UI.Widgets {

    public class Image : Gtk.Image {
        private int current_scale_factor = 1;
        public int width { get; set; }
        public int height { get; set; }
        private static Soup.Session? session;
        private Cancellable cnl;

        public Image () {
            Object ();
            if (session == null) {
                session = new Soup.Session();
            }
        }

        public async void set_from_file_async (File file,
                                               int width,
                                               int height,
                                               bool preserve_aspect_ratio,
                                               Cancellable ? cancellable = null) throws Error {
            this.cnl = cancellable;
            set_size_request (width, height);

            try {
                var stream = yield file.read_async ();

                var pixbuf = yield new Gdk.Pixbuf.from_stream_at_scale_async (
                    stream,
                    width * this.current_scale_factor,
                    height * this.current_scale_factor,
                    preserve_aspect_ratio,
                    cancellable
                );
                this.surface = Gdk.cairo_surface_create_from_pixbuf (pixbuf, this.current_scale_factor, null);
                // set_size_request (-1, -1);
            } catch (Error e) {
                // set_size_request (-1, -1);
                throw e;
            }
        }

        public async void set_from_url_async (string url,
                                              int max_width,
                                              int max_height,
                                              bool preserve_aspect_ratio,
                                              Cancellable ? cancellable = null) throws Error {
            try {
                var mess = new Soup.Message ("GET", url);
                var stream = yield Image.session.send_async (mess, null);

                var pixbuf = yield new Gdk.Pixbuf.from_stream_async (
                    stream,
                    cancellable
                );

                // scale pixbuf to max size
                if (preserve_aspect_ratio) {
                    var real_width = pixbuf.get_width ();
                    var real_height = pixbuf.get_height ();
                    var ratio = max_width / (double) real_width;

                    this.width = (int) (ratio * real_width);
                    this.height = (int) (ratio * real_height);
                } else {
                    this.width = max_width;
                    this.height = max_height;
                }

                var npixbuf = pixbuf.scale_simple (this.width, this.height, Gdk.InterpType.BILINEAR);
                this.surface = Gdk.cairo_surface_create_from_pixbuf (npixbuf, this.current_scale_factor, null);
            } catch (Error e) {
                throw e;
            }
        }

        public void cancel () {
        }
    }
}

