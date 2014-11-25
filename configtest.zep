namespace Limepie;

class configtest
{
    private static result;
    private static temp;

    public static function set(name, definition)
    {
        let self::temp[name] = definition;
    }
    public static function run(name)
    {
        var definition;
        let definition = self::temp[name];

        if (typeof definition == "object") && (definition instanceof \Closure) {
            let self::result[name] = {definition}();
        } else {
            let self::result[name] = definition;
        }
    }
    public static function get(name)
    {
        if !isset(self::result[name]) && isset self::temp[name] {
            self::run(name);
        }
        var value;
        if fetch value, self::result[name]
        {
            return self::result[name];
        } else {
            return FALSE;
        }
    }
}

