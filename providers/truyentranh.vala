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

public class Constants {
    public const int VER_MAJOR = 0;
    public const int VER_MINOR = 0;
    public const int VER_PATCH = 1;
}

public class URLBuilder {
    public static string homepage_url (int page_num) {
        return @"http://truyentranh.net/danh-sach.tall.html?p=$(page_num.to_string())";
    }
}

public class TruyenTranh : Object, Models.MangaProvider {
    private ProviderInfo info { get; set; }
    private static TruyenTranh ? instance;

    public unowned Models.MangaProvider init () {
        if (instance == null) {
            instance = new TruyenTranh ();
            instance.info = new ProviderInfo ();
            instance.info.name = "TruyenTranh";
            instance.info.desc = "https://truyentranh.net plugin for Biru";
            instance.info.version = @"$(Constants.VER_MAJOR.to_string()).$(Constants.VER_MINOR.to_string()).$(Constants.VER_PATCH.to_string())";
            instance.info.features = 0;
            instance.info.maintainer = "l4rzy <Lam Nguyen>";
            instance.info.maintainer_address = "l4.foss@gmail.com";
            instance.info.sort_types = { "popular", "date" };
        }
        return instance;
    }

    public ProviderInfo get_info () {
        return new ProviderInfo();
    }

    public async void homepage (Soup.Session session, int page_num, string sort_type) throws Error {
        //var uri = URLBuilder.homepage_url (page_num);
    }

    public async void search (Soup.Session session, string query, int page_num, string sort_type) throws Error {
    }

    public async void get_details (Soup.Session session, IBook book) throws Error {
    }

    public async void get_related (Soup.Session session, IBook book) throws Error {
    }
}

public Type register_plugin (Module module) {
    return typeof (TruyenTranh);
}
