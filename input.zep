
namespace Limepie;

class input
{

    public static data;

    public static function initialize()
    {

        let self::data = [
            "get"       : _GET,
            "post"      : _POST,
            "cookie"    : _COOKIE,
            "parameter" : \limepie\framework::getInstance()->getRouter()->getParameters(),
            "argument"  : \limepie\framework::getInstance()->getRouter()->getArguments(),
            "segment"   : \limepie\framework::getInstance()->getRouter()->getSegments()
        ];

    }

    public static function data(key)
    {

        var input, tmp;
        let tmp   = explode("\\", get_called_class());
        let input = end(tmp);
        return self::data[input][key];

    }

    public static function get(key, callback=NULL)
    {

        return self::callback(callback, self::data["get"][key]);

    }

    public static function post(key, callback=NULL)
    {

        return self::callback(callback, self::data["post"][key]);

    }

    public static function cookie(key, callback=NULL)
    {

        return self::callback(callback, self::data["cookie"][key]);

    }

    public static function parameter(key, callback=NULL)
    {

        return self::callback(callback, self::data["parameter"][key]);

    }

    public static function argument(key, callback=NULL)
    {

        return self::callback(callback, self::data["argument"][key]);

    }

    public static function segment(key, callback=NULL)
    {

        return self::callback(callback, self::data["segment"][key]);

    }

    protected static function callback(callback=NULL, value)
    {

        if (typeof callback == "object") && (callback instanceof \Closure) {
            return {callback}(value);
        } elseif callback && !value {
            return callback;
        } else {
            return value;
        }

    }

}