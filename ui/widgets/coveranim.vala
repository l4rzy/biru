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

using Biru.UI;
using Biru.Service;
using Biru.UI.Configs;

namespace Biru.UI.Widgets {
    public class CoverAnim : Gtk.Overlay {
        private Cancellable ? cancl;
        private Image cimage;
// private Gtk.Button save;

        private int w { get; set; default = Constants.COVER_MAX_W; }
        private int h { get; set; default = Constants.COVER_MAX_H; }

        public signal void sig_cover_loaded ();

        public CoverAnim (Cancellable ? cancl) {
            Object (
                can_focus: false,
                halign: Gtk.Align.CENTER
            );
            this.cancl = cancl;
            this.get_style_context ().add_class ("cover");
// this.save = new Gtk.Button.from_icon_name("insert-image-symbolic");
// this.save.get_style_context ().add_class ("circular");
// this.save.get_style_context ().add_class ("coverbtn");
// this.save.can_focus = false;
// this.save.halign = Gtk.Align.END;
// this.save.valign = Gtk.Align.START;
// this.save.margin_top = 16;
// this.save.margin_end = 12;
            this.cimage = new Image ();
            this.add (this.cimage);
// this.add_overlay(this.save);
            this.show_all ();
        }

        public void load_book (Models.Book book) {
            int width, height;
            Image.scale ((int) book.images.cover.w, (int) book.images.cover.h, Constants.COVER_MAX_W, out width, out height);
            this.w = width;
            this.h = height;
            this.width_request = this.w;
            this.height_request = this.h;

            this.cimage.set_from_url_async.begin (book.get_cover_url (), this.w, this.h, true, this.cancl, () => {
                message ("done loading cover of %s", book.get_cover_url ());
                this.sig_cover_loaded ();
            });
        }

        public void reset () {
            this.cimage.clear ();
        }
    }
}
