namespace Biru.Service.Models {
    
    public class Page : Object {
        public string t {get; set;}
        public int h {get; set;}
        public int w {get; set;}
    }
    
    public class Tag : Object {
        public int id {get; set;}
        public string kind {get;set;}
        public string name {get;set;}
        public string url {get;set;}
        public int count {get;set;}
    }

    public class Title : Object {
        public string english {get; set;}
        public string japanese {get; set;}
        public string pretty {get; set;}
    }

    public class Images : Object {
        public Page []pages;
        public Page cover;
        public Page thumbnail;
    }
    
    public class Book : Object {
        public int id {get; set;}
        public string media_id {get;set;}
        public Title title;
        public Images images;
        public string scanlator {get;set;}
        public int upload_date {get;set;}
        public Tag []tags;
        public int num_pages {get;set;}
        public int num_favourites {get;set;}
    }
}
