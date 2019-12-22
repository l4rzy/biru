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
using Biru.Service;

namespace Biru.UI.Widgets {
    public class HeaderBar : Gtk.HeaderBar {
        public string view { get; set; default = Constants.STACK_HOME; }

        private Gtk.Entry search_entry { get; set; }
        private Loading loading;
        private Navigation navi;
        private RightBar rightbar;

        public signal void sig_search_activated (string query);
        public signal void sig_btn_home ();
        public signal void sig_navi (bool back);
        public signal void sig_rightbar (int btn);

        public HeaderBar () {
            // get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            this.set_title (Constants.APP_NAME);
            this.set_subtitle (Constants.APP_LONGNAME);
            this.show_close_button = true;

            this.navi = new Navigation ();
            this.rightbar = new RightBar ();
            this.rightbar.stack_view (this.view);
            this.loading = new Loading ();
            this.search_entry = new Gtk.Entry ();
            this.search_entry.margin = 2;
            this.search_entry.expand = true;
            this.search_entry.placeholder_text = S.HEADER_SEARCH_PLACEHOLDER;
            this.search_entry.primary_icon_name = "folder-saved-search-symbolic";
            this.search_entry.get_style_context ().add_class ("sentry");

            // shamelessly copied from github.com/calo001/fondo
            search_entry.button_press_event.connect ((event) => {
                search_entry.grab_focus_without_selecting ();
                if (search_entry.text_length > 0) {
                    return false;
                } else {
                    return true;
                }
            });

            this.pack_start (this.navi);
            this.pack_start (this.loading);
            this.pack_start (this.search_entry);

            // button to lock app
            this.pack_end (this.rightbar);

            // signals
            this.search_entry.activate.connect (() => {
                unowned string query = search_entry.get_text ();
                if (query.length > 0) {
                    sig_search_activated (query);
                    this.loading.start ();
                }
            });

            this.navi.sig_btn_home.connect (() => {
                sig_btn_home ();
            });

            this.navi.sig_btn_navi.connect ((back) => {
                sig_navi (back);
            });

            this.rightbar.sig_selected.connect ((btn) => {
                sig_rightbar (btn);
            });
        }

        public void navigation (bool left, bool right) {
            this.navi.enable_back (left);
            this.navi.enable_forw (right);
        }

        public void rightbar_buttons (string v) {
            this.rightbar.stack_view (v);
        }

        public void block (bool block) {
            this.search_entry.sensitive = !block;
        }

        public void stop_loading () {
            this.loading.stop ();
        }

        public void start_loading () {
            this.loading.start ();
        }
    }
}
