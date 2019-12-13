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

namespace Biru.Core.Plugin.Models {
    public interface IBook : Object {
        public abstract int64 get_id ();
        public abstract string get_name ();
        public abstract string get_language ();
        public abstract string get_cover_url ();
        public abstract string get_thumb_url ();
        public abstract string get_web_url ();
    }

    public interface IBookDetails : Object {
        public abstract List<string ? > get_page_urls ();
        public abstract List<string ? > get_page_thumb_urls ();

        // this is for chapters in some providers
        public abstract List<IBook ? > get_related ();
    }

    public interface MangaProvider : Object {
        public abstract unowned MangaProvider init ();
        public abstract unowned ProviderInfo get_info ();
        public abstract async List<IBook ? > homepage (int page_num, string sort_type);
        public abstract async List<IBook ? > search (string query, int page_num, string sort_type);

        public abstract async IBookDetails ? get_details (IBook book);
    }
}
