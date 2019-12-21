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
    public class HeaderBar : Gtk.HeaderBar {
        public HeaderBar (Models.Book book) {
            this.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            this.set_title (S.READER_TITLE_PREFIX);
            this.set_subtitle (book.title.pretty);
            this.show_close_button = true;
        }
    }
}
