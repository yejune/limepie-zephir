

namespace Limepie;

class toolkit
{

    public static times ;
    public static standard;
    public static prev = 0;

    public static function timer(file = "", line = 0)
    {

        if !self::standard {
            let self::standard = self::getMicrotime();
            let self::times = [];
            return;
        }

        var currentTimer, current, diff, ret, times;
        let currentTimer = self::getMicrotime();

        let current = sprintf("%.4f", currentTimer[1] - self::standard[1] + currentTimer[0] - self::standard[0]);

        let diff = sprintf("%.4f",current - self::prev);

        let ret = "prev => ".str_pad(self::prev,6,"0", STR_PAD_RIGHT)
                .", current => ".str_pad(current,6,"0", STR_PAD_RIGHT)
                .", diff => ".str_pad(diff,6,"0", STR_PAD_RIGHT);
        if file {
            let ret = ret.", file ".file;
        }
        if line {
            let ret = ret.", line ".line;
        }
        let self::prev = current;

        let times = self::times;
        let times = array_merge(times, [ret]);
        let self::times = times;

        return ret;

    }

    public static function getTime()
    {

        return self::times;

    }

    public static function getMicrotime()
    {

        var tmp;
        let tmp = explode(" ", microtime());
        return tmp;

    }

    public static function readableSize(size)
    {

        var i;
        var unit=["B", "kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
        let i = floor(log(size,1024));

        return round(size/pow(1024,i),2).unit[i];

    }

    public static function longToIp(proper)
    {

        if proper < 0 || proper > 4294967295 {
            return FALSE;
        }
        var tmp;
        let tmp = 4294967295 - (proper - 1);
        return long2ip(-1 * tmp);

    }

    public static function ipToLong(ip)
    {

        var tmp;
        let tmp = ip2long(ip);
        if tmp == -1 || tmp === FALSE {
            return FALSE;
        }
        return sprintf("%u", tmp);

    }

    public static function getCountdown(int rem, pad = FALSE)
    {

        var day, hr, min, sec;

        let day = floor(rem / 86400);
        let hr  = floor(rem % 86400 / 3600);
        let min = floor(rem % 86400 / 60);
        let sec = (rem % 60);

        if pad == FALSE {
            return [
                "day" : day
                , "hour" : hr
                , "min" : min
                , "sec" : sec
            ];
        }

        return [
            "day" : day
            , "hour" : str_pad(hr, 2, "0", STR_PAD_LEFT)
            , "min" : str_pad(min, 2, "0", STR_PAD_LEFT)
            , "sec" : str_pad(sec, 2, "0", STR_PAD_LEFT)
        ];

    }

    public static function toDate(date)
    {

        return str_replace([
            "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
        ], [
            "일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"
        ], date("Y년 m월 d일 l", strtotime(date)));

    }

}
