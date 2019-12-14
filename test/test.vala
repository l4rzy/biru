using Biru.Core.Plugin;
using Biru.Core.Plugin.Models;

void main (string[] args) {
    MainLoop loop = new MainLoop ();
    string pname = "plugin";
    if (args.length == 2) {
        pname = args[1];
    }
    stdout.printf ("=> loading '%s'\n", pname);
    var registrar = new PluginRegistrar<MangaProvider>(pname);
    var ret = registrar.load ();

    if (!ret) {
        message ("Error loading module");
        return;
    }

    var nhentai = registrar.new_object ();
    var api = nhentai.init ();

    api.sig_homepage_result.connect ((books) => {
        foreach (var b in books) {
            message (b.get_web_url ());
        }
    });

    api.get_info ().print ();
    api.homepage.begin (1, "popular", () => {
        message ("loading done");
        loop.quit ();
    });
    loop.run ();
}
