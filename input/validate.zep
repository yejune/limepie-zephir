
namespace Limepie\input;
use Limepie\input;

class validate
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

        var value;

        let value = self::getRaw(key);
        if !filter_var(value, FILTER_VALIDATE_EMAIL) {
            let value = NULL;
        }
        return input::getValue(value, defvar);

    }

    public static function url(key, defvar=NULL)
    {

        var value;

        let value = self::getRaw(key);
        if !filter_var(value, FILTER_VALIDATE_URL) {
            let value = NULL;
        }
        return input::getValue(value, defvar);

    }

    public static function $int(key, defvar=NULL)
    {

        var value;

        let value = self::getRaw(key);
        if !filter_var(value, FILTER_VALIDATE_INT) {
            let value = NULL;
        }
        return input::getValue(value, defvar);

    }

    public static function $float(key, defvar=NULL)
    {

        var value, option;
        let option = FILTER_FLAG_ALLOW_FRACTION|FILTER_FLAG_ALLOW_SCIENTIFIC;
        let value = self::getRaw(key);
        if !filter_var(value, FILTER_VALIDATE_FLOAT, option) {
            let value = NULL;
        }
        return input::getValue(value, defvar);

    }

    public static function $bool(key, defvar=NULL)
    {

        return input::getValue(filter_var(self::getRaw(key), FILTER_VALIDATE_BOOLEAN), defvar);

    }

}