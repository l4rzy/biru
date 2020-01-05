namespace Biru.UI.Widgets {
    public class ReaderSettingsBox : Gtk.Box {

        public Gtk.SpinButton spin_btn_next_cache { get; private set; }
        public Gtk.SpinButton spin_btn_prev_cache { get; private set; }
        public Gtk.Switch switch_save_dimention { get; private set; }
        public ReaderSettingsBox () {
            Object (orientation: Gtk.Orientation.VERTICAL, spacing: 0);
            init_ui ();
        }

        private void init_ui () {
            var box1 = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            var label_next_cache = new Gtk.Label (Configs.S.SETTING_READER_NEXT_CACHE);
            label_next_cache.margin_start = Configs.Constants.SETTING_BOX_MARGIN;
            label_next_cache.halign = Gtk.Align.START;
            box1.pack_start (label_next_cache, false, false, 0);
            var adjustment_next_cache = new Gtk.Adjustment (1, 1, 10, 1, 1, 1);
            spin_btn_next_cache = new Gtk.SpinButton (adjustment_next_cache, 1, 1);
            spin_btn_next_cache.halign = Gtk.Align.END;
            spin_btn_next_cache.margin_end = Configs.Constants.SETTING_BOX_MARGIN;
            box1.pack_end (spin_btn_next_cache, false, false, 0);

            var box2 = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            var label_prev_cache = new Gtk.Label (Configs.S.SETTING_READER_PREV_CACHE);
            label_prev_cache.margin_start = Configs.Constants.SETTING_BOX_MARGIN;
            label_prev_cache.halign = Gtk.Align.START;
            box2.pack_start (label_prev_cache, false, false, 0);
            var adjustment_prev_cache = new Gtk.Adjustment (1, 1, 10, 1, 1, 1);
            spin_btn_prev_cache = new Gtk.SpinButton (adjustment_prev_cache, 1, 1);
            spin_btn_prev_cache.halign = Gtk.Align.END;
            spin_btn_prev_cache.margin_end = Configs.Constants.SETTING_BOX_MARGIN;
            box2.pack_end (spin_btn_prev_cache, false, false, 0);

            var box3 = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            var label_save_dimention = new Gtk.Label (Configs.S.SETTING_READER_NEXT_CACHE);
            label_save_dimention.margin_start = Configs.Constants.SETTING_BOX_MARGIN;
            label_save_dimention.halign = Gtk.Align.START;
            box3.pack_start (label_save_dimention, false, false, 0);
            switch_save_dimention = new Gtk.Switch ();
            switch_save_dimention.halign = Gtk.Align.END;
            switch_save_dimention.margin_end = Configs.Constants.SETTING_BOX_MARGIN;
            box3.pack_end (switch_save_dimention, false, false, 0);
            pack_start (box1, false, false, 10);
            pack_start (box2, false, false, 10);
            pack_start (box3, false, false, 10);
        }
    }
}
