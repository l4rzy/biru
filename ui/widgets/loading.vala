
namespace Biru.UI.Widgets {
    public class Loading : Gtk.Box {
        private Gtk.Spinner spinner;
        public Loading() {
            Object(
                orientation: Gtk.Orientation.VERTICAL,
                valign: Gtk.Align.CENTER,
                halign: Gtk.Align.CENTER
            );

            spinner = new Gtk.Spinner();
            spinner.active = true;

            this.add(spinner);
        }

        public void stop() {
            this.spinner.active = false;
        }
    }
}
