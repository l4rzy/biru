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

using Biru.Core.Plugin;
using Biru.Core.Plugin.Models;

class Constants {
    public const int VER_MAJOR = 0;
    public const int VER_MINOR = 0;
    public const int VER_PATCH = 1;
    public const string NH_HOME = "https://nhentai.net";
    public const string NH_IMG = "https://i.nhentai.net";
    public const string NH_THUMB = "https://t.nhentai.net";
}

public class URLBuilder {
    // books and galleries are not exchangable terms
    public static string get_search_url (string query, int page_num, string sort) {
        // preprocessing query by replacing all whitespaces with '+'
        string formal_query = query.replace (" ", "+");

        return @"$(Constants.NH_HOME)/api/galleries/search?query=$(formal_query)&page=$(page_num.to_string())&sort=$(sort)";
    }

    public static string get_homepage_url (int page_num, string sort) {
        return @"$(Constants.NH_HOME)/api/galleries/all?page=$(page_num.to_string())&sort=$(sort)";
    }

    // functions that are called from within objects
    public static string get_book_url (int64 book_id) {
        return @"$(Constants.NH_HOME)/api/gallery/$(book_id.to_string())";
    }

    public static string __get_t_url (string media_id) {
        return @"$(Constants.NH_THUMB)/galleries/$(media_id)";
    }

    public static string __get_i_url (string media_id) {
        return @"$(Constants.NH_IMG)/galleries/$(media_id)";
    }

    public static string get_book_cover_url (string media_id, string ext) {
        return @"$(__get_t_url(media_id))/cover.$(ext)";
    }

    public static string get_book_thumbnail_url (string media_id, string ext) {
        return @"$(__get_t_url(media_id))/thumb.$(ext)";
    }

    public static string get_book_web_url (int64 book_id) {
        return @"$(Constants.NH_HOME)/g/$(book_id.to_string())";
    }

    public static string get_related_books_url (int64 book_id) {
        return @"$(Constants.NH_HOME)/api/gallery/$(book_id.to_string())/related";
    }
}

public class Parser {
    public static Book parse_book (Json.Node jbook) throws Error {
        var b = Json.gobject_deserialize (typeof (Book), jbook) as Book;
        assert (b != null);
        // to deserialize fields that could not be deserialized
        b.update_from_json (jbook);

        return b;
    }

    public static async List<Book ? > parse_search_result (InputStream istream) throws Error {
        var list = new List<Book ? >();
        var parser = new Json.Parser ();
        try {
            yield parser.load_from_stream_async (istream, null);

            var node = parser.get_root ().get_object ();
            // per_page is always 25
            // num_pages is currently ignored
            var result = node.get_array_member ("result");

            foreach (var jbook in result.get_elements ()) {
                var b = parse_book (jbook);
                list.append (b);
            }
        } catch (Error e) {
            throw e;
        }

        return list;
    }
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

public class Tag : Object, Models.ITag {
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

    public string get_kind () {
        return this._type;
    }

    public string get_name () {
        return this.name;
    }

    public string get_link () {
        return this.url;
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

public class Book : Object, Models.IBook, Models.IBookDetails {
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

    public int64 get_id () {
        return this.id;
    }

    public string get_name () {
        return this.title.pretty;
    }

    public string get_desc () {
        return "-- hentai doesn't need any description ;) --";
    }

    public string get_web_url () {
        return @"$(Constants.NH_HOME)/g/$(this.id.to_string())";
    }

    // for details page
    public string get_cover_url () {
        return @"$(Constants.NH_THUMB)/galleries/$(media_id)/cover.$(images.cover.kind())";
    }

    // for search & home pages
    public string get_thumb_url () {
        return @"$(Constants.NH_THUMB)/galleries/$(media_id)/thumb.$(images.thumbnail.kind())";
    }

    public string get_language () {
        foreach (var t in this.tags) {
            if (t._type == "language")
                return t.name;
        }
        return "";
    }

    // BookDetails interface
    public List<string ? > get_page_urls () {
        return new List<string>();
    }

    public List<string ? > get_page_thumb_urls () {
        return new List<string>();
    }

    public List<ITag ? > get_tags () {
        return new List<Tag ? >();
    }

    public List<IBook ? > get_related () {
        return new List<IBook>();
    }
}

public class NHentai : Object, Models.MangaProvider {
    public static NHentai instance;
    private ProviderInfo info { get; set; }
    private Soup.Session session;

    // public override signal void sig_homepage_result(List<Book?> ret);

    public unowned Models.MangaProvider init () {
        if (instance == null) {
            instance = new NHentai ();
            instance.info = new ProviderInfo ();
            instance.info.name = "NHentai";
            instance.info.desc = "NHentai plugin for Biru";
            instance.info.version = @"$(Constants.VER_MAJOR.to_string()).$(Constants.VER_MINOR.to_string()).$(Constants.VER_PATCH.to_string())";
            instance.info.features = 0;
            instance.info.maintainer = "l4rzy <Lam Nguyen>";
            instance.info.maintainer_address = "l4.foss@gmail.com";
            instance.info.sort_types = { "popular", "date" };

            instance.session = new Soup.Session ();
            instance.session.ssl_strict = false;
            instance.session.max_conns = 32;
        }
        return instance;
    }

    public unowned ProviderInfo get_info () {
        return this.info;
    }

    public async void homepage (int page_num, string sort_type) throws Error {
        var mess = new Soup.Message ("GET", URLBuilder.get_homepage_url (page_num, sort_type));
        try {
            InputStream istream = yield this.session.send_async (mess, null);

            var ret = yield Parser.parse_search_result (istream);

            sig_homepage_result (ret);
        } catch (Error e) {
            sig_error (e);
            throw e;
        }
    }

    public async void search (string query, int page_num, string sort_type) throws Error {
        var mess = new Soup.Message ("GET", URLBuilder.get_search_url (query, page_num, sort_type));
        try {
            InputStream istream = yield this.session.send_async (mess, null);

            var ret = yield Parser.parse_search_result (istream);

            sig_search_result (ret);
        } catch (Error e) {
            sig_error (e);
            throw e;
        }
    }

    public async void get_details (IBook book) throws Error {
        sig_details_result ((IBookDetails) book);
    }

    public async void get_related (IBook book) throws Error {
        yield;
    }
}

public Type register_plugin (Module module) {
    return typeof (NHentai);
}
