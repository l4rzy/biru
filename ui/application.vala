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

/*
 * UI entry point
 */
namespace Biru.UI {
    class App : Gtk.Application {
        private AppController ctl;

        public App () {
            Object (application_id: Constants.APP_ID,
                    flags : ApplicationFlags.FLAGS_NONE);

            // setup
            var quit_action = new SimpleAction ("quit", null);

            this.add_action (quit_action);
            this.set_accels_for_action ("app.quit", { "<Control>q" });

            quit_action.activate.connect (() => {
                message("control q pressed");
                if (this.ctl != null) {
                    this.ctl.quit ();
                }
            });
        }

        protected override void activate () {
            if (this.ctl == null) {
                this.ctl = new AppController (this);
            }
            this.ctl.activate ();
        }
    }
}
