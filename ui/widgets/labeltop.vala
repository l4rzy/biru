
namespace Biru.UI.Widgets {
    public class LabelTop : Gtk.Label {
        public LabelTop (string header) {
            Object (
                label: header,
                wrap: false,
                margin_start: 40,
                // justify: Gtk.Justification.CENTER
                margin_end: 40
            );
        }

        public void search_result (string query) {
            this.label = @"Results for \"$(query)\"";
        }
    }
}
