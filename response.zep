namespace Limepie;

class response
{
    public static function json($array)
    {
        return json_encode($array);
    }

    public static function jsonp($array)
    {
        return isset($_REQUEST["callback"]) ? $_REQUEST["callback"]."(".self::json($array).");" : self::json($array);
    }
}
