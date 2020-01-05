using Gtk;
using Biru.UI.Configs;
namespace Biru.UI.Windows {

    public class SettingWindow : Window {

        private Button btn_apply;
        private Button btn_cancel;

        public SettingWindow () {
            init_ui ();

            btn_apply.clicked.connect (btn_apply_clicked);
            btn_cancel.clicked.connect (btn_cancel_clicked);
        }

        private void init_ui () {

            var stack = new Stack ();
            stack.add_titled (new Biru.UI.Widgets.CommonSettingBox (), "CommonSettingBox", "Common");
	    stack.add_titled ( new Biru.UI.Widgets.HomePageSettingBox(), "HomePageSettingBox", "Home page");

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
            set_default_size (480, 680);
            show_all ();
        }

        private void btn_apply_clicked () {
            close ();
        }

        private void btn_cancel_clicked () {
            close ();
        }
    }
}
