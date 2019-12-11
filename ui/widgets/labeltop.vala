/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 *
 */

namespace Biru.UI.Widgets {
    public class LabelTop : Gtk.Label {
        private string header { get; set; }

        public LabelTop (string header) {
            Object (
                label: header,
                wrap: false,
                margin_start: 40,
                // justify: Gtk.Justification.CENTER
                margin_end: 40,
                margin_top: 6
            );

            this.header = header;
            this.get_style_context ().add_class ("labeltop");
        }

        public void search_result (string query) {
            this.label = @"Results for \"$(query)\"";
        }

        public void home () {
            this.label = this.header;
        }
    }
}
