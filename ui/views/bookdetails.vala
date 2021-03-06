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
using Biru.UI.Widgets;
using Biru.Service;
using Biru.UI.Menus;

namespace Biru.UI.Views {
    class BookDetails : Gtk.ScrolledWindow {
        private Cancellable cancl;
        private Gtk.Box con; // container

        private Models.Book ? book;
        private CoverAnim cover;
        private TagGrid tgrid;
        private BookInfo info;
        private BookPreview preview;

        public signal void sig_loaded ();
        public signal void sig_tag_clicked (Models.Tag tag, TagOption opt);
        public signal void sig_page_clicked (Models.Book book, int index, PageCardOpt opt);

        public BookDetails () {
            Object ();
            this.cancl = new Cancellable ();
            this.book = null;

            this.con = new Gtk.Box (Gtk.Orientation.VERTICAL, 18);
            this.con.spacing = 18;

            this.cover = new CoverAnim (this.cancl);
            this.cover.margin_top = 12;
            this.con.pack_start (cover);

            this.info = new BookInfo ();
            this.con.pack_start (info);

            this.tgrid = new TagGrid ();
            this.tgrid.margin_start = 40;
            this.tgrid.margin_end = 40;
            this.con.pack_start (tgrid);

            this.preview = new BookPreview (this.cancl);
            this.con.pack_start (preview);

            this.add (this.con);
            this.show_all ();

            this.tgrid.sig_tag_clicked.connect ((tag, opt) => {
                this.sig_tag_clicked (tag, opt);
            });

            this.cover.sig_cover_loaded.connect (() => {
                this.sig_loaded ();
            });

            this.preview.sig_page_clicked.connect ((book, index, opt) => {
                this.sig_page_clicked (book, index, opt);
            });
        }

        public string get_book_name () {
            return this.book.title.pretty;
        }

        public string ? get_book_jp_name () {
            return this.book.title.japanese;
        }

        public unowned Models.Book get_book () {
            return this.book;
        }

        public void load_book (Models.Book b) {
            this.book = b;
            // var page = b.get_pageno_info (0);

            this.cover.load_book (b);
            this.info.load_book (b);
            this.tgrid.insert_tags (b.tags);
            this.preview.load_book (b);
        }

        // stop loading image
        public void cancel_loading () {
            this.cancl.cancel ();
            this.cancl.reset ();
        }

        // reset all child widget in bookdetails
        public void reset () {
            this.cancel_loading ();
            this.cover.reset ();
            this.tgrid.reset ();
            this.preview.clean ();
        }
    }
}
