

namespace Limepie;

class path
{

    public static function param(name = FALSE)
    {

        return \limepie\framework::getInstance()->route->getParameter(name);

    }

    public static function position(num = FALSE)
    {

        return \limepie\framework::getInstance()->route->getSegment(num);

    }

    public static function pos(num = FALSE)
    {

        return self::position(num);

    }

}
