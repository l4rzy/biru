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
using Biru.UI.Widgets;

namespace Biru.UI.Menus {
    public class BookCardMenu : Gtk.Popover {
        private Gtk.Grid grid;

        public signal void sig_pop_clicked (BookCardOption opt);

        public BookCardMenu (BookCard bookcard) {
            Object (
                relative_to: bookcard,
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

            var btn_details = new Gtk.Button.with_label (S.BOOKCARD_MENU_DETAILS);
            btn_details.get_style_context ().add_class ("birubutton");
            btn_details.can_focus = false;

            var btn_fav = new Gtk.Button.with_label (S.BOOKCARD_MENU_FAVOR);
            btn_fav.get_style_context ().add_class ("birubutton");
            btn_fav.can_focus = false;

            var btn_download = new Gtk.Button.with_label (S.BOOKCARD_MENU_DOWNLOAD);
            btn_download.can_focus = false;
            btn_download.get_style_context ().add_class ("birubutton");

            grid.attach (btn_read, 0, 1, 1, 1);
            grid.attach (btn_details, 0, 2, 1, 1);
            grid.attach (btn_fav, 0, 3, 1, 1);
            grid.attach (btn_download, 0, 4, 1, 1);

            grid.show_all ();
            this.add (this.grid);

            // signals
            btn_read.clicked.connect (() => {
                sig_pop_clicked (BOOKCARD_READ);
            });

            btn_details.clicked.connect (() => {
                sig_pop_clicked (BOOKCARD_DETAILS);
            });

            btn_fav.clicked.connect (() => {
                sig_pop_clicked (BOOKCARD_FAVOR);
            });

            btn_download.clicked.connect (() => {
                sig_pop_clicked (BOOKCARD_DOWNLOAD);
            });
        }
    }
}
