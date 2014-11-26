

namespace Limepie;

class path
{

    public static function parameter(name = NULL)
    {

        return \limepie\framework::getInstance()->getRouter()->getParameter(name);

    }

    public static function param(name = NULL)
    {

        return self::parameter(name);

    }

    public static function segment(num = NULL)
    {

        return \limepie\framework::getInstance()->getRouter()->getSegment(num);

    }

    public static function position(num = NULL)
    {

        return self::position(num);

    }

    public static function pos(num = NULL)
    {

        return self::position(num);

    }

}
