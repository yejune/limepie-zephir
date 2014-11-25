

namespace Limepie;





class router
{

    private pathinfo;
    private routes;
    private args                = [];
    private segment             = [];
    private parameter           = [];
    private basedir             = "";
    private prefix              = "";
    private access              = "front";
    private module              = "main";
    private controller          = "index";
    private action              = "index";
    private rootdir             = "";
    private matchRoute;
    private systemVariables     = ["access", "basedir","module","action","controller","prefix"];
    private controllerDir       = "<basedir>/<module>/<access>";
    private controllerNamespace = "<basedir>\<module>\<access>";
    private actionSuffix        = "Action";
    private controllerSuffix    = "Controller";
    private notFound;

    public function __construct(routes)
    {

        let this->routes    = routes;

        this->setPathinfo();

    }

    public function setAccess(mode, defaultVar = FALSE)
    {

        var matched, m, mo, dirinfo, key, value;

        let dirinfo = this->getPathinfo();

        let mo      = implode("|",mode);
        let m = [];

        if !dirinfo || dirinfo == "/" {
        } else {
            int ia = 0;

            for key, value in mode {
                if value == dirinfo {
                    let ia = 1;
                    break;
                }
            }

            if ia == 1 {
                let m = ["access" : dirinfo];
                let dirinfo = dirinfo."/";
            } else {
                let matched = preg_match("#((?P<access>".mo.")/)#",dirinfo, m);
            }
        }

        if isset m["access"] {
            this->setPathinfo(str_replace(m["access"]."/","",dirinfo), TRUE);
            this->setDefaultAccess(m["access"]);
        } else {
            if defaultVar {
                this->setDefaultAccess(defaultVar);
            } else {
                this->setDefaultAccess(mode[0]);
            }
        }

    }

    public function setAccessByDomain(mode, defaultVar = FALSE)
    {

        var m, matched, mo;
        let mo = implode("|",mode);
        let m = NULL;
        let matched = preg_match("#((?P<access>".mo.").)#",_SERVER["HTTP_HOST"], m);

        if isset m["access"] {
            this->setDefaultAccess(m["access"]);
        } else {
            if defaultVar {
                this->setDefaultAccess(defaultVar);
            } else {
                this->setDefaultAccess(mode[0]);
            }
        }

    }

    public function setControllerDir(dir)
    {

        let this->controllerDir = dir;

    }

    public function getControllerDir()
    {

        return this->controllerDir;

    }

    public function setControllerNamespace(className)
    {

        let this->controllerNamespace = className;

    }

    public function getControllerNamespace()
    {

        return this->controllerNamespace;

    }

    public function setRootdir(r)
    {

        let this->rootdir = r."/";

    }

    public function getRootdir()
    {

        return this->rootdir;

    }

    public function getArgs()
    {

        return this->args;

    }

    public function setRoutes(routes = [])
    {

        let this->routes = routes;

    }

    public function add(key, route = [])
    {

        let this->routes[key] = route;

    }

    public function setDefaultBaseDir(basedir)
    {

        let this->basedir = basedir;

    }

    public function getBaseDir()
    {

        return this->basedir;

    }

    public function setDefaultPrefix(prefix)
    {

        let this->prefix = prefix;

    }

    public function getPrefix()
    {

        return this->prefix;

    }

    public function setDefaultAccess(access)
    {

        let this->access = access;

    }

    public function getAccess()
    {

        return this->access;

    }

    public function setDefaultModule(module)
    {

        let this->module = module;

    }

    public function getModule()
    {

        return this->module;

    }

    public function setDefaultController(controller)
    {

        let this->controller = controller;

    }

    public function getController()
    {

        return this->controller;

    }

    public function setDefaultAction(action)
    {

        let this->action = action;

    }

    public function getAction()
    {

        return this->action;

    }

    public function setControllerSuffix(controller)
    {

        let this->controllerSuffix = controller;

    }

    public function getControllerSuffix()
    {

        return this->controllerSuffix;

    }

    public function setActionSuffix(action)
    {

        let this->actionSuffix      = action;

    }

    public function getActionSuffix()
    {

        return this->actionSuffix;

    }

    public function getPathinfo()
    {

        return this->pathinfo;

    }

    public function setPathinfo(pathinfo = NULL, isForce = FALSE)
    {

        if pathinfo || isForce {
            let this->pathinfo  = pathinfo;
        } else {
            if isset _SERVER["PATH_INFO"] {
                let this->pathinfo  = trim(_SERVER["PATH_INFO"],"/");
            } else {
                let this->pathinfo  = "";
            }
        }
        let this->segment   = [];

    }

    public function getParameter(key = NULL)
    {

        if is_null(key) {
            return this->parameter;
        }

        if isset this->parameter[key] {
            return this->parameter[key];
        }
        return NULL;

    }

    public function getParam(key = NULL)
    {

        return this->getParameter(key);

    }

    public function getSegment(key = NULL)
    {

        if is_null(key) {
            return this->segment;
        }

        if isset this->segment[key] {
            return this->segment[key];
        }
        return NULL;

    }

    private function getSystemVariables()
    {

        var ret, key, funcKey;
        let ret = [];

        for key in this->systemVariables {
            let funcKey = "get".key;
            let ret[key] = this->{funcKey}();
        }
        return ret;

    }

    public function getMatchRoute()
    {

        return this->matchRoute;

    }

    public function routing()
    {

        var i, parameter, defaultVar, rule, key, value, m1, _path, c;

        if !this->routes || !is_array(this->routes) || !count(this->routes) {
            let this->routes["(?P<module>[^/]+)?"."(?:/(?P<controller>[^/]+))?"."(?:/(?P<action>[^/]+))?"."(?:/(?P<parameter>.*))?"] = []; //"((?P<access>back)(?:/)?)?".
        }

        let this->parameter = [];
        let m1 = NULL;
        for rule, defaultVar in this->routes  {
            if preg_match("#^".rule."#", this->pathinfo, m1) {
                let parameter = this->getSystemVariables();
                let this->parameter = defaultVar + parameter; // defaultVar 우선

                let _path   = [];
                if isset m1["parameter"] {
                    if trim(m1["parameter"]) != "" {
                        let _path   = explode("/",rtrim(m1["parameter"], "/"));;
                        let this->args = _path;
                    }
                }

                let c = count(_path) - 1;

                if c > 0 {
                    for i in range(0, c, 2) {
                        if isset _path[i]
                            && _path[i]
                            && FALSE == in_array(_path[i], this->systemVariables)
                        {
                            if isset _path[i+1] {
                                let this->parameter[_path[i]] = _path[i+1];
                            } else {
                                let this->parameter[_path[i]] = "";
                            }
                        }
                    }
                }

                for key, value in m1 {
                    if !is_numeric(key) && value {
                        let this->parameter[key] = value;
                    }
                }
                let this->matchRoute = [rule : defaultVar];
                break;
            }
        }

        return this->parameter;

    }

    public function notFound(route)
    {

        let this->notFound = ["(.*)" : route];

    }

    public function getNotFound()
    {

        return this->notFound;

    }
}