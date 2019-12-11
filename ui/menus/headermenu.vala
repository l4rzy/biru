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
    public class HeaderMenu : Gtk.Popover {
        private Gtk.Image logo;
        public HeaderMenu (Gtk.Widget widget) {
            Object (
                relative_to: widget,
                position: Gtk.PositionType.TOP,
                modal: true
            );
            this.logo = new Gtk.Image.from_resource (Constants.RESOURCE_NH_LOGO);
            this.add (this.logo);
            this.logo.show_all ();
        }
    }
}
