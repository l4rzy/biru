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

using Biru.Service;
using Biru.Utils;
using Biru.UI.Configs;

namespace Biru.UI.Widgets {
    public class TagButton : Gtk.Button {
        private unowned Models.Tag tag;

        public signal void sig_tag_clicked (Models.Tag tag);

        public TagButton (Models.Tag tag) {
            this.get_style_context ().add_class (@"tagbtn_$(tag._type)");
            this.tag = tag;
            // this.hexpand = false;
            // message(String.wrap (tag.name, Constants.TAG_MAX_LEN));
            this.set_label (tag.name);
            this.show_all ();
        }
    }

    public class TagCat : Gtk.Box {
        private Gtk.Label label;
        private Gtk.FlowBox fbox;

        public signal void sig_tag_clicked (Models.Tag tag);

        public TagCat (string title) {
            Object (orientation: Gtk.Orientation.VERTICAL);
            this.label = new Gtk.Label (title);
            this.label.get_style_context ().add_class ("tagcat");

            this.fbox = new Gtk.FlowBox ();
            this.fbox.margin_end = 20;
            this.fbox.margin_start = 20;
            this.fbox.set_selection_mode (Gtk.SelectionMode.NONE);
            this.fbox.activate_on_single_click = false;
            this.fbox.homogeneous = false;
            this.fbox.column_spacing = 20;
            this.fbox.orientation = Gtk.Orientation.HORIZONTAL;
            this.fbox.max_children_per_line = 3;

            this.pack_start (this.label);
            this.pack_start (this.fbox);

            this.show_all ();
        }

        public void add_tag (TagButton tagbtn) {
            // message("adding a tag to tagcat");
            tagbtn.sig_tag_clicked.connect ((tag) => {
                this.sig_tag_clicked (tag);
            });
            this.fbox.add (tagbtn);
        }
    }
}
