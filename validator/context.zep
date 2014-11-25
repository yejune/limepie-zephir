
namespace Limepie\validator;

final class Context
{

    private validator;

    public function __construct(<\Limepie\validator> validator)
    {

        let this->validator = validator;

    }

    public function optional(value)
    {

        if is_null(value) || value === "" {
            return TRUE;
        } else {
            return FALSE;
        }

    }

    public function xparseSelector(selector)
    {

        var result;

        let result = [
            "name"          : substr(selector,1),
            "pseudo-class"  : ""
        ];

        return result;

    }

    public function parseSelector(selector)
    {

        var result, matches;
        let selector = str_replace("\\[", "[", selector);
        let selector = str_replace("\\]", "]", selector);

        let result = [];
        let matches = [];
        if preg_match("/^#([A-Za-z][\\w\\-\\.]*)(:\\w+)?$/", selector, matches) ||
            preg_match("/^\\[name=([\\w\\-\\.\\[\\]]+)\\](:\\w+)?$/", selector, matches) {
            let result = [
                "name"          : matches[1],
                "pseudo-class"  : isset(matches[2]) ? matches[2] : NULL
            ];
        }
        return result;

    }

    public function resolve(value, param)
    {

        var result;
        let result = FALSE;
        if is_bool(param) {
            let result = param;
        } else {
            if is_string(param) {
                let result = this->resolveExpression(param);
            } else {
                if is_callable(param) {
                    let result = {param}(this->validator, value);
                }
            }
        }
        return result;

    }

    private function resolveExpression(expression)
    {

        var result, parts, name, pseudo_class, model;
        let result = FALSE;
        let parts = this->parseSelector(expression);
        if parts {
            let name            = parts["name"];
            let pseudo_class    = parts["pseudo-class"];
            let model           = this->validator->getModel();
            switch (pseudo_class) {
                case "checked":
                    let result = array_key_exists(name, model);
                    break;
                case "unchecked":
                    let result = !array_key_exists(name, model);
                    break;
                case "filled":
                    let result = array_key_exists(name, model) && strlen(model[name]) > 0;
                    break;
                case "blank":
                    let result = array_key_exists(name, model) && strlen(model[name]) === 0;
                    break;
                case NULL:
                    // No pseudo-class.
                    let result = array_key_exists(name, model);
                    break;
                default:
                    // Unsupported pseudo-class.
                    let result = array_key_exists(name, model);
                    break;
            }
        }
        return result;

    }

    public function getValidator()
    {

        return this->validator;

    }

}