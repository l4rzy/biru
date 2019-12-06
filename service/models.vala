using Biru.Service;

namespace Biru.Service.Models {

    public class Page : Object {
        public string t {get; set;}
        public int64 h {get; set;}
        public int64 w {get; set;}
    }
    
    public class Tag : Object {
        public int64 id {get; set;}
        public string _type {get;set;} // type is a keyword, so it will not be deserialized properly
        public string name {get;set;}
        public string url {get;set;}
        public int64 count {get;set;}

        // TODO: a better way to handle keyword collision
        public static Tag from_json(Json.Node jtag) {
            var ret = Json.gobject_deserialize(typeof(Tag), jtag) as Tag;
            ret._type = jtag.get_object().get_string_member("type");

            return ret;
        }
    }

    public class Title : Object {
        public string english {get; set;}
        public string japanese {get; set;}
        public string pretty {get; set;}
    }

    public class Images : Object {
        public List<Page> pages;
        public Page cover {get; set;}
        public Page thumbnail {get; set;}

        public static Images from_json(Json.Node jimages) {
            var ret = Json.gobject_deserialize(typeof(Images), jimages) as Images;
            var arr = jimages.get_object().get_array_member("pages");
            foreach (var p in arr.get_elements()) {
                var _page = Json.gobject_deserialize(typeof(Page), p) as Page;
                ret.pages.append(_page);
            }

            return ret;
        }

        public void update_from_json(Json.Node jimages) {
            var arr = jimages.get_object().get_array_member("pages");
            foreach (var p in arr.get_elements()) {
                var _page = Json.gobject_deserialize(typeof(Page), p) as Page;
                this.pages.append(_page);
            }            
        }
    }
    
    public class Book : Object {
        public int64 id {get; set; default=-1;} // TODO: solve this with dynamic typing or generic typing
        public string media_id {get;set;} 
        public Title title {get; set;}
        public Images images {get; set;}
        public string scanlator {get;set;}
        public int64 upload_date {get;set;}
        public List<Tag> tags;
        public int64 num_pages {get;set;}
        public int64 num_favourites {get;set;}

        public string getThumbnailUrl() {
            return URLBuilder.getGalleryUrl((int)this.id);
        }

        // update fields that could not be deserialized
        public void update_from_json(Json.Node jbook) {
            // the id
            if (id == -1) {
                this.id = jbook.get_object().get_string_member("id").to_int64();
            }
            
            // images
            var jimages = jbook.get_object().get_object_member("images");
            //this.images.update_from_json();


            // tags
        }
    }
}
