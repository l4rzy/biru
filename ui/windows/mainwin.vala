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

namespace Biru.UI.Windows {
    class MainWin : Gtk.ApplicationWindow {
        public MainWin (Gtk.Application app) {
            Object (
                application: app,
                resizable: true
            );

            set_default_size (Constants.WINDOW_X, Constants.WINDOW_Y);

            var css_provider = new Gtk.CssProvider ();
            css_provider.load_from_resource (Constants.RESOURCE_CSS);

            Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default (),
                css_provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        }
    }
}
