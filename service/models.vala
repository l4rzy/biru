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

using Biru.Service.Configs;

namespace Biru.Service.Models {
    public enum Language {
        ENGLISH,
        JAPANESE,
        CHINESE
    }

    public class Page : Object {
        public string t { get; set; }
        public int64 h { get; set; }
        public int64 w { get; set; }

        public string kind () {
            switch (this.t) {
                case "j": return "jpg";
                case "p": return "png";
                case "g": return "gif";
                default: return "";
            }
        }
    }

    public class PageInfo {
        public int w { get; set; }
        public int h { get; set; }
        public string url { get; set; }
        public string thumb_url { get; set; }
    }

    public class Tag : Object {
        public int64 id { get; set; }
        public string _type { get; set; } // type is a keyword, so it will not be deserialized properly
        public string name { get; set; }
        public string url { get; set; }
        public int64 count { get; set; }

        // TODO: a better way to handle keyword collision
        public static Tag from_json (Json.Node jtag) {
            var ret = Json.gobject_deserialize (typeof (Tag), jtag) as Tag;
            ret._type = jtag.get_object ().get_string_member ("type");

            return ret;
        }
    }

    public class Title : Object {
        public string english { get; set; }
        public string japanese { get; set; }
        public string pretty { get; set; }
    }

    public class Images : Object {
        public List<Page> pages;
        public Page cover { get; set; }
        public Page thumbnail { get; set; }

        public static Images from_json (Json.Node jimages) {
            var ret = Json.gobject_deserialize (typeof (Images), jimages) as Images;
            var arr = jimages.get_object ().get_array_member ("pages");
            foreach (var p in arr.get_elements ()) {
                var _page = Json.gobject_deserialize (typeof (Page), p) as Page;
                ret.pages.append (_page);
            }

            return ret;
        }

        public void update_from_json (Json.Node jimages) {
            var arr = jimages.get_object ().get_array_member ("pages");
            foreach (var p in arr.get_elements ()) {
                var _page = Json.gobject_deserialize (typeof (Page), p) as Page;
                this.pages.append (_page);
            }
        }

        public List<string ? > get_thumbnails () {
            return new List<string ? >();
        }
    }

    public class Book : Object {
        public int64 id { get; set; default = -1; }
        public string media_id { get; set; }
        public Title title { get; set; }
        public Images images { get; set; }
        public string scanlator { get; set; }
        public int64 upload_date { get; set; }
        public List<Tag> tags;
        public int64 num_pages { get; set; }
        public int64 num_favourites { get; set; }

        // update fields that could not be deserialized
        public void update_from_json (Json.Node jbook) {
            if (id == -1) {
                this.id = int64.parse (jbook.get_object ().get_string_member ("id"));
            }

            // pages
            var jpages = jbook.get_object ().get_object_member ("images").get_array_member ("pages");
            foreach (var p in jpages.get_elements ()) {
                var _page = Json.gobject_deserialize (typeof (Page), p) as Page;
                this.images.pages.append (_page);
            }

            // tags
            var jtags = jbook.get_object ().get_array_member ("tags");
            foreach (var t in jtags.get_elements ()) {
                var _tag = Tag.from_json (t);
                this.tags.append (_tag);
            }
        }

        public string web_url () {
            return URLBuilder.get_book_web_url (this.id);
        }

        // for details page
        public string cover_url () {
            return @"$(Constants.NH_THUMB)/galleries/$(media_id)/cover.$(images.cover.kind())";
        }

        // for search & home pages
        public string thumb_url () {
            return @"$(Constants.NH_THUMB)/galleries/$(media_id)/thumb.$(images.thumbnail.kind())";
        }

        public DateTime date () {
            return new DateTime.from_unix_utc (this.upload_date);
        }

        public Language language () {
            foreach (var t in this.tags) {
                if (t._type == "language") {
                    switch (t.name) {
                        case "english":
                            return ENGLISH;
                        case "chinese":
                            return CHINESE;
                    }
                }
            }
            return JAPANESE;
        }

        // program always deals with indice, not real page numbers
        public PageInfo get_pageno_info (int index) {
            var page = this.images.pages.nth_data (index);
            var pinfo = new PageInfo ();
            pinfo.w = (int) page.w;
            pinfo.h = (int) page.h;

            pinfo.url = @"$(Constants.NH_IMG)/galleries/$(this.media_id)/$((index+1).to_string()).$(page.kind())";
            pinfo.thumb_url = @"$(Constants.NH_THUMB)/galleries/$(this.media_id)/$((index+1).to_string())t.$(page.kind())";
            return pinfo;
        }

        public List<string ? > get_thumb_urls () {
            var urls = new List<string ? > ();

            var pnum = 1;
            this.images.pages.foreach ((page) => {
                urls.append (@"$(Constants.NH_THUMB)/galleries/$(this.media_id)/$(pnum.to_string())t.$(page.kind())");
                pnum += 1;
            });

            return new List<string ? > ();
        }

        public List<string ? > get_page_urls () {
            var urls = new List<string ? >();

            var pnum = 1;
            this.images.pages.foreach ((page) => {
                urls.append (@"$(Constants.NH_IMG)/galleries/$(this.media_id)/$(pnum.to_string()).$(page.kind())");
                pnum += 1;
            });

            return (owned) urls;
        }
    }
}
