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
using Biru.UI.Menus;

namespace Biru.UI.Widgets {
    public enum RightBarBtn {
        RIGHTBAR_BROWSER,
        RIGHTBAR_SHARE,
        RIGHTBAR_OPTIONS,
        RIGHTBAR_PROTECT
    }

    public class RightBar : Gtk.Box {
        private Gtk.Button options;
        private Gtk.Button protect;
        private Gtk.Button fav;
        private Gtk.Button read;

        private HeaderMenu menu;

        public signal void sig_selected (RightBarBtn btn);

        public RightBar () {
            this.options = new Gtk.Button.from_icon_name ("view-more-horizontal-symbolic");
            this.protect = new Gtk.Button.from_icon_name ("system-lock-screen-symbolic");
            this.fav = new Gtk.Button.from_icon_name ("emblem-favorite-symbolic");
            this.read = new Gtk.Button.from_icon_name ("view-paged-symbolic");

            this.pack_start (this.fav);
            this.pack_start (this.read);
            this.pack_start (this.options);
            this.pack_end (this.protect);

            this.menu = new HeaderMenu (this.options);

            this.options.clicked.connect (() => {
                menu.popup ();
            });

            // signals
            this.options.clicked.connect (() => {
                sig_selected (RIGHTBAR_OPTIONS);
            });

            this.protect.clicked.connect (() => {
                sig_selected (RIGHTBAR_PROTECT);
            });
        }

        public void stack_view (StackView v) {
            if (v == STACK_HOME) {
                this.fav.sensitive = false;
                this.read.sensitive = false;
            }
            if (v == STACK_DETAILS) {
                this.fav.sensitive = true;
                this.read.sensitive = true;
            }
            if (v == STACK_WARNING) {
                this.fav.sensitive = true;
                this.read.sensitive = true;
            }
        }
    }
}
