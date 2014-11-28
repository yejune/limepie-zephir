

namespace Limepie;

class framework
{

    private static instance = NULL;
    public router;

    public function __construct() {}
    public function __destruct() {}

    public static function getInstance()
    {

        if !self::instance {
            let self::instance = new self;
        }
        return self::instance;

    }

    public function setRouter( router )
    {

        router->routing();
        let this->router = router;

    }

    public function getRouter()
    {

        return this->router;

    }

    private function run(arguments = [])
    {

        var access, module, controller, action, basedir, prefix, className, actionName, baseFolderName, namespaceName, fileName, folderName, callClassName, requireFileInfo;

        let access          = this->getRouter()->getParameter("access");
        let module          = this->getRouter()->getParameter("module");
        let controller      = this->getRouter()->getParameter("controller");
        let action          = this->getRouter()->getParameter("action");
        let basedir         = this->getRouter()->getParameter("basedir");
        let prefix          = this->getRouter()->getParameter("prefix");

        let namespaceName   = strtr(this->getRouter()->getControllerNamespace(), [
            "<basedir>"         : str_replace("/","\\", basedir)
            , "<access>"        : access
            , "<prefix>"        : prefix
            , "<module>"        : module
            , "<controller>"    : controller
            , "<action>"        : action
        ]);

        let className       = controller.this->getRouter()->getControllerSuffix();
        let actionName      = action.this->getRouter()->getActionSuffix();
        let baseFolderName  = strtr(this->getRouter()->getControllerDir(), [
            "<basedir>"         : basedir
            , "<access>"        : access
            , "<prefix>"        : prefix
            , "<module>"        : module
            , "<controller>"    : controller
            , "<action>"        : action
        ]);

        let fileName        = stream_resolve_include_path(baseFolderName."/".className.".php");
        let folderName      = dirname(fileName);
        let callClassName   = namespaceName."\\".className;

        if !arguments {
            let arguments = this->getRouter()->getArguments();
        }

        let requireFileInfo = [
            "folder"    : folderName,
            "file"      : fileName,
            "namespace" : namespaceName,
            "class"     : className,
            "method"    : actionName
        ];


        if file_exists(fileName) && is_readable(fileName) {

            if FALSE == in_array(fileName, get_included_files()) {
                require fileName;
            }

            if !class_exists(callClassName, FALSE) {
                return this->forwardNotFound(this->getRouter()->getNotFound(), arguments, "클레스 없음", "class_does_not_exist", requireFileInfo);
            }

            var requestMethod;
            if _SERVER["REQUEST_METHOD"] {
                let requestMethod = strtolower(_SERVER["REQUEST_METHOD"]);
            } else {
                let requestMethod = "get";
            }
            var requestMethodActionName;
            let requestMethodActionName = requestMethod."_".actionName;

            var instance;
            let instance = new {callClassName};

            if TRUE === method_exists(instance, requestMethodActionName) && is_callable([instance, requestMethodActionName]) {
                return call_user_func_array([instance, requestMethodActionName], arguments);
            } elseif TRUE === method_exists(instance, actionName) && is_callable([instance, actionName]) {
                return call_user_func_array([instance, actionName], arguments);
            } else {
                return this->forwardNotFound(this->getRouter()->getNotFound(), arguments, "메소드 없음", "method_does_not_exist", requireFileInfo);
            }

        } else {
            if !is_dir(folderName) {
                return this->forwardNotFound(this->getRouter()->getNotFound(), arguments, "폴더 없음", "folder_does_not_exist", requireFileInfo);
            } else {
                return this->forwardNotFound(this->getRouter()->getNotFound(), arguments, "파일 없음", "file_does_not_exist", requireFileInfo);
            }
        }

    }

    private function forwardNotFound(routes = [], arguments = [], errorMessage, errorCode, requireFileInfo)
    {

        var prevRouter, framework, newRouter;

        let prevRouter = clone this->getRouter();
        this->getRouter()->setRoutes(routes);
        let framework  = self::getInstance();
        framework->setRouter(this->getRouter());
        let newRouter  = framework->getRouter();
        newRouter->setError(errorMessage, errorCode, requireFileInfo);

        if prevRouter->getMatchRoute() == newRouter->getMatchRoute() {
            throw new \limepie\router\exception(("error 404route."), "error 404route", arguments);
        }
        return framework->dispatch(arguments);

    }

    public function forward(config)
    {

        var arguments;
        if isset config["arguments"] {
            let arguments = config["arguments"];
        } else {
            let arguments = [];
        }
        return this->_forward(config["route"], arguments);

    }

    private function _forward(routes = [], arguments = [])
    {

        var prevRouter, framework, newRouter;

        let prevRouter = clone this->getRouter();
        this->getRouter()->setRoutes(routes);
        let framework  = self::getInstance();
        framework->setRouter(this->getRouter());
        let newRouter  = framework->getRouter();

        if prevRouter->getMatchRoute() == newRouter->getMatchRoute() {
            throw new \limepie\router\exception(("error forward route."), "error foward route", arguments);
        }
        return framework->dispatch(arguments);

    }

    public function dispatch(arguments = [])
    {

        return this->run(arguments);

    }
}
