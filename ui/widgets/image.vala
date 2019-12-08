
// copied and simplified from Granite.AsyncImage
// to drop out granite dependency
namespace Biru.UI.Widgets {

    public class Image : Gtk.Image {
        private int current_scale_factor = 1;

        public Image () {
            Object ();
        }

        public async void set_from_file_async (File file,
                                               int width,
                                               int height,
                                               bool preserve_aspect_ratio,
                                               Cancellable ? cancellable = null) throws Error {
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
                surface = Gdk.cairo_surface_create_from_pixbuf (pixbuf, this.current_scale_factor, null);
                // set_size_request (-1, -1);
            } catch (Error e) {
                // set_size_request (-1, -1);
                throw e;
            }
        }
    }
}

