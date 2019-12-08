using Biru.UI.Configs;

namespace Biru.UI.Windows {
    class MainWin : Gtk.ApplicationWindow {
        public MainWin (Gtk.Application app) {
            Object (
                application: app,
                resizable: true
            );

            set_default_size (Constants.WINDOW_X, Constants.WINDOW_Y);
        }
    }
}
