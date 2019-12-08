using Biru.Utils.Configs;

namespace Biru.Utils {
    public class Internet {
        public static bool check () {
            var host = Constants.HOST;
            try {
                // Resolve hostname to IP address
                var resolver = Resolver.get_default ();
                var addresses = resolver.lookup_by_name (host, null);
                var address = addresses.nth_data (0);
                if (address == null) {
                    return false;
                }
            } catch (Error e) {
                return false;
            }
            return true;
        }

        /*
           public static async bool checkInternetAsync() throws ThreadError {
            SourceFunc callback = checkInternetAsync.callback;
            bool ret;

            ThreadFunc<bool> run = () => {
                ret = checkInternet();
                Idle.add((owned) callback);
                return true;
            };

            new Thread<bool>("check internet", run);

            yield;
            return ret;
           }
         */
    }
}
