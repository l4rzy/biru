
namespace Biru.UI.Widgets {
    public class Navigation : Gtk.Box {
        private Gtk.Button back;
        private Gtk.Button forw;
        private Gtk.Button home;

        public signal void sig_btn_back ();
        public signal void sig_btn_forw ();
        public signal void sig_btn_home ();

        public Navigation () {
            Object ();
            this.back = new Gtk.Button.from_icon_name ("go-previous-symbolic");
            this.forw = new Gtk.Button.from_icon_name ("go-next-symbolic");
            this.home = new Gtk.Button.from_icon_name ("go-home-symbolic");

            this.pack_start (back);
            this.pack_start (forw);
            this.pack_end (home);

            // connect signals
            this.back.clicked.connect (() => {
                sig_btn_back ();
            });

            this.forw.clicked.connect (() => {
                sig_btn_forw ();
            });

            this.home.clicked.connect (() => {
                sig_btn_home ();
            });
        }
    }
}
