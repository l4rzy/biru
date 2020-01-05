using Biru.UI.Configs;
namespace Biru.UI.Widgets {
    public class HomePageSettingsBox : Gtk.Box {
        public Gtk.ComboBox combo_box_home_sort { get; private set; default = null; }
        public Gtk.ComboBox combo_box_search_sort { get; private set; default = null; }
        public HomePageSettingsBox () {
            Object (orientation: Gtk.Orientation.VERTICAL, spacing: 0);
            init_ui ();
        }

        private void init_ui () {
            var box1 = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            var label_home_sort = new Gtk.Label (S.SETTING_HOME_PAGE_HOME_SORT);
            label_home_sort.margin_start = Constants.SETTING_BOX_MARGIN;
            label_home_sort.halign = Gtk.Align.START;
            box1.pack_start (label_home_sort, false, false, 0);
            combo_box_home_sort = new Gtk.ComboBox ();
            combo_box_home_sort.margin_end = Constants.SETTING_BOX_MARGIN;
            combo_box_home_sort.halign = Gtk.Align.END;
            box1.pack_end (combo_box_home_sort, false, false, 0);

            var box2 = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            var label_search_sort = new Gtk.Label (S.SETTING_HOME_PAGE_SEARCH_SORT);
            label_search_sort.margin_start = Constants.SETTING_BOX_MARGIN;
            label_search_sort.halign = Gtk.Align.START;
            box2.pack_start (label_search_sort, false, false, 0);
            combo_box_search_sort = new Gtk.ComboBox ();
            combo_box_search_sort.margin_end = Constants.SETTING_BOX_MARGIN;
            combo_box_search_sort.halign = Gtk.Align.END;
            box2.pack_end (combo_box_search_sort, false, false, 0);

            pack_start (box1, false, false, 10);
            pack_start (box2, false, false, 10);
        }
    }
}
