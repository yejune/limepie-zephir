
namespace Limepie;

class input
{

    public static data;

    public static function init()
    {

        let self::data = [
            "get"    : _GET,
            "post"   : _POST,
            "cookie" : _COOKIE
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