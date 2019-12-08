
using Biru.Service;

namespace Biru.UI.Widgets {
    public class Loading : Gtk.Box {
        private Gtk.Spinner spinner;
        public Loading () {
            Object (
                orientation: Gtk.Orientation.VERTICAL,
                valign: Gtk.Align.CENTER,
                halign: Gtk.Align.CENTER
            );

            spinner = new Gtk.Spinner ();
            spinner.active = false;

            this.add (spinner);
        }

        public void stop () {
            this.spinner.active = false;
        }

        public void start () {
            this.spinner.active = true;
        }
    }
}
