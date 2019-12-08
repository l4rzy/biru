
namespace Biru.UI.Widgets {
    public class LabelTop : Gtk.Label {
        private string header { get; set; }

        public LabelTop (string header) {
            Object (
                label: header,
                wrap: false,
                margin_start: 40,
                // justify: Gtk.Justification.CENTER
                margin_end: 40
            );

            this.header = header;
        }

        public void search_result (string query) {
            this.label = @"Results for \"$(query)\"";
        }

        public void home () {
            this.label = this.header;
        }
    }
}
