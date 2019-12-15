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
    public class BookInfo : Gtk.Box {
        private Gtk.Label title_en;
        private Gtk.Label title_jp;

        public BookInfo () {
            Object (
                orientation: Gtk.Orientation.VERTICAL,
                spacing: 10
            );

            this.title_en = new Gtk.Label (null);
            this.title_en.set_line_wrap (true);
            this.title_jp = new Gtk.Label (null);
            this.title_jp.set_line_wrap (true);
            this.pack_start (title_en);
            this.pack_start (title_jp);
        }

        public void set_title_en (string t) {
            this.title_en.set_label (t);
        }

        public void set_title_jp (string t) {
            this.title_jp.set_label (t);
        }

        public void load_title (Models.Title title) {
            this.set_title_en (title.english);
            this.set_title_jp (title.japanese);
        }
    }
}
