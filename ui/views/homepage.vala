using Biru.Service;
using Biru.UI.Widgets;

// home view that partly acts as a controller on its own
namespace Biru.UI.Views {
    public enum HomeType {
        HOME_HOME,
        HOME_SEARCH
    }

    public class Home : Gtk.ScrolledWindow {
        // common fields
        private bool continous { get; set; default = false; }
        private API api;
        public int api_page { get; set; default = 1; }
        private HomeType home_type { get; set; default = HOME_HOME; }
        private SortType home_sort { get; set; default = SORT_POPULAR; }

        // widgets
        private LabelTop label;
        private BookGrid grid;
        private Gtk.Box content;

        // signals
        public signal void sig_scroll_bottom ();
        public signal void sig_loading ();
        public signal void sig_loading_done ();

        public Home () {
            this.api = API.get ();

            this.label = new LabelTop ("Homepage");
            this.content = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
            this.grid = new BookGrid ();

            this.content.add (label);
            this.content.add (grid);

            this.add (this.content);

            // connect signals
            this.api.sig_search_ok.connect ((lst) => {
                message ("home search ok!");
                this.label.search_result (this.api.last_query);
                this.home_type = HOME_SEARCH;
                if (!this.continous) {
                    this.clean ();
                }
                this.continous = false;
                this.insert_books (lst);
            });

            this.api.sig_homepage_ok.connect ((lst) => {
                message ("home loading ok!");
                this.home_type = HOME_HOME;
                if (!this.continous) {
                    this.clean ();
                }
                this.continous = false;
                this.insert_books (lst);
            });

            this.edge_reached.connect ((pos) => {
                if (pos == Gtk.PositionType.BOTTOM) {
                    message ("scrolling reached bottom");
                    sig_scroll_bottom ();
                    this.continous = true;
                    this.api_page++;
                    if (this.home_type == HOME_HOME) {
                        this.api.homepage (this.api_page, home_sort);
                    } else {
                        var query = this.api.last_query;
                        this.api.search (query, this.api_page, home_sort);
                    }
                    this.sig_loading ();
                }
            });
        }

        // to request homepage again
        public void reset () {
            this.api_page = 1;
            this.label.home ();
            this.api.homepage (this.api_page, home_sort);
            this.sig_loading ();
        }

        public void insert_books (List<Models.Book ? > lst) {
            this.grid.insert_books (lst);
            this.sig_loading_done ();
        }

        public void clean () {
            this.api_page = 1;
            this.get_vadjustment ().set_value (0);
            this.grid.clean ();
            // this.set_placement(Gtk.CornerType.TOP_RIGHT);
        }
    }
}
