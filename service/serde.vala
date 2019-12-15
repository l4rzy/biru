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

namespace Biru.Service.Serde {
    public class Parser {
        public static Book parse_book (Json.Node jbook) throws Error {
            var b = Json.gobject_deserialize (typeof (Book), jbook) as Book;
            assert (b != null);
            // to deserialize fields that could not be deserialized
            b.update_from_json (jbook);

            return b;
        }

        public static async List<Book ? > parse_search_result (InputStream istream) throws Error {
            var list = new List<Book ? >();
            var parser = new Json.Parser ();
            try {
                yield parser.load_from_stream_async (istream, null);

                var node = parser.get_root ().get_object ();
                // per_page is always 25
                // num_pages is currently ignored
                var result = node.get_array_member ("result");

                foreach (var jbook in result.get_elements ()) {
                    var b = Parser.parse_book (jbook);
                    list.append (b);
                }
            } catch (Error e) {
                throw e;
            }

            return list;
        }
    }
}
