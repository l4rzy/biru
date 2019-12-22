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
using Biru.Core;

namespace Biru.UI.Windows {
    public class AboutWindow : Gtk.AboutDialog {
        public AboutWindow () {
            Object (
                modal: true,
                destroy_with_parent: true
            );
            // this.set_transient_for (window);
            var header = new Gtk.HeaderBar ();
            header.show_close_button = true;
            header.set_title ("About");

            this.set_titlebar (header);
            this.authors = { "l4rzy" };
            this.documenters = null;
            this.translator_credits = null;

            this.program_name = "Biru";
            this.comments = "An online manga reading utility";
            this.version = @"$(VER_MAJOR).$(VER_MINOR).$(VER_PATCH)";

            this.license = "GPLv3";
            this.wrap_license = true;

            this.website = "https://github.com/l4rzy/biru";
            this.website_label = "https://github/l4rzy/biru";

            this.response.connect ((response_id) => {
                if (response_id == Gtk.ResponseType.CANCEL || response_id == Gtk.ResponseType.DELETE_EVENT) {
                    this.hide_on_delete ();
                }
            });

            this.show_all ();
        }
    }
}
