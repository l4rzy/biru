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

namespace Biru.UI {
    public class StackHist {
        // List to maintain navigation history
        private Queue<string> history;
        private int view { get; set; default = -1; }
        private unowned Gtk.Stack stack;
        private unowned Widgets.HeaderBar header;

        public StackHist (Gtk.Stack stack, Widgets.HeaderBar header) {
            this.stack = stack;
            this.header = header;
            this.history = new Queue<string>();
        }

        public string current () {
            return this.history.peek_nth (this.view);
        }

        // new view to the right, and switch to that view
        public void new_right (string v) {
            this.view++;
            this.history.push_nth (v, this.view);
            this.stack.set_visible_child_full (this.current (), Gtk.StackTransitionType.CROSSFADE);
            if (this.history.get_length () == 1) {
                this.header.navigation (false, false);
            } else {
                this.header.navigation (true, false);
            }
        }

        public void forward () {
            if (this.history.peek_nth (this.view + 1) != null) {
                this.view++;
            }
            this.stack.set_visible_child_full (this.current (), Gtk.StackTransitionType.CROSSFADE);
            if (this.history.peek_nth (this.view + 1) != null) {
                this.header.navigation (true, true);
            } else {
                this.header.navigation (true, false);
            }
        }

        public void backward () {
            if (this.history.peek_nth (this.view - 1) != null) {
                this.view--;
            }
            this.stack.set_visible_child_full (this.current (), Gtk.StackTransitionType.CROSSFADE);
            if (this.history.peek_nth (this.view - 1) != null) {
                this.header.navigation (true, true);
            } else {
                this.header.navigation (false, true);
            }
        }

        public void reset () {
        }
    }
}
