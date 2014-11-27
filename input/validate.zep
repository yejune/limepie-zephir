
namespace Limepie\input;
use Limepie\input;

class validate extends input
{

    public static function __callStatic(name, arguments)
    {

        if in_array(name, ["email", "url", "int", "float","bool", "unsafe"]) {
            var func;
            let func = "self::".name."Rule";

            return call_user_func_array(func, arguments);
        } else {
            throw new \Exception("not support validate function name : ".name);
        }

    }

    public static function emailRule(key, callback=NULL)
    {

        var value;

        let value = parent::data(key);
        if filter_var(value, FILTER_VALIDATE_EMAIL) {
            return parent::callback(callback, value);
        }
        return NULL;

    }

    public static function urlRule(key, callback=NULL)
    {

        var value;

        let value = parent::data(key);
        if filter_var(value, FILTER_VALIDATE_URL) {
            return parent::callback(callback, value);
        }
        return NULL;

    }

    public static function intRule(key, callback=NULL)
    {

        var value;

        let value = parent::data(key);
        if filter_var(value, FILTER_VALIDATE_INT) {
            return parent::callback(callback, value);
        }
        return NULL;

    }

    public static function floatRule(key, callback=NULL)
    {

        var value, option;
        let option = FILTER_FLAG_ALLOW_FRACTION|FILTER_FLAG_ALLOW_SCIENTIFIC;
        let value = parent::data(key);
        if filter_var(value, FILTER_VALIDATE_FLOAT, option) {
            return parent::callback(callback, value);
        }
        return NULL;

    }

    public static function unsafeRule(key, callback=NULL)
    {

        return parent::callback(callback, filter_var(parent::data(key), FILTER_UNSAFE_RAW));

    }

    public static function boolRule(key, callback=NULL)
    {

        return parent::callback(callback, filter_var(parent::data(key), FILTER_VALIDATE_BOOLEAN));

    }

}