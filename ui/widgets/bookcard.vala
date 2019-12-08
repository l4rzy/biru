using Biru.Service;

namespace Biru.UI.Widgets {
    public class BookCard : Gtk.Box {
        private File file;
        private Models.Book book;
        private Granite.AsyncImage image;
        private int w;
        private int h;
        
        private API api;

        public BookCard(Models.Book book) {
            this.api = API.get();
            this.book = book;
            this.can_focus = false;
            this.orientation = Gtk.Orientation.VERTICAL;
            this.halign = Gtk.Align.CENTER;
            this.valign = Gtk.Align.START;
            this.margin_start = 8;
            this.margin_end = 8;
            this.margin_top = 12;
            this.margin_bottom = 2;
            
            // json are all about int64
            this.w = (int)book.images.thumbnail.w;
            this.h = (int)book.images.thumbnail.h;
                        
            this.image = new Granite.AsyncImage(true, true);
            this.file = File.new_for_uri(book.thumb_url());
            
            assert(this.file != null);

            this.image.set_from_file_async.begin(this.file, this.w, this.h, true, null);
            this.add(this.image);
            this.show_all();
        }
    }
}
