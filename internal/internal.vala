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

// TODO: implement priority queue for async tasks
// TODO: implement its own InputStream to drop GVFS dependency

using GLib;

namespace Biru.Internal {
    public class NetStream : InputStream {
        public NetStream () {
            Object ();
        }

        public override bool close (Cancellable ? cancellable = null) throws IOError {
            return true;
        }

        public override ssize_t read (uint8[] buffer, Cancellable ? cancellable = null) throws IOError {
            return 0;
        }

        public override async ssize_t read_async (uint8[] ? buffer, int io_priority = Priority.DEFAULT, Cancellable ? cancellable = null) throws IOError {
            return 0;
        }
    }

    public class AsyncQueue {
    }
}
