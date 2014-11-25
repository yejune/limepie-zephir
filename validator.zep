
namespace Limepie;

final class Validator
{

    private model;
    private rules;
    private messages;
    private context;
    private static methods = "";//[];
    private error;

    private function __construct(model, rules, messages)
    {

        let this->model     = self::flatten(model);
        let this->rules     = this->normalizeRules(rules);
        let this->messages  = this->normalizeRules(messages);
        let this->context   = new \limepie\validator\context(this);
        let this->error     = [];
        \limepie\config::get("validator-method");

    }

    private static function flatten(model)
    {

        var repeat, key, value, sub_key, sub_value;
        let repeat = FALSE;

        for key, value in model
        {
            if is_array(value) {
                let repeat = TRUE;

                for sub_key, sub_value in value {
                    let model[key[sub_key]] = sub_value;
                }
                unset(model[key]);
            }
        }

        if repeat {
            let model = self::flatten(model);
        }
        return model;

    }

    public static function validate(options)
    {

        var validator, method;
        var rules, messages;
        let rules = "";

        if typeof options != "array" {
            throw new \limepie\validator\Exception("parameter error");
        }

        if isset options["filter"] && isset options["filter"]["rules"] {
            let rules = options["filter"]["rules"];
        } else {
            if isset options["rules"] {
                let rules = options["rules"];
            } else {
                throw new \limepie\validator\Exception("not found rules");
            }
        }

        if isset options["filter"] && isset options["filter"]["messages"] {
            let messages = options["filter"]["messages"];
        } else {
            if isset options["messages"] {
                let messages = options["messages"];
            } else {
                let messages = [];
            }
        }
        var data;

        if isset options["data"] {
            let data = options["data"];
        } else {
            if isset options["method"] {
                if strtolower(options["method"]) == "post" {
                    let data = _POST;
                } else {
                    let data = _GET;
                }
            } else {
                // request method로 자동 지정하는것은 삭제해야할듯..
                /*
                if strtolower(_SERVER["REQUEST_METHOD"]) == "post" {
                    let data = _POST;
                } else {
                    let data = _GET;
                }
                */
                throw new \limepie\validator\Exception("not found data");
            }
        }

        let validator = new \Limepie\Validator(data, rules, messages);

        if validator->run() {
            if isset options["success"] && typeof options["success"] == "object" {
                let method = options["success"];
                {method}(validator);
            }
        } else {
            if isset options["error"] && typeof options["error"] == "object" {
                let method = options["error"];
                {method}(validator);
            }
        }
        var a;
        let a = validator->getError();
        return a;

    }


    private function normalizeRules(rules)
    {

        var name, rule, method_name, param, normalized_rule;

        for name, rule in rules {
            let normalized_rule = this->normalizeRule(rule);

            for method_name, param in normalized_rule {
                if param === FALSE {
                    unset normalized_rule[method_name];
                }
            }
            let rules[name] = normalized_rule;
        }

        return rules;

    }


    private function normalizeRule(value)
    {

        var normalized_value, method_names, method_key, method_name;
        let normalized_value = value;

        if is_string(value) {
            let normalized_value = [];
            let method_names = preg_split("/\\s/", value);
            for method_key, method_name in method_names {
                let normalized_value[method_name] = TRUE;
            }
        }
        return normalized_value;

    }

    public function field(name)
    {

        var value, rule, valid, method, method_name, param;

        if isset this->model[name] {
            let value = this->model[name];
        } else {
            let value = NULL;
        }
        if isset this->rules[name] {
            let rule = this->rules[name];
        } else {
            let rule = NULL;
        }

        var message;
        let message = "";

        if !rule {
            return FALSE;
        }

        var result = TRUE;
        for method_name, param in rule {
            let valid   = TRUE;

            if isset self::methods[method_name] {
                let method = self::methods[method_name];
            } else {
                let method = "";
            }
/*
            var callmethod;
            let callmethod = "\\Limepie\\validator\\method\\".method_name;

*/
            if method {
                if is_null(method) || {method}(this->context, value, param) {
                    let valid = TRUE;
                } else {
                    let valid = FALSE;
                }

            } else {
                /*
                pr(["------",callmethod,is_callable(callmethod),method_exists("\\Limepie\\validator\\method", method_name),is_callable(["\\Limepie\\validator\\method", method_name])]);
                if is_callable(callmethod) {
                    let valid = {callmethod}(this->context, value, param);
                } else {
                    let valid = FALSE;
                }
                */
                throw new \limepie\validator\Exception("not found '".method_name."' validate rule");
            }

            if !valid {

                if isset this->messages[name] && isset this->messages[name][method_name] {

                    var p;
                    if is_array(param) {
                        let p = param;
                    } else {
                        let p = [param];
                    }
                    let message = preg_replace("/\\{([0-9]+)\\}/","%s",this->messages[name][method_name]);

                    var s;
                    let s = array_merge([message] , p);
                    //pr([message, s]);
                    let message = call_user_func_array("sprintf", s);

                } else {
                    let message = "";
                }
                this->addError(name, method_name, param, message);

                let result = FALSE;
            }
        }
        return result;

    }

    public function addError(name, method_name, param, message)
    {

        let this->error[name][method_name] = [
            "name"      : name,
            "method"    : method_name,
            "param"     : param,
            "message"   : message
        ];

    }

    public function countError()
    {

        return count(this->error);

    }

    public function getError()
    {

        return this->error;

    }

    public function run()
    {

        var valid, name, rule;
        let valid = TRUE;


        for name, rule in this->rules {

            this->field(name);
        }
        if this->countError() == 0 {
            return TRUE;
        } else {
            return FALSE;
        }

    }

    public function invalidFields()
    {

        var invalids, name, rule;
        let invalids = [];

        for name, rule in this->rules {
            if !this->field(name) {
                let invalids[name] = isset(this->model[name]) ? this->model[name] : NULL;
            }
        }
        return invalids;

    }

    public function numberOfInvalidFields()
    {

        return count(this->invalidFields());

    }

    public function getModel()
    {

        return this->model;

    }

    public function getRules()
    {

        return this->rules;

    }

    public static function getMethods()
    {

        return self::methods;

    }

    public static function addMethod(method_name, method)
    {

        let self::methods[method_name] = method;

    }

}

