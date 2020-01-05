namespace Biru.UI.Controllers {
    public class SettingsWindowCtl {

        private Windows.SettingsWindow view;

        public SettingsWindowCtl () {
        }

        private void on_btn_apply_clicked () {
            view.close ();
            view = null;
        }

        private void on_btn_cancel_clicked () {
            view.close ();
            view = null;
        }

        public void show_window () {
            if (view != null) {
                view.show_all ();
                return;
            }
            view = new Windows.SettingsWindow ();
            view.btn_apply.clicked.connect (on_btn_apply_clicked);
            view.btn_cancel.clicked.connect (on_btn_cancel_clicked);
            view.btn_apply.sensitive = false;
            view.show_all ();
        }

        private void apply_changes () {
        }
    }
}
