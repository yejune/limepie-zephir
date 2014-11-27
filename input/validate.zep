
namespace Limepie\input;
use Limepie\input;

class validate extends input
{

    public static function __callStatic(name, arguments)
    {

        if in_array(name, ["email", "url", "int", "float","bool", "unsafe"]) {
            var func;
            let func = "self::get".name;

            return call_user_func_array(func, arguments);
        } else {
            throw new \exception("not support validate function name : ".name);
        }

    }

    public static function getemail(key, callback=NULL)
    {

        var value;

        let value = parent::data(key);
        if filter_var(value, FILTER_VALIDATE_EMAIL) {
            return parent::callback(callback, value);
        }
        return NULL;

    }

    public static function geturl(key, callback=NULL)
    {

        var value;

        let value = parent::data(key);
        if filter_var(value, FILTER_VALIDATE_URL) {
            return parent::callback(callback, value);
        }
        return NULL;

    }

    public static function getint(key, callback=NULL)
    {

        var value;

        let value = parent::data(key);
        if filter_var(value, FILTER_VALIDATE_INT) {
            return parent::callback(callback, value);
        }
        return NULL;

    }

    public static function getfloat(key, callback=NULL)
    {

        var value, option;
        let option = FILTER_FLAG_ALLOW_FRACTION|FILTER_FLAG_ALLOW_SCIENTIFIC;
        let value = parent::data(key);
        if filter_var(value, FILTER_VALIDATE_FLOAT, option) {
            return parent::callback(callback, value);
        }
        return NULL;

    }

    public static function getunsafe(key, callback=NULL)
    {

        var value;
        let value = filter_var(parent::data(key), FILTER_UNSAFE_RAW);

        return parent::callback(callback, value);

    }

    public static function getbool(key, callback=NULL)
    {

        return parent::callback(callback, filter_var(parent::data(key), FILTER_VALIDATE_BOOLEAN));

    }

}