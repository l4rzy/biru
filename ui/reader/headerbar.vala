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

using Biru.UI.Widgets;
using Biru.Service;
using Biru.UI.Configs;

namespace Biru.UI.Reader {
    public enum NaviButton {
        NAVI_FIRST,
        NAVI_PREV,
        NAVI_NEXT,
        NAVI_LAST
    }

    public class HeaderBar : Gtk.HeaderBar {
        private Gtk.Button next;
        private Gtk.Button prev;
        private Gtk.Button first;
        private Gtk.Button last;

        private Gtk.Button savepage;

        public signal void sig_navi (NaviButton btn);

        public HeaderBar (Models.Book book, int index) {
            this.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            this.set_title (@"$(S.READER_TITLE_PREFIX) [$((index+1).to_string())/$(book.num_pages.to_string())]");
            this.set_subtitle (book.title.pretty);
            this.show_close_button = true;

            this.next = new Gtk.Button.from_icon_name ("go-next-symbolic");
            this.next.can_focus = false;
            this.prev = new Gtk.Button.from_icon_name ("go-previous-symbolic");
            this.prev.can_focus = false;
            this.first = new Gtk.Button.from_icon_name ("go-first-symbolic");
            this.first.can_focus = false;
            this.last = new Gtk.Button.from_icon_name ("go-last-symbolic");
            this.last.can_focus = false;

            this.savepage = new Gtk.Button.from_icon_name ("document-save-symbolic");
            this.savepage.can_focus = false;

            this.pack_start (this.first);
            this.pack_start (this.prev);
            this.pack_start (this.next);
            this.pack_start (this.last);

            this.pack_end (this.savepage);

            this.next.clicked.connect (() => {
                sig_navi (NAVI_NEXT);
            });

            this.prev.clicked.connect (() => {
                sig_navi (NAVI_PREV);
            });

            this.first.clicked.connect (() => {
                sig_navi (NAVI_FIRST);
            });

            this.last.clicked.connect (() => {
                sig_navi (NAVI_LAST);
            });
        }

        public void update (int index, int max_index) {
            if (index == 0) {
                this.navi (false, false, true, true);
            } else if (index == 1) {
                this.navi (false, true, true, true);
            } else if (index == max_index - 1) {
                this.navi (true, true, true, false);
            } else if (index == max_index) {
                this.navi (true, true, false, false);
            } else {
                this.navi (true, true, true, true);
            }
            this.set_title (@"$(S.READER_TITLE_PREFIX) [$((index+1).to_string())/$((max_index+1).to_string())]");
        }

        private void navi (bool first, bool prev, bool next, bool last) {
            this.first.sensitive = first;
            this.prev.sensitive = prev;
            this.next.sensitive = next;
            this.last.sensitive = last;
        }
    }
}
