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

        private Gtk.Button browser; // for details only
        private Gtk.Button share; // for details only

        public signal void sig_selected (RightBarBtn btn);

        public RightBar () {
            this.options = new Gtk.Button.from_icon_name ("view-more-horizontal-symbolic");
            this.protect = new Gtk.Button.from_icon_name ("system-lock-screen-symbolic");
            this.browser = new Gtk.Button.from_icon_name ("network-workgroup-symbolic");
            this.share = new Gtk.Button.from_icon_name ("emblem-shared-symbolic");

            this.pack_start (this.browser);
            this.pack_start (this.share);
            this.pack_start (this.options);
            this.pack_end (this.protect);

            var menu = new HeaderMenu (this.options);
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
                this.browser.sensitive = false;
                this.share.sensitive = false;
            }
            if (v == STACK_DETAILS) {
                this.browser.sensitive = true;
                this.share.sensitive = true;
            }
        }
    }
}
