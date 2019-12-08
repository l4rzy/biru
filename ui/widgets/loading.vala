
using Biru.Service;

namespace Biru.UI.Widgets {
    public class Loading : Gtk.Box {
        private Gtk.Spinner spinner;
        private Gtk.Image icon;
        public Loading () {
            Object (
                orientation: Gtk.Orientation.VERTICAL,
                valign: Gtk.Align.CENTER,
                halign: Gtk.Align.CENTER
            );

            spinner = new Gtk.Spinner ();
            icon = new Gtk.Image.from_icon_name ("network-idle-symbolic", Gtk.IconSize.BUTTON);

            spinner.active = false;

            this.add (spinner);
            this.add (icon);
        }

        public void stop () {
            this.spinner.active = false;
            this.spinner.hide ();
            this.icon.visible = true;
        }

        public void start () {
            this.spinner.active = true;
            this.spinner.show ();
            this.icon.visible = false;
        }
    }
}
