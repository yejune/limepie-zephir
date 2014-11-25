namespace Limepie;

class param
{

    const VALIDATE_BOOLEAN      = 1;
    const VALIDATE_BOOLEANSTR   = 2;
    const VALIDATE_INT          = 4;
    const VALIDATE_DECIMAL      = 8;
    const VALIDATE_FLOAT        = 8;
    const VALIDATE_STRING       = 16;
    const VALIDATE_ARRAY        = 32;
    const VALIDATE_BYPASS       = 64;
    const VALIDATE_URL          = 128;
    const VALIDATE_EMAIL        = 256;
    const VALIDATE_TRIM         = 512;
    const VALIDATE_SAFE         = 1024;

    public function __construct() {}
    public function __destruct() {}

    public static function trim(value)
    {

        return trim(value);

    }

    public static function safeString(value)
    {

        return preg_replace("/[^가-힣 a-zA-Z0-9-_.]/","",value);

    }

    public static function isArray(value)
    {

        if is_array(value) {
            return TRUE;
        } else {
            return FALSE;
        }

    }

    public static function isEmpty(value)
    {

        if empty(value) {
            return TRUE;
        } else {
            return FALSE;
        }

    }

    public static function isEmail(value)
    {

        return preg_match("/^"."([a-z0-9_.-]+)@([\\da-z.-]+).([a-z.]{2,6})"."$/i",value);

    }

    public static function isUrl(value)
    {

        return preg_match("/^"."(https?://)?([\\da-z.-]+).([a-z.]{2,6})"."$/i",$value);

    }

    public static function isBoolean(value)
    {

        if in_array(value, [FALSE, TRUE], TRUE) {
            return TRUE;
        } else {
            return FALSE;
        }

    }

    public static function isBooleanstr(value)
    {

        if in_array(value, ["false", "False", "FALSE", "no", "No", "n", "N", "0", "off", "Off", "OFF", FALSE, 0
                    , "true", "True", "TRUE", "yes", "Yes", "y", "Y", "1", "on", "On", "ON", TRUE, 1], TRUE) {
            return TRUE;
        } else {
            return FALSE;
        }

    }

    public static function isInterger(value)
    {

        return preg_match("/^-?([0-9]+)$/",value);
//      return is_int(value);

    }

    public static function isDecimal(value)
    {

        return preg_match("/^-?([0-9.]+)$/",value);

    }

    public static function get(name,type, defaultVar="")
    {

        var value;

        if isset _GET[name] {
            let value = _GET[name];
        } else {
            let value = "";
        }

        if typeof type == "object" {
            let _GET[name] = {type}(value);
        } else {
            let _GET[name] = self::value(value, type, defaultVar);
        }
        return _GET[name];

    }

    public static function post(name,type, defaultVar="")
    {

        var value;
        let value=NULL;

        if isset _POST[name] {
            let value = _POST[name];
        } else {
            let value = "";
        }

        if typeof type == "object" {
            let _POST[name] = {type}(value);
        } else {
            let _POST[name] = self::value(value, type, defaultVar);
        }
        return _POST[name];

    }

    public static function getInt(value, defaultVar="")
    {

        return self::get(value, self::VALIDATE_INT, defaultVar);

    }

    public static function getFloat(value, defaultVar="")
    {

        return self::get(value, self::VALIDATE_FLOAT, defaultVar);

    }

    public static function getString(value, defaultVar="")
    {

        return self::get(value, self::VALIDATE_STRING, defaultVar);

    }

    public static function getDecimal(value, defaultVar="")
    {

        return self::get(value, self::VALIDATE_FLOAT, defaultVar);

    }

    public static function getBoolean(value, defaultVar="")
    {

        return self::get(value, self::VALIDATE_BOOLEAN, defaultVar);

    }

    public static function getBooleanStr(value, defaultVar="")
    {

        return self::get(value, self::VALIDATE_BOOLEANSTR, defaultVar);

    }

