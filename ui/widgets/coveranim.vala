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

using Biru.Service.Models;
using Biru.UI.Configs;

namespace Biru.UI.Widgets {
    public class CoverAnim : Gtk.Button {
        private Gtk.Overlay overlay;
        private Image image;

        private Gtk.Box imagecon;
        private int w { get; set; default = Constants. }
        private int h;

        public CoverAnim (Models.Book book) {


            this.overlay = new Gtk.Overlay ();
            this.overlay.can_focus = false;
            this.overlay.halign = Gtk.Align.CENTER;
            this.overlay.width_request = this.w;
            this.overlay.height_request = this.h + 42; // TODO: handle this better
        }
    }
}
