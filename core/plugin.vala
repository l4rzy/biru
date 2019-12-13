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

namespace Biru.Core.Plugin {
    public class ProviderInfo {
        public string name;
        public string desc;
        public string version;
        public string maintainer;
        public string maintainer_address;
        public int features;
        public string[] sort_types;

        public void print () {
            stdout.printf ("name: %s\ndesc: %s\n", this.name, this.desc);
        }
    }

    public class PluginRegistrar<T>: Object {
        public string path { get; private set; }
        private Type type;
        private Module module;

        private delegate Type RegisterPluginFunction (Module module);

        public PluginRegistrar (string name) {
            assert (Module.supported ());
            this.path = Module.build_path (Environment.get_variable ("PWD"), name);
        }

        public bool load () {
            stdout.printf ("Loading plugin with path: '%s'\n", path);

            module = Module.open (path, ModuleFlags.LAZY);
            if (module == null) {
                return false;
            }

            stdout.printf ("Loaded module: '%s'\n", module.name ());

            void * function;
            module.symbol ("register_plugin", out function);
            unowned RegisterPluginFunction register_plugin = (RegisterPluginFunction) function;

            type = register_plugin (module);
            stdout.printf ("Plugin type: %s\n\n", type.name ());
            return true;
        }

        public T new_object () {
            return Object.new (type);
        }
    }
}
