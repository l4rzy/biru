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
/*
   namespace Biru.Providers.TruyenTranh {
    public class URLBuilder {
        public static string homepage_url (int page_num) {
            return @"http://truyentranh.net/danh-sach.tall.html?p=$(page_num.to_string())";
        }
    }

    public class Book {
        private string name { get; set; }
    }

    public class TruyenTranh {
        private Soup.Session session;

        public TruyenTranh () {
            this.session = new Soup.Session ();
            this.session.ssl_strict = false;
            this.session.max_conns = 32;
            // this.session.use_thread_context = false;
        }

        public async List<Book> ? homepage (int page_num) throws Error {
            var uri = URLBuilder.homepage_url (page_num);
            var ret = new List<Book>();
            var mess = new Soup.Message ("GET", uri);
            try {
                var istream = yield this.session.send_async (mess);

                var buf = new uint8[1];
                var bytes_read = 0;
                istream.read_all (buf, &bytes_read);
                message ((string) buf);
            } catch (Error e) {
                throw e;
            }
        }
    }
   }

   void main () {
    var tt = new TruyenTranh ();
    var ret = tt.homepage (1);
   }
 */
