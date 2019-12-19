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

namespace Biru.Utils {
    public class String {
        public static string wrap (string s, int max_char) {
            // naive implementation
            var l = s.length;
            var offset = 0;
            string ret = "";
            while (true) {
                var next_slice = offset + max_char;
                if (next_slice > l - 1) {
                    ret += s.slice (offset, l - 1);
                    break;
                }
                ret += s.slice (offset, next_slice);
                ret += "\n";
                offset += max_char;
            }
            return ret;
        }
    }
}
