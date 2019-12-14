using Biru.Core.Plugin;
using Biru.Core.Plugin.Models;

public class Mock {
    private unowned MangaProvider api;
    
    public Mock(MangaProvider api) {
        var sss = new Soup.Session();
        this.api = api;
        this.api.homepage.begin(sss, 1, "popular");
    }
}

public class PlugTest {
    //private MangaProvider api;
    public PlugTest() {
        var sss = new Soup.Session();
        var registrar = new PluginRegistrar<MangaProvider>("nhentai");
        registrar.load ();
        var api = registrar.new_object ();
        message("ok");
        api.sig_homepage_result.connect((ret) => {
            message("request home ok");
        });

        message("about to make request");
        api.homepage.begin(sss, 1, "popular");
    }
}

void main(string[] args) {
    MainLoop loop = new MainLoop ();

    var p = new PlugTest();

//        var sss = new Soup.Session();
//        var registrar = new PluginRegistrar<MangaProvider>("nhentai");
//        registrar.load ();
//        var api = registrar.new_object ();
//        message("ok");
//        api.sig_homepage_result.connect((ret) => {
//            message("request home ok");
//        });

//        message("about to make request");
//        api.homepage.begin(sss, 1, "popular");        
    loop.run();
}
