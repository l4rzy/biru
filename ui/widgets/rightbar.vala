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
        RIGHTBAR_DOWNLOAD,
        RIGHTBAR_OPTIONS,
        RIGHTBAR_PROTECT
    }

    public class RightBar : Gtk.Box {
        private Gtk.Button options;
        private Gtk.Button protect;
        private Gtk.Separator separator;
        private Gtk.Button fav;
        private Gtk.Button read;
        private Gtk.Button download;

        private HeaderMenu menu;

        public signal void sig_selected (RightBarBtn btn);

        public RightBar () {
            this.options = new Gtk.Button.from_icon_name ("view-more-horizontal-symbolic");
            this.protect = new Gtk.Button.from_icon_name ("system-lock-screen-symbolic");
            this.separator = new Gtk.Separator (Gtk.Orientation.VERTICAL);
            this.separator.set_vexpand (false);
            this.separator.set_hexpand (false);
            this.fav = new Gtk.Button.from_icon_name ("emblem-favorite-symbolic");
            this.read = new Gtk.Button.from_icon_name ("view-paged-symbolic");
            this.download = new Gtk.Button.from_icon_name ("folder-download-symbolic");

            this.pack_start (this.fav);
            this.pack_start (this.download);
            this.pack_start (this.read);
            this.pack_start (this.separator);
            this.pack_end (this.protect);
            this.pack_end (this.options);


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

// public void buttons (bool fav, bool read, bool download) {
// this.fav.sensitive = fav;
// this.read.sensitive = read;
// }

        public void stack_view (string v) {
            if (v == Constants.STACK_HOME) {
                this.fav.sensitive = false;
                this.read.sensitive = false;
                this.download.sensitive = false;
            }
            if (v == Constants.STACK_DETAILS) {
                this.fav.sensitive = true;
                this.read.sensitive = true;
                this.download.sensitive = true;
            }
            if (v == Constants.STACK_WARNING) {
                this.fav.sensitive = false;
                this.read.sensitive = false;
                this.download.sensitive = false;
            }
        }
    }
}
