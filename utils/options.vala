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

using GLib;
using Biru;
using Biru.Service;

namespace Biru.Utils {
    public class CommonOpts : Object {
        public int window_x { get; set; }
        public int window_y { get; set; }
        public int network_threads { get; set; }
        public bool save_dimension { get; set; }

        public CommonOpts () {
            this.window_x = UI.Configs.Constants.WINDOW_X;
            this.window_y = UI.Configs.Constants.WINDOW_Y;
            this.network_threads = 16;
            this.save_dimension = true;
        }
    }

    public class HomepageOpts : Object {
        // homepage
        public SortType home_sort { get; set; }
        public SortType search_sort { get; set; }
        public bool high_quality_cover { get; set; }

        public HomepageOpts () {
            this.home_sort = SORT_DATE;
            this.search_sort = SORT_POPULAR;
            this.high_quality_cover = false;
        }
    }

    public class DetailsOpts : Object {
        public bool high_quality_cover { get; set; }

        public DetailsOpts () {
            this.high_quality_cover = true;
        }
    }

    public class ReaderOpts : Object {
        public int next_cache { get; set; }
        public int prev_cache { get; set; }
        public bool save_dimension { get; set; }

        public ReaderOpts () {
            this.next_cache = 3;
            this.prev_cache = 2;
            this.save_dimension = false;
        }
    }

    public class Opts : Object {
        public CommonOpts common { get; set; }
        public HomepageOpts home { get; set; }
        public DetailsOpts details { get; set; }
        public ReaderOpts reader { get; set; }

        public static Opts ? instance;

        public Opts () {
            this.common = new CommonOpts ();
            this.home = new HomepageOpts ();
            this.details = new DetailsOpts ();
            this.reader = new ReaderOpts ();
        }

        public static Opts i () {
            if (instance == null) {
                instance = load ();
            }
            return instance;
        }

        private static Opts load_create_new (string dir, string conf) {
            // var fdir = File.new_for_path (dir);
            var fconf = File.new_for_path (conf);
            var opts = new Opts ();
            string json = Json.gobject_to_data (opts, null);
            message (json);
            try {
                // fdir.make_directory_with_parents();
                fconf.create (FileCreateFlags.NONE);

                FileIOStream iostream = fconf.open_readwrite ();
                iostream.seek (0, SeekType.END);

                OutputStream ostream = iostream.output_stream;
                DataOutputStream dostream = new DataOutputStream (ostream);
                dostream.put_string (json);
            } catch (Error e) {
                message (@"$(e.message)");
            }
            return opts;
        }

        private static Opts load_parse (File f) {
            message ("config file exists, parsing");
            var parser = new Json.Parser ();
            try {
                var istream = f.read ();
                parser.load_from_stream (istream, null);
                var root = parser.get_root ();
                var ret = Json.gobject_deserialize (typeof (Opts), root) as Opts;
                return ret;
            } catch (Error e) {
                message (@"config error, loading default");
                return new Opts ();
            }
        }

        public static Opts load () {
            var dir = @"$(GLib.Environment.get_user_config_dir())/$(Core.APP_ID)";
            var conf = @"$(dir)/conf.json";

            var fconf = File.new_for_path (conf);
            if (fconf.query_exists ()) {
                return Opts.load_parse (fconf);
            } else {
                // file doesn't exist, creating new
                return Opts.load_create_new (dir, conf);
            }
        }

        public void save (string fname) {
        }
    }
}
