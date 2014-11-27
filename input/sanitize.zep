
namespace Limepie\input;
use Limepie\input;

class sanitize extends input
{

    public static function __callStatic(name, arguments)
    {

        if(in_array(name, ["email", "url", "int", "float", "safe", "unsafe", "htmlescape", "htmlentities","string", "bool"])) {
            var func;
            let func = "self::".name."Rule";

            return call_user_func_array(func, arguments);
        } else {
            throw new \exception("not support sanitize function name : ".name);
        }

    }

    public static function emailRule(key, callback=NULL)
    {

        var sanitized;
        let sanitized = filter_var(parent::data(key), FILTER_SANITIZE_EMAIL);
        if filter_var(sanitized, FILTER_VALIDATE_EMAIL) {
            return parent::callback(callback, sanitized);
        }
        return NULL;

    }

    public static function urlRule(key, callback=NULL)
    {

        var sanitized;
        let sanitized = filter_var(parent::data(key), FILTER_SANITIZE_URL);
        if filter_var(sanitized, FILTER_VALIDATE_URL) {
            return parent::callback(callback, sanitized);
        }
        return NULL;

    }

    public static function intRule(key, callback=NULL)
    {

        var sanitized;
        let sanitized = filter_var(parent::data(key), FILTER_SANITIZE_NUMBER_INT);
        if filter_var(sanitized, FILTER_VALIDATE_INT) {
            return parent::callback(callback, sanitized);
        }
        return NULL;

    }

    public static function floatRule(key, callback=NULL)
    {

        var sanitized, option;
        let option = FILTER_FLAG_ALLOW_FRACTION|FILTER_FLAG_ALLOW_SCIENTIFIC;
        let sanitized = filter_var(parent::data(key), FILTER_SANITIZE_NUMBER_FLOAT, option);
        if filter_var(sanitized, FILTER_VALIDATE_FLOAT, option) {
            return parent::callback(callback, sanitized);
        }
        return NULL;

    }

    public static function safeRule(key, callback=NULL)
    {

        return parent::callback(callback, filter_var(parent::data(key), FILTER_SANITIZE_STRING));

    }

    public static function unsafeRule(key, callback=NULL)
    {

        return parent::callback(callback, filter_var(parent::data(key), FILTER_UNSAFE_RAW));

    }

    public static function stringRule(key, callback=NULL)
    {

        return parent::callback(callback, filter_var(parent::data(key), FILTER_SANITIZE_STRING));

    }

    public static function htmlentitiesRule(key, callback=NULL)
    {

        return parent::callback(callback, filter_var(parent::data(key), FILTER_SANITIZE_FULL_SPECIAL_CHARS));

    }

    public static function htmlescapeRule(key, callback=NULL)
    {

        return parent::callback(callback, filter_var(parent::data(key), FILTER_SANITIZE_SPECIAL_CHARS));

    }

    public static function boolRule(key, callback=NULL)
    {

        return parent::callback(callback, filter_var(parent::data(key), FILTER_VALIDATE_BOOLEAN));

    }

}