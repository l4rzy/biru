using Gtk;
using Biru.UI.Configs;
namespace Biru.UI.Windows {

    public class SettingsWindow : Window {

        public Button btn_apply { get; private set; }
        public Button btn_cancel { get; private set; }

        public Widgets.CommonSettingsBox common_settings_box { get; private set; }
        public Widgets.HomePageSettingsBox home_page_settings_box { get; private set; }
        public Widgets.ReaderSettingsBox reader_settings_box { get; private set; }

        public signal void sig_value_change ();

        public SettingsWindow () {
            init_ui ();
        }

        private void init_ui () {

            var stack = new Stack ();
            stack.add_titled (common_settings_box = new Widgets.CommonSettingsBox (), "CommonSettingBox", "Common");
            stack.add_titled (home_page_settings_box = new Widgets.HomePageSettingsBox (), "HomePageSettingBox", "Home page");
            stack.add_titled (reader_settings_box = new Widgets.ReaderSettingsBox (), "ReaderSettingsBox", "Reader");

            btn_cancel = new Button.with_label (S.SETTING_CANCEL);

            btn_apply = new Button.with_label (S.SETTING_APPLY);

            var stack_switcher = new StackSwitcher ();
            stack_switcher.stack = stack;
            stack_switcher.halign = Gtk.Align.CENTER;

            var header_bar = new HeaderBar ();
            header_bar.pack_start (btn_cancel);
            header_bar.add (stack_switcher);
            header_bar.pack_end (btn_apply);

            set_titlebar (header_bar);
            add (stack);
            set_default_size (640, 480);
            show_all ();
        }
    }
}
