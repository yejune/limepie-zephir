namespace Limepie\cache;

class redis
{

    public static function get(options = [])
    {

        if !isset options["expire"] {
            let options["expire"] = 3600;
        }
        if !isset options["server"] {
            throw new \limepie\cache\Exception("server not found");
        }
        if !isset options["key"] {
            throw new \limepie\cache\Exception("key not found");
        }
        if !isset options["value"] || typeof options["value"] != "object" {
            throw new \limepie\cache\Exception("callback function not found");
        }


                var data;

                var definition;
                let definition = options["value"];

                if (typeof definition == "object") && (definition instanceof \Closure) {
                    let data = {definition}();
                } else {
                    let data = definition;
                }

                return data;



    }

}
