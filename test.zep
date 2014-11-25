

namespace Limepie;

class test
{

    public function test() {

        int a;

        let a = 50,
            a = -70,
            a = 100.25; // throws a compiler exception

        var today = "\tfriday\n\r",
        tomorrow = "\tsaturday";

        return [today, tomorrow];
    }

    public static function array_mix(  array1 = [],  array2 = [])
    {

        var merged;
        var key, value;
        let merged = array1;
        for key, value in array2 {
            if isset merged[key] {
                if is_array(value) && is_array(merged[key]) {
                    let merged[key] = self::array_mix(merged[key], value );
                } else {
                    let merged[key] = value;
                }
            } else {
                let merged[key] = value;
            }
        }
        return merged;

    }

    public static function merge() {
        var arr1 = ["a" : 1, "b" : ["b1" : 2.1, "b2" : 2.2], "c" : 3];
        var arr2 = ["b" : ["b1" : 2.11], "d" : 4];

        pr(array_merge(arr1, arr2));
        pr(array_merge(arr2, arr1));
        pr(self::array_mix(arr1, arr2));
        pr(self::array_mix(arr2, arr1));
    }

    public static function ext(arr)
    {
        extract(arr);
    }
}