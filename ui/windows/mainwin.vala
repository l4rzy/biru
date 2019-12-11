using Biru.UI.Configs;

namespace Biru.UI.Windows {
    class MainWin : Gtk.ApplicationWindow {
        public MainWin (Gtk.Application app) {
            Object (
                application: app,
                resizable: true
            );

            set_default_size (Constants.WINDOW_X, Constants.WINDOW_Y);

            var css_provider = new Gtk.CssProvider ();
            css_provider.load_from_resource (Constants.RESOURCE_CSS);

            Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default (),
                css_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        }
    }
}
