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

using Biru.UI.Windows;
using Biru.UI.Configs;

namespace Biru.UI.Menus {
    public class HeaderMenu : Gtk.Popover {
        private Gtk.Grid grid;

        public signal void sig_pop_clicked ();

        public HeaderMenu (Gtk.Widget widget) {
            Object (
                relative_to: widget,
                position: Gtk.PositionType.TOP,
                modal: true
            );
            this.grid = new Gtk.Grid ();
            grid.margin = 12;
            grid.column_spacing = 8;
            grid.row_spacing = 8;

            var btn_settings = new Gtk.Button.with_label (S.HEADER_MENU_SETTINGS);
            btn_settings.get_style_context ().add_class ("birubutton");
            btn_settings.can_focus = false;
            var btn_about = new Gtk.Button.with_label (S.HEADER_MENU_ABOUT);
            btn_about.get_style_context ().add_class ("birubutton");
            btn_about.can_focus = false;

            grid.attach (btn_settings, 0, 1, 1, 1);
            grid.attach (btn_about, 0, 2, 1, 1);

            grid.show_all ();
            this.add (this.grid);

            // signals
            btn_about.clicked.connect (() => {
                message ("Biru is an online manga reading utility");
                this.popdown ();
                var about = new AboutWindow ();
                about.present ();
            });
        }
    }
}
