namespace Limepie;

class view
{

    public static function show(define = FALSE, display = FALSE)
    {

        var definition;
        let definition = config::import("template");

        if (typeof definition == "object") && (definition instanceof \Closure) {
            return {definition}(define, display);
        }

        // default
        var tpl;
        let tpl = new view\php;

        if is_array(define) {
            tpl->define(define, display);
        } else {
            let display = define;
        }
        tpl->define( space::name("__define__")->getAttributes());
        tpl->assign( space::name("__assign__")->getAttributes());

        return tpl->show("layout", display);

    }

    public static function assign(arg = [], val = NULL)
    {

        return  space::name("__assign__")->setAttribute(arg, val);

    }

    // alias assign
    public static function set(arg = [], val = NULL)
    {

        return self::assign(arg, val) ;

    }

    public static function get(attr = NULL, key = NULL)
    {

        return  space::name("__assign__")->getAttribute(attr, key);

    }

    public static function define(arg = [], val = NULL)
    {

        return  space::name("__define__")->setAttribute(arg, val);

    }

}

