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

namespace Biru.UI.Widgets {
    public class Loading : Gtk.Box {
        private Gtk.Spinner spinner;
        private Gtk.Image icon;
        public Loading () {
            Object (
                orientation: Gtk.Orientation.VERTICAL,
                valign: Gtk.Align.CENTER,
                halign: Gtk.Align.CENTER
            );

            spinner = new Gtk.Spinner ();
            icon = new Gtk.Image.from_icon_name ("object-select-symbolic", Gtk.IconSize.BUTTON);

            spinner.active = false;

            this.add (spinner);
            this.add (icon);
        }

        public void stop () {
            this.spinner.active = false;
            this.spinner.hide ();
            this.icon.visible = true;
        }

        public void start () {
            this.spinner.active = true;
            this.spinner.show ();
            this.icon.visible = false;
        }
    }
}
