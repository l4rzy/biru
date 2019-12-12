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

using Biru.UI.Configs;

namespace Biru.UI.Menus {
    public class BookCardMenu : Gtk.Popover {
        private Gtk.Grid grid;

        public signal void sig_pop_clicked ();

        public BookCardMenu (Gtk.Widget widget) {
            Object (
                relative_to: widget,
                position: Gtk.PositionType.TOP,
                modal: true
            );
            this.grid = new Gtk.Grid ();
            this.get_style_context ().add_class ("bookcardpop");
            grid.margin = 12;
            grid.column_spacing = 8;
            grid.row_spacing = 8;

            var btn_read = new Gtk.Button.with_label (S.BOOKCARD_MENU_READ);
            btn_read.get_style_context ().add_class ("birubutton");
            btn_read.can_focus = false;
            var btn_fav = new Gtk.Button.with_label (S.BOOKCARD_MENU_FAVOR);
            btn_fav.get_style_context ().add_class ("birubutton");
            btn_fav.can_focus = false;
            var btn_download = new Gtk.Button.with_label (S.BOOKCARD_MENU_DOWNLOAD);
            btn_download.can_focus = false;
            btn_download.get_style_context ().add_class ("birubutton");

            grid.attach (btn_read, 0, 1, 1, 1);
            grid.attach (btn_fav, 0, 2, 1, 1);
            grid.attach (btn_download, 0, 3, 1, 1);

            grid.show_all ();
            this.add (this.grid);

            // signals
            btn_read.clicked.connect (() => {
                sig_pop_clicked ();
            });
        }
    }
}
