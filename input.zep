
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

    public static function unsafe(key, <\closure> callback)
    {

        return self::getValue(self::getRaw(key), callback);

    }

    public static function unsafeAll()
    {

        var input, tmp;
        let tmp   = explode("\\", get_called_class());
        let input = end(tmp);
        return self::data[input];

    }

    public static function getRaw(key)
    {

        var input, tmp, value;
        let tmp   = explode("\\", get_called_class());
        let input = end(tmp);
        return input::data[input][key];

    }

    public static function getValue(value=NULL, definition=NULL)
    {

        if (typeof definition == "object") && (definition instanceof \Closure) {
            return {definition}(value);
        } elseif definition && !value {
            return definition;
        } else {
            return value;
        }

    }

}