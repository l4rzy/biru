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

using Biru.Service.Models;
using Biru.UI.Configs;

namespace Biru.UI.Widgets {
    public class TagGrid : Gtk.Box {
        private unowned List<Tag ? > tags;
        private TagCat cat_parody;
        private TagCat cat_character;
        private TagCat cat_tag;
        private TagCat cat_artist;

        public signal void sig_tag_clicked (Tag tag);

        public TagGrid () {
            Object (orientation: Gtk.Orientation.HORIZONTAL);
            this.cat_parody = new TagCat (S.DETAILS_CAT_PARODY);
            this.cat_character = new TagCat (S.DETAILS_CAT_CHARACTER);
            this.cat_tag = new TagCat (S.DETAILS_CAT_TAG);
            this.cat_artist = new TagCat (S.DETAILS_CAT_ARTIST);

            // signals
            this.cat_parody.sig_tag_clicked.connect ((tag) => {
                this.sig_tag_clicked (tag);
            });

            this.cat_parody.sig_tag_clicked.connect ((tag) => {
                this.sig_tag_clicked (tag);
            });

            this.cat_parody.sig_tag_clicked.connect ((tag) => {
                this.sig_tag_clicked (tag);
            });

            this.cat_parody.sig_tag_clicked.connect ((tag) => {
                this.sig_tag_clicked (tag);
            });
        }

        public void insert_tags (List<Tag ? > tags) {
            this.tags = tags;

            foreach (Tag t in this.tags) {
                var tag = new TagButton (t);

                switch (tag.name) {
                    case "parody":
                        this.cat_parody.add_tag (tag);
                        break;
                    case "character":
                        this.cat_character.add_tag (tag);
                        break;
                    case "tag":
                        this.cat_tag.add_tag (tag);
                        break;
                    case "artist":
                        this.cat_artist.add_tag (tag);
                        break;
                }
            }
        }
    }
}
