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

using Biru.UI;
using Biru.UI.Configs;

namespace Biru.UI.Menus {
    public enum PageCardOpt {
        PAGECARD_READ,
        PAGECARD_DOWNLOAD,
        PAGECARD_COPYLINK,
        PAGECARD_INFO
    }

    public class PageCardMenu : Gtk.Popover {
        private Gtk.Grid grid;

        public signal void sig_pop_clicked (PageCardOpt opt);

        public PageCardMenu (Widgets.PageCard pagecard) {
            Object (
                relative_to: pagecard,
                position: Gtk.PositionType.TOP,
                modal: true
            );
            this.grid = new Gtk.Grid ();
            this.get_style_context ().add_class ("pagecardpop");
            grid.margin = 12;
            grid.column_spacing = 8;
            grid.row_spacing = 8;

            var btn_read = new Gtk.Button.with_label (S.PAGECARD_MENU_READ);
            btn_read.get_style_context ().add_class ("birubutton");
            btn_read.can_focus = false;

            var btn_download = new Gtk.Button.with_label (S.PAGECARD_MENU_DOWNLOAD);
            btn_download.get_style_context ().add_class ("birubutton");
            btn_download.can_focus = false;

            var btn_copy = new Gtk.Button.with_label (S.PAGECARD_MENU_COPYLINK);
            btn_copy.get_style_context ().add_class ("birubutton");
            btn_copy.can_focus = false;

            var btn_info = new Gtk.Button.with_label (S.PAGECARD_MENU_INFO);
            btn_info.get_style_context ().add_class ("birubutton");
            btn_info.can_focus = false;

            grid.attach (btn_read, 0, 1, 1, 1);
            grid.attach (btn_download, 0, 2, 1, 1);
            grid.attach (btn_copy, 0, 3, 1, 1);
            grid.attach (btn_info, 0, 4, 1, 1);

            grid.show_all ();
            this.add (this.grid);

            // signals
            btn_read.clicked.connect (() => {
                this.popdown ();
                sig_pop_clicked (PAGECARD_READ);
            });

            btn_download.clicked.connect (() => {
                this.popdown ();
                sig_pop_clicked (PAGECARD_DOWNLOAD);
            });

            btn_copy.clicked.connect (() => {
                this.popdown ();
                sig_pop_clicked (PAGECARD_COPYLINK);
            });

            btn_info.clicked.connect (() => {
                this.popdown ();
                sig_pop_clicked (PAGECARD_INFO);
            });
        }
    }
}
