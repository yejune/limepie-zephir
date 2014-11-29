namespace Limepie;

class response
{
    public static function json(arr)
    {
        return json_encode(arr);
    }

    public static function jsonp(arr)
    {
        return isset(_REQUEST["callback"])
                ? _REQUEST["callback"]."(".self::json(arr).");"
                : self::json(arr);
    }
}
