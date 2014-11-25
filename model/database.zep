namespace Limepie\model;

class Database extends \Pdo
{

    public function __construct(name)
    {

        var connect;
        let connect     = \limepie\config::get("db-server", name);
        if isset connect["dsn"]
            && isset connect["username"]
            && isset connect["password"]
        {
            parent::__construct(connect["dsn"], connect["username"], connect["password"]);
        } else {
            throw new \Limepie\model\Exception(name." config를 확인하세요.");
        }

    }

    private function execute(statement, bind_parameters = [], ret = FALSE)
    {

        var stmt, _bind_parameters, result, key, value;

        let stmt                = parent::prepare(statement);
        let _bind_parameters    = [];

        for key, value in bind_parameters {
            if is_array(value) {
                let _bind_parameters[key] = value[0];
            } else {
                let _bind_parameters[key] = value;
            }
        }

        let result = stmt->execute(_bind_parameters);
        if TRUE === ret {
            stmt->closeCursor();
            return result;
        } else {
            return stmt;
        }

    }

    public function gets(statement, bind_parameters = [], mode = NULL)
    {

        var stmt, result, e;//, start, end;
        try {
            //let start = \limepie\toolkit::timer(__FILE__, __LINE__);
            let stmt    = self::execute(statement, bind_parameters);
            let mode    = self::_getMode(mode);
            let result  = stmt->fetchAll(mode);
            stmt->closeCursor();
            //let end   = \limepie\toolkit::timer(__FILE__, __LINE__);

            return result;
        } catch \PDOException, e {
            if self::inTransaction() {
                self::rollback();
            }
            throw new \limepie\model\exception(e);
        }

    }

    public function get(statement, bind_parameters = [], mode = NULL)
    {

        var stmt, result, e;//, start, end;
        try {
            //let start = \limepie\toolkit::timer(__FILE__, __LINE__);
            let stmt    = self::execute(statement, bind_parameters);
            let mode    = self::_getMode(mode);
            let result  = stmt->$fetch(mode);
            stmt->closeCursor();
            //let end   = \limepie\toolkit::timer(__FILE__, __LINE__);

            return result;
        } catch \PDOException, e {
            if self::inTransaction() {
                self::rollback();
            }
            throw new \limepie\model\exception(e);
        }

    }

    /* count(*)과 같이 하나의 값만 리턴할경우 tmp[0]과 같이 사용하지 않고 바로 tmp에 select한 값을 셋팅함*/
    public function get1(statement, bind_parameters = [], mode = NULL)
    {

        var stmt, result, e, key, value;//, start, end;
        try {
            //let start = \limepie\toolkit::timer(__FILE__, __LINE__);
            let stmt    = self::execute(statement, bind_parameters);
            let mode    = self::_getMode(mode);
            let result  = stmt->$fetch(mode);
            stmt->closeCursor();
            //let end   = \limepie\toolkit::timer(__FILE__, __LINE__);

            if is_array(result) {
                for key, value in result {
                    return value;
                }
            }
            return FALSE;
        } catch \PDOException, e {
            if self::inTransaction() {
                self::rollback();
            }
            throw new \limepie\model\exception(e);
        }
    }

    public function set(statement, bind_parameters = [])
    {

        var e;
        try {
            return self::execute(statement, bind_parameters, TRUE);
        } catch \PDOException, e {
            if self::inTransaction() {
                self::rollback();
            }
            throw new \limepie\model\exception(e);
        }

    }

    public function setId(statement, bind_parameters = [])
    {   /* return int or FALSE */

        if self::set(statement, bind_parameters) {
            return self::insertid();
        }
        return FALSE;

    }

    public function insertId(name = NULL)
    {

        return self::get1("SELECT LAST_INSERT_ID()");

    }

    private function _getMode(mode = NULL)
    {

        if mode == NULL {
            let mode = self::getAttribute(\PDO::ATTR_DEFAULT_FETCH_MODE);
        }
        return mode;

    }

    public function start()
    {

        return self::begin();

    }

    public function begin()
    {

        return parent::beginTransaction();

    }

    public function rollback()
    {

        return parent::rollBack();

    }

    public function commit()
    {

        return parent::commit();

    }

}