    public static function getBool(value, defaultVar="")
    {

        return self::get(value, self::VALIDATE_BOOLEAN, defaultVar);

    }

    public static function getBoolStr(value, defaultVar="")
    {

        return self::get(value, self::VALIDATE_BOOLEANSTR, defaultVar);

    }

    public static function getArray(value, defaultVar="")
    {

        return self::get(value, self::VALIDATE_ARRAY, defaultVar);

    }

    public static function getCallback(value,var callback, defaultVar="")
    {

        if typeof callback == "object" {
            if isset(_GET[value]) {
                let _GET[value] = {callback}(_GET[value]);
            } else {
                let _GET[value] = {callback}("");
            }
            return _GET[value];
        } else {
            throw new \limepie\param\Exception("does not have a method 'callback'");
        }
    }


    public static function postInt(value,defaultVar="")
    {

        return self::post(value, self::VALIDATE_INT, defaultVar);

    }

    public static function postFloat(value, defaultVar="")
    {

        return self::post(value, self::VALIDATE_FLOAT, defaultVar);

    }

    public static function postString(value, defaultVar="")
    {

        return self::post(value, self::VALIDATE_STRING, defaultVar);

    }

    public static function postDecimal(value, defaultVar="")
    {

        return self::post(value, self::VALIDATE_FLOAT, defaultVar);

    }

    public static function postBoolean(value, defaultVar="")
    {

        return self::post(value, self::VALIDATE_BOOLEAN, defaultVar);

    }

    public static function postBooleanStr(value, defaultVar="")
    {

        return self::post(value, self::VALIDATE_BOOLEANSTR, defaultVar);

    }

    public static function postBool(value, defaultVar="")
    {

        return self::post(value, self::VALIDATE_BOOLEAN, defaultVar);

    }

    public static function postBoolStr(value, defaultVar="")
    {

        return self::post(value, self::VALIDATE_BOOLEANSTR, defaultVar);

    }

    public static function postArray(value, defaultVar="")
    {

        return self::post(value, self::VALIDATE_ARRAY, defaultVar);

    }

    public static function postCallback(value,var callback)
    {

        if typeof callback == "object" {
            if isset _POST[value] {
                let _POST[value] = {callback}(_POST[value]);
            } else {
                let _POST[value] = {callback}("");
            }
            return _POST[value];
        } else {
            throw new \limepie\param\Exception("does not have a method 'callback'");
        }

    }

    public static function value(value = "", type, defaultVar="")
    {

        if type & self::VALIDATE_ARRAY {
            if self::isArray(value) {
                return value;
            } else {
                return defaultVar;
            }
        } else {
            if self::isArray(value) {
                return defaultVar;
            }
        }

        if type & self::VALIDATE_SAFE {
            let value = self::safeString(value);
        }
        if type & self::VALIDATE_TRIM {
            let value = self::trim(value);
        }
        if type & self::VALIDATE_BYPASS {

        }
        if type & self::VALIDATE_EMAIL {
            if self::isEmail(value) {

            } else {
                return defaultVar;
            }
        }
        if type & self::VALIDATE_URL {
            if self::isUrl(value) {

            } else {
                return defaultVar;
            }
        }
        if type & self::VALIDATE_BOOLEAN {
            if self::isBoolean(value) {

            } else {
                return defaultVar;
            }
        }
        if type & self::VALIDATE_INT {
            if self::isInterger(value) {
            } else {
                return defaultVar;
            }
        }
        if type & self::VALIDATE_FLOAT {
            if self::isDecimal(value) {

            } else {
                return defaultVar;
            }
        }
        if self::trim(value) {
            return value;
        } else {
            return self::trim(defaultVar);
        }

    }

    public static function _post($name)
    {

    }

    public static function _get($name)
    {

    }

    public static function _file($name)
    {

    }

    public static function _cookie($name)
    {

    }

    public static function _session($name)
    {

    }

    public static function _argv($name)
    {

    }

    public static function _argc($name)
    {

    }

}
