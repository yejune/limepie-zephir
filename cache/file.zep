namespace Limepie\cache;

class file
{

    public static data  = "";
    public static ext   = ".php";

    public static function getPath()
    {
        return \limepie\config::get("cachedir");
    }

    private static function _cache_name(name)
    {

        return self::getPath().DIRECTORY_SEPARATOR."cache_".md5(name).self::ext;

    }

    public static function _get(id)
    {

        if isset self::data[id] {
            return self::data[id]; // Already set, return to sender
        }

        var path, tmp, cache, expires;
        let path = self::_cache_name(id);
        let expires = 0;
        let cache = FALSE;

        if file_exists(path) && is_readable(path) { // Check if the cache file exists
            let tmp     = unserialize(file_get_contents(path));
            let cache   = tmp["cache"];
            let expires = tmp["expires"];

            if expires > 0 && expires <= time() {
                self::clear(id);
                return FALSE;
            } else {
                return cache;//isset(cache)? cache : false);
            }
        } else {
            return FALSE;
        }

    }

    public static function clear(id)
    {

        if isset self::data[id] {
            unset self::data[id]; // Already set, return to sender
        }

        var path;
        let path = self::_cache_name(id);

        if file_exists(path) && is_readable(path) && unlink(path) {
            return TRUE;
        } else {
            return FALSE; //throw new CacheException('Cache could not be cleared.');
        }

    }

    public static function put(id, cache, lifetime = 0)
    {

        var path, fp, tmp, content;
        let self::data[id] = cache;

        if is_resource(cache) {
            throw new \limepie\cache\Exception("Can't cache resource.");
        }

        let path    = self::_cache_name(id);
        self::make_dir(dirname(path));

        let fp      = fopen(path, "w");
        if !fp {
            throw new \limepie\cache\Exception("Unable to open file for writing.".path);
        }
        flock(fp, LOCK_EX);

        let tmp = [
            "cache" : cache
        ];

        if lifetime > 0 {
            let tmp["expires"] = (time()+lifetime);
        } else {
            let tmp["expires"] = 0;
        }

        let content = serialize(tmp);
        fwrite(fp, content);
        flock(fp, LOCK_UN);
        fclose(fp);

        if file_exists(path) && is_readable(path) {
            chmod(path, 0777);
        } else {
            return FALSE;
        }

        return TRUE;

    }

    public static function make_dir(path, permission = 0777)
    {

        var dir, dirs, is_create_dir, i, value;
        let dir = "";

        if is_dir(path) {
            return path;
        }

        let dirs=explode(DIRECTORY_SEPARATOR, path);

        let is_create_dir = FALSE;

        for i, value in dirs {

            let dir.= value.DIRECTORY_SEPARATOR;
            if is_create_dir == TRUE || !is_dir(dir) {
                if mkdir(dir, permission) {
                    let is_create_dir = TRUE;

                } else {
                    //pr(dir);
                    // error
                }
                chmod(dir, permission);
            } else {
                // exists
            }
        }
        return dir;
    }

    public static function get(options = [])
    {

        if !isset options["expire"] {
            let options["expire"] = 3600;
        }
        if !isset options["key"] {
            throw new \limepie\cache\Exception("key not found");
        }
        if !isset options["value"] || typeof options["value"] != "object" {
            throw new \limepie\cache\Exception("callback function not found");
        }


        var data;
        let data = self::_get(options["key"]); // 존재확인
        if !data {

            var definition;
            let definition = options["value"];

            if (typeof definition == "object") && (definition instanceof \Closure) {
                let data = {definition}();
            } else {
                let data = definition;
            }

            self::put(options["key"], data, options["expire"]); // 생성
        }
        return data;

    }

}