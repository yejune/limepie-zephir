

namespace Limepie;

class config
{

    private static result;
    private static temp;

    public static function defined(name)
    {

        return isset self::temp[name];

    }

    public static function set(name, callback = FALSE)
    {

        if is_array(name) {
            let self::temp = array_merge(self::temp, name);

            if isset self::temp["bootstrap"] && self::temp["bootstrap"] {
                self::get("bootstrap");
                unset(self::temp["bootstrap"]);
            }
        } else {
            let self::temp[name] = callback;
        }

    }

    public static function get(name, sub = NULL, sub2 = NULL)
    {

        var result;

        if !isset self::temp[name] {
            throw new \limepie\config\Exception(name."이 없습니다.");
        }
        if !isset self::result[name] && isset self::temp[name] {
            var definition;
            let definition = self::temp[name];

            if (typeof definition == "object") &&  (definition instanceof \Closure) {
                let self::result[name] = {definition}();
            } else {
                let self::result[name] = definition;
            }
        }

        if sub2 {
            if fetch result, self::result[name][sub][sub2] {
                return result;
            } else {
                return FALSE;
            }
        } else {
            if sub {
                if fetch result, self::result[name][sub] {
                    return result;
                } else {
                    return FALSE;
                }
            } else {
                if fetch result, self::result[name] {
                    return result;
                } else {
                    return FALSE;
                }
            }
        }

    }

    public static function import(name)
    {

        if !isset self::temp[name] {
            throw new \limepie\config\Exception(name."이 없습니다.");
        }
        return self::temp[name];

    }

    public static function ini(file)
    {

        var e;
        try {
            let file = config::get("rootdir").DIRECTORY_SEPARATOR.file;
            if file_exists(file) && is_readable(file) {
                return parse_ini_file(file, TRUE);
            } else {
                throw new \limepie\config\Exception(file."이 없습니다.");
            }
        } catch \exception, e {
            throw new \limepie\config\Exception(e);
        }

    }

    public static function php(file)
    {

        var e, config;
        try {
            let file = config::get("rootdir") . DIRECTORY_SEPARATOR . file;
            if file_exists(file) && is_readable(file) {
                let config = require file;
                self::set(config);
            } else {
                throw new \limepie\config\Exception("file not found");
            }
        } catch \exception, e {
            throw new \limepie\config\Exception(e);
        }

    }

    public static function json(file)
    {

        var e, a, error;

        try {
            let file = config::get("rootdir").DIRECTORY_SEPARATOR.file;
            if file_exists(file) && is_readable(file) {
                let a = json_decode(file_get_contents(file), TRUE);
                let error = json_last_error();
                if error {
                    var msg;
                    switch (error) {
                        case JSON_ERROR_DEPTH:
                            let msg = "Maximum stack depth exceeded";
                            break;
                        case JSON_ERROR_STATE_MISMATCH:
                            let msg = "Underflow or the modes mismatch";
                            break;
                        case JSON_ERROR_CTRL_CHAR:
                            let msg = "Unexpected control character found";
                            break;
                        case JSON_ERROR_SYNTAX:
                            let msg = "Syntax error, malformed JSON";
                            break;
                        case JSON_ERROR_UTF8:
                            let msg = "Malformed UTF-8 characters, possibly incorrectly encoded";
                            break;
                    }
                    throw new \limepie\config\Exception(msg);
                } else {
                    return a;
                }
            } else {
                throw new \limepie\config\Exception(file."이 없습니다.");
            }
        } catch \exception, e {
            throw new \limepie\config\Exception(e);
        }

    }

}