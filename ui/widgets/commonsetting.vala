namespace Biru.UI.Widgets {
    public class CommonSettingBox : Gtk.Box {
        private static const int MARIGIN = 20;
        private Gtk.SpinButton spin_btn_network_threads;
        private Gtk.Switch switch_save_dimention;
        public CommonSettingBox () {
            Object (orientation: Gtk.Orientation.VERTICAL, spacing: 0);
            init_ui ();
        }

        private void init_ui () {

            var adjustment = new Gtk.Adjustment (1, 1, 10, 1, 1, 1);

            spin_btn_network_threads = new Gtk.SpinButton (adjustment, 1, 1);
            spin_btn_network_threads.margin_end = MARIGIN;
            spin_btn_network_threads.halign = Gtk.Align.END;

            switch_save_dimention = new Gtk.Switch ();
            switch_save_dimention.margin_end = MARIGIN;
            switch_save_dimention.halign = Gtk.Align.END;

            var box1 = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 1);
            var label_network_threads = new Gtk.Label (Configs.S.SETTING_COMMON_BOX_NETWORK_THREADS);
            label_network_threads.margin_start = MARIGIN;
            label_network_threads.halign = Gtk.Align.START;
            box1.pack_start (label_network_threads);
            box1.pack_end (spin_btn_network_threads);

            var box2 = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 1);
            var label_save_dimention = new Gtk.Label (Configs.S.SETTING_COMMON_BOX_SAVE_DIMENTION);
            label_save_dimention.margin_start = MARIGIN;
            label_save_dimention.halign = Gtk.Align.START;
            box2.pack_start (label_save_dimention);
            box2.pack_end (switch_save_dimention);

            pack_start (box1, false, false, 10);
            pack_start (box2, false, false, 10);
        }

        public Gtk.SpinButton get_spin_btn_network_threads () {
            return spin_btn_network_threads;
        }

        public Gtk.Switch get_switch_save_dimention () {
            return switch_save_dimention;
        }
    }
}
