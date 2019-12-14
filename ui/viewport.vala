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

namespace Biru.UI {
    public class ViewPort {
        private unowned Gtk.Stack stack;
        private unowned Widgets.HeaderBar header;
        private string current { get; set; default = Constants.STACK_HOME; }
        private string last { get; set; default = Constants.STACK_HOME; }
        private Gtk.StackTransitionType anim_left { get; set; default = Gtk.StackTransitionType.CROSSFADE; }
        private Gtk.StackTransitionType anim_right { get; set; default = Gtk.StackTransitionType.CROSSFADE; }

        public signal void sig_switch_view (string v);

        public ViewPort (Gtk.Stack stack, Widgets.HeaderBar header) {
            this.stack = stack;
            this.stack.transition_duration = 120;
            this.stack.hhomogeneous = false;
            this.stack.interpolate_size = true;
            this.header = header;
        }

        public void init () {
            this.header.navigation (false, false);
            this.set_to (Constants.STACK_HOME);
            // this.stack.set_visible_child_full (this.current, Gtk.StackTransitionType.CROSSFADE);
        }

        public string get_view () {
            return this.current;
        }

        void set_to (string v, Gtk.StackTransitionType anim = Gtk.StackTransitionType.CROSSFADE) {
            this.current = v;
            this.stack.set_visible_child_full (v, anim);
        }

        public void warning () {
            this.last = this.current;
            this.set_to (Constants.STACK_WARNING);
            this.header.navigation (true, false);
            this.header.rightbar_buttons (false, false);
            this.sig_switch_view (this.current);
        }

        // new view to the right, and switch to that view
        public void details () {
            this.set_to (Constants.STACK_DETAILS, this.anim_right);
            this.header.navigation (true, false);
            this.header.rightbar_buttons (true, true);
            this.sig_switch_view (this.current);
        }

        public void home (bool warning = false) {
            if (warning == true) {
                this.set_to (this.last);
            } else {
                this.set_to (Constants.STACK_HOME, this.anim_left);
                this.header.navigation (false, true);
            }
            this.header.rightbar_buttons (false, false);
            this.sig_switch_view (this.current);
        }

        public void reset () {
            this.init ();
            this.sig_switch_view (this.current);
        }
    }
}
