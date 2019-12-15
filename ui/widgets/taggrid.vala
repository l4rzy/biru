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

using Biru.Service.Models;

namespace Biru.UI.Widgets {
    public class TagGrid : Gtk.FlowBox {
        private unowned List<Tag ? > tags;

        public signal void sig_tag_clicked (Tag tag);

        public TagGrid () {
            Object ();
            this.margin_end = 20;
            this.margin_start = 20;
            this.set_selection_mode (Gtk.SelectionMode.NONE);
            this.activate_on_single_click = false;
            this.homogeneous = false;
            this.column_spacing = 20;
            this.orientation = Gtk.Orientation.HORIZONTAL;
        }

        public void insert_tags (List<Tag ? > tags) {
            this.tags = tags;

            foreach (Tag t in this.tags) {
                var tag = new TagButton (t);

                tag.clicked.connect (() => {
                    sig_tag_clicked (t);
                });
                this.add (tag);
                tag.show_all ();
            }
        }
    }
}
