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

namespace Biru.UI.Widgets {
    public class Navigation : Gtk.Box {
        private Gtk.Button back;
        private Gtk.Button forw;
        private Gtk.Button home;

        public signal void sig_btn_navi (bool back);
        public signal void sig_btn_home ();

        public Navigation () {
            Object ();
            this.back = new Gtk.Button.from_icon_name ("go-previous-symbolic");
            this.forw = new Gtk.Button.from_icon_name ("go-next-symbolic");
            this.home = new Gtk.Button.from_icon_name ("go-home-symbolic");

            // disable back & forw by default
            this.back.sensitive = false;
            this.forw.sensitive = false;

            this.pack_start (back);
            this.pack_start (forw);
            this.pack_end (home);

            // connect signals
            this.back.clicked.connect (() => {
                sig_btn_navi (true);
            });

            this.forw.clicked.connect (() => {
                sig_btn_navi (false);
            });

            this.home.clicked.connect (() => {
                sig_btn_home ();
            });
        }

        public void enable_back (bool val) {
            this.back.sensitive = val;
        }

        public void enable_forw (bool val) {
            this.forw.sensitive = val;
        }
    }
}
