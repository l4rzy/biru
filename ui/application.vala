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

using Biru;
using Biru.UI.Configs;

/*
 * UI entry point
 */
namespace Biru.UI {
    class App : Gtk.Application {
        private Controllers.AppCtl ctl;

        public App () {
            Object (application_id: Constants.APP_ID,
                    flags : ApplicationFlags.FLAGS_NONE);

            // setup
            const OptionEntry[] options = {
                { "version", 'V', 0, OptionArg.NONE, null, "Show Biru's and libraries' versions", null },
                { null }
            };
            this.add_main_option_entries (options);
            var quit_action = new SimpleAction ("quit", null);

            this.add_action (quit_action);
            this.set_accels_for_action ("app.quit", { "<Control>q" });

            quit_action.activate.connect (() => {
                message ("control q pressed");
                if (this.ctl != null) {
                    this.ctl.quit ();
                }
            });
        }

        public override int handle_local_options (VariantDict options) {
            if (options.contains ("version")) {
                print ("%s version %d.%d.%d\n", Constants.APP_NAME, Core.Constants.VER_MAJOR,
                       Core.Constants.VER_MINOR, Core.Constants.VER_PATCH);
                print ("Kernel version: %s\n", Posix.utsname ().release);
                print ("GLib version: %u.%u.%u (%u.%u.%u)\n",
                       GLib.Version.major, GLib.Version.minor, GLib.Version.micro,
                       GLib.Version.MAJOR, GLib.Version.MINOR, GLib.Version.MICRO);
                print ("GTK version: %u.%u.%u (%i.%i.%i)\n",
                       Gtk.get_major_version (), Gtk.get_minor_version (), Gtk.get_micro_version (),
                       Gtk.MAJOR_VERSION, Gtk.MINOR_VERSION, Gtk.MICRO_VERSION);
                print ("Cairo version: %s\n", Cairo.version_string ());
                print ("Pango version: %s\n", Pango.version_string ());
                return 0;
            }
            return -1;
        }

        protected override void activate () {
            if (this.ctl == null) {
                this.ctl = new Controllers.AppCtl (this);
            }
            this.ctl.activate ();
        }
    }
}
