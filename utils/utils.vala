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

using Biru.Utils.Configs;

namespace Biru.Utils {
    public class Internet {
        public static bool check () {
            var host = Constants.HOST;
            try {
                // Resolve hostname to IP address
                var resolver = Resolver.get_default ();
                var addresses = resolver.lookup_by_name (host, null);
                var address = addresses.nth_data (0);
                if (address == null) {
                    return false;
                }
            } catch (Error e) {
                return false;
            }
            return true;
        }
    }
}
