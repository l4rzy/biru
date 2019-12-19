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

namespace Biru.UI.Configs {
    public class Constants {
        public const string APP_ID = "io.l4rzy.biru";
        public const string APP_NAME = "Biru";
        public const string APP_LONGNAME = "An online manga reading utility";

        // window
        public const int WINDOW_X = 1024;
        public const int WINDOW_Y = 654;

        // stack view
        public const string STACK_HOME = "STACK_HOME";
        public const string STACK_WARNING = "STACK_WARNING";
        public const string STACK_DETAILS = "STACK_DETAILS";

        // book cover in details page
        public const int COVER_MAX_W = 600;
        public const int COVER_MAX_H = 1000;

        // tag max len
        public const int TAG_MAX_LEN = 12;

        // resources
        public const string RESOURCE_PREFIX = "/io/l4rzy/biru/";
        public const string RESOURCE_CSS = RESOURCE_PREFIX + "style.css";
        public const string RESOURCE_JPN_FLG = RESOURCE_PREFIX + "japan32.png";
        public const string RESOURCE_UK_FLG = RESOURCE_PREFIX + "uk32.png";
        public const string RESOURCE_CN_FLG = RESOURCE_PREFIX + "china32.png";
        public const string RESOURCE_NH_LOGO = RESOURCE_PREFIX + "logo.svg";
    }

    public class S {
        public const string HEADER_SEARCH_PLACEHOLDER = "Type to search";
        public const string BOOKCARD_MENU_READ = "Read";
        public const string BOOKCARD_MENU_DETAILS = "Details";
        public const string BOOKCARD_MENU_FAVOR = "Add to favors";
        public const string BOOKCARD_MENU_DOWNLOAD = "Download";

        public const string HEADER_MENU_SETTINGS = "Settings";
        public const string HEADER_MENU_ABOUT = "About";

        public const string DETAILS_CAT_PARODY = "Parody";
        public const string DETAILS_CAT_CHARACTER = "Character";
        public const string DETAILS_CAT_TAG = "Tag";
        public const string DETAILS_CAT_ARTIST = "Artist";
    }
}
