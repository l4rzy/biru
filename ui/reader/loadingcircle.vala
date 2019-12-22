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

namespace Biru.UI.Reader {
    public class LoadingCircle : Gtk.Box {
        private Gtk.Overlay overlay;
        private Gtk.Spinner spinner;
        private Gtk.Label page;

        public LoadingCircle () {
            Object (
                orientation: Gtk.Orientation.VERTICAL,
                spacing: 0
            );

            this.overlay = new Gtk.Overlay ();
            this.spinner = new Gtk.Spinner ();
            this.progress = new Gtk.ProgressBar ();

            this.overlay.add (this.spinner);
            this.overlay.add (this.progress);

            this.show_all ();
        }

        public void start () {
            this.spinner.active = true;
        }

        public void stop () {
            this.spinner.active = false;
        }
    }
}
