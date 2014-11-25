
namespace Limepie;

/**
 * 싱글톤 패턴, 매직함수를 사용하여 키,값의 저장소로 사용
 *
 * @package       system\space
 * @category      system
 */

class space
{

    private _variables;
    private static  _instance;
    public static name = "globals";

    public function __construct()
    {
        //let self::name = "globals";
    }

    public function __get(key)
    {

        if isset this->_variables[key] {
            return this->_variables[key];
        } else {
            return [];
        }

    }

    public function __isset(key)
    {

        return isset this->_variables[key];

    }

    public function __set(key, val)
    {

        let this->_variables[key] = val;
        return val;

    }

    public function __unset(key)
    {

        if isset this->_variables[key] {
            unset this->_variables[key];
        }

    }

    /* destroy a variable */
    public function __destruct()
    {

        let this->_variables = NULL;

    }

    public static function getInstance()
    {

        if !self::_instance {
            let self::_instance = new self();
        }
        return self::_instance;

    }

    public static function name(string name)
    {

        let self::name = name;
        return self::getInstance();

    }

    public static function setAttr(arg = [], val = NULL)
    {

        return self::setAttribute(arg, val);

    }

    public static function getAttr($attr = NULL, key = NULL)
    {

        return self::getAttribute(attr, key);

    }

    public static function getAttrs(name = NULL)
    {

        return self::getAttributes(name);

    }

    public static function setAttribute(arg = [], val = NULL)
    {

        var data;
        var p;
        var name;
        var instance;
        let name = self::name;
        let data = self::getInstance()->{name};
        let instance = self::getInstance();
        if is_array(arg) {
            let instance->{name} = array_merge (data , arg);
            return arg;
        } else {
            let p = func_get_args();
            if count(p)>1 {
                let instance->{name} = array_merge (data, [arg : val]);
                return val;
            }
        }

    }

    public static function getAttributes(name = NULL)
    {

        if !name {
            let name = self::name;
        }
        return self::getInstance()->{name};

    }

    public static function getAttribute(attr = NULL, key = NULL)
    {

        var name;
        let name = self::name;
        if attr == NULL {
            return self::getInstance()->{name};
        } else {
            if isset self::getInstance()->{name}[attr] {
                if key {
                    if isset self::getInstance()->{name}[attr][key] {
                        return self::getInstance()->{name}[attr][key];
                    }
                } else {
                    return self::getInstance()->{name}[attr];
                }
            }
        }
        return NULL;

    }

}
