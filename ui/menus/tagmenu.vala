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
using Biru.UI.Configs;
using Biru.UI.Widgets;

namespace Biru.UI.Menus {
    public enum TagOption {
        TAG_OPTION_FAV,
        TAG_OPTION_SEARCH,
        TAG_OPTION_COPYLINK
    }

    public class TagMenu : Gtk.Popover {
        private Gtk.Grid grid;

        public signal void sig_pop_clicked (Models.Tag tag, TagOption opt);

        public TagMenu (TagButton tagbtn) {
            Object (
                relative_to: tagbtn,
                position: Gtk.PositionType.TOP,
                modal: true
            );
            this.get_style_context ().add_class ("bookcardpop");
            this.grid = new Gtk.Grid ();
            grid.margin = 12;
            grid.column_spacing = 8;
            grid.row_spacing = 8;

            var btn_fav = new Gtk.Button.with_label (S.TAG_MENU_FAVOR);
            btn_fav.get_style_context ().add_class ("birubutton");
            btn_fav.can_focus = false;

            var btn_search = new Gtk.Button.with_label (S.TAG_MENU_SEARCH);
            btn_search.get_style_context ().add_class ("birubutton");
            btn_search.can_focus = false;

            var btn_copy = new Gtk.Button.with_label (S.TAG_MENU_COPYLINK);
            btn_copy.get_style_context ().add_class ("birubutton");
            btn_copy.can_focus = false;

            grid.attach (btn_fav, 0, 1, 1, 1);
            grid.attach (btn_search, 0, 2, 1, 1);
            grid.attach (btn_copy, 0, 3, 1, 1);

            grid.show_all ();
            this.add (this.grid);

            // signals
            btn_fav.clicked.connect (() => {
                this.popdown ();
                sig_pop_clicked (tagbtn.tag, TAG_OPTION_FAV);
            });

            btn_search.clicked.connect (() => {
                this.popdown ();
                sig_pop_clicked (tagbtn.tag, TAG_OPTION_SEARCH);
            });

            btn_copy.clicked.connect (() => {
                this.popdown ();
                sig_pop_clicked (tagbtn.tag, TAG_OPTION_COPYLINK);
            });
        }
    }
}
