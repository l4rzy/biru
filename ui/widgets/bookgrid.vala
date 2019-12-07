using Biru.Service;

namespace Biru.UI.Widgets {
    public class BookGrid : Gtk.FlowBox {
        private unowned List<Models.Book?> books;

        public BookGrid() {
            this.margin_end = 10;
            this.margin_start = 10;
            this.set_selection_mode(Gtk.SelectionMode.NONE);
            this.activate_on_single_click = false;
            this.homogeneous = false;
            this.orientation = Gtk.Orientation.HORIZONTAL;
        }

        public void insert_cards(List<Models.Book?> books) {
            this.books = books;

            foreach (var b in this.books) {
                var card = new BookCard(b);
                this.add(card);
                card.show_all();
            }
        }

        public void clean() {
            this.@foreach((w) => {
                w.destroy();
            });
        }
    }
}
