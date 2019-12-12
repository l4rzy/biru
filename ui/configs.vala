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

        // bookcards from home
        public const int BOOKCARD_MAX_W = 300;
        public const int BOOKCARD_MAX_H = 200;

        // resources
        public const string RESOURCE_PREFIX = "/io/l4rzy/biru/";
        public const string RESOURCE_CSS = RESOURCE_PREFIX + "style.css";
        public const string RESOURCE_JPN_FLG = RESOURCE_PREFIX + "japan32.png";
        public const string RESOURCE_UK_FLG = RESOURCE_PREFIX + "uk32.png";
        public const string RESOURCE_CN_FLG = RESOURCE_PREFIX + "china32.png";
        public const string RESOURCE_NH_LOGO = RESOURCE_PREFIX + "logo.svg";
    }

    public enum StackView {
        STACK_HOME,
        STACK_DETAILS,
        STACK_HISTORY,
        STACK_WARNING
    }

    public class S {
        public const string HEADER_SEARCH_PLACEHOLDER = "Type to search";
    }
}
