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

            add_action (quit_action);
            set_accels_for_action ("app.quit", { "<Control>q" });

            quit_action.activate.connect (() => {
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
