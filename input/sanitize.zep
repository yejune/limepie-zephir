
namespace Limepie\input;
use Limepie\input;

class sanitize
{

    public static function getRaw(key)
    {

        var input, tmp, value;
        let tmp   = explode("\\", get_called_class());
        let input = end(tmp);
        return input::data[input][key];

    }

    public static function email(key, defvar=NULL)
    {

        var sanitized;
        let sanitized = filter_var(self::getRaw(key), FILTER_SANITIZE_EMAIL);
        if !filter_var(sanitized, FILTER_VALIDATE_EMAIL) {
            let sanitized = NULL;
        }
        return input::getValue(sanitized, defvar);

    }

    public static function url(key, defvar=NULL)
    {

        var sanitized;
        let sanitized = filter_var(self::getRaw(key), FILTER_SANITIZE_URL);
        if !filter_var(sanitized, FILTER_VALIDATE_URL) {
            let sanitized = NULL;
        }
        return input::getValue(sanitized, defvar);

    }

    public static function $int(key, defvar=NULL)
    {

        var sanitized;
        let sanitized = filter_var(self::getRaw(key), FILTER_SANITIZE_NUMBER_INT);
        if !filter_var(sanitized, FILTER_VALIDATE_INT) {
            let sanitized = NULL;
        }
        return input::getValue(sanitized, defvar);

    }

    public static function $float(key, defvar=NULL)
    {

        var sanitized, option;
        let option = FILTER_FLAG_ALLOW_FRACTION|FILTER_FLAG_ALLOW_SCIENTIFIC;
        let sanitized = filter_var(self::getRaw(key), FILTER_SANITIZE_NUMBER_FLOAT, option);
        if !filter_var(sanitized, FILTER_VALIDATE_FLOAT, option) {
            let sanitized = NULL;
        }
        return input::getValue(sanitized, defvar);

    }

    public static function safe(key, defvar=NULL)
    {

        return input::getValue(filter_var(self::getRaw(key), FILTER_SANITIZE_STRING), defvar);

    }

    public static function $string(key, defvar=NULL)
    {

        return input::getValue(filter_var(self::getRaw(key), FILTER_SANITIZE_STRING), defvar);

    }

    public static function htmlentities(key, defvar=NULL)
    {

        return input::getValue(filter_var(self::getRaw(key), FILTER_SANITIZE_FULL_SPECIAL_CHARS), defvar);

    }

    public static function htmlescape(key, defvar=NULL)
    {

        return input::getValue(filter_var(self::getRaw(key), FILTER_SANITIZE_SPECIAL_CHARS), defvar);

    }

}