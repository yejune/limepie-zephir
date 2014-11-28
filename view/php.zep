
namespace Limepie\View;

class php
{

    public tpl_;// = [];
    public var_;// = [];
    public skin;
    public tpl_path;

    public function __construct()
    {
        let this->tpl_ = [];
        let this->var_ = [];
    }

    public function assign(arg, path = FALSE)
    {

        if is_array(arg) {
            let this->var_ = array_merge( this->var_, arg );
        } else {
            let this->var_[arg] = path;
        }

    }

    public function define(arg, path = FALSE)
    {

        if path {
            this->_define(arg, path);
        } else {
            var fid, path2;

            for fid, path2 in arg {
                this->_define(fid, path2);
            }
        }

    }

    public function _define(fid, path)
    {

        let this->tpl_[fid] = path;

    }

    public function show(fid, print = FALSE)
    {

        if print == TRUE {
            this->render(fid);
        } else {
            return this->fetched(fid);
        }

    }

    public function fetched(fid)
    {

        var fetched;
        ob_start();
        this->render(fid);
        let fetched = ob_get_contents();
        ob_end_clean();

        return fetched;

    }

    public function render(fid)
    {

        var tpl_path;

        let tpl_path        = this->tpl_path(fid);

        if !is_file(tpl_path) {
            throw new \limepie\view\exception("템플릿 파일이 없음 : ".tpl_path);
        }

        this->_include_tpl(tpl_path, fid);//, scope);

    }

    public function _include_tpl(cpl, tpl)
    {//, TPL_SCP)

        extract(this->var_);
        require cpl;

    }

    public function tpl_path(fid)
    {

        var path = "", skinFolder, addFolder, front, router, access, module, controller, action, basedir, prefix;

        if isset this->tpl_[fid] {
            let path = this->tpl_[fid];
        } else {
            throw new exception(fid . "이(가) 정의되어있지 않음");
        }
        if substr(path, 0, 1) == "/" {
            return path;
        } else {
            let skinFolder = trim(this->skin, "/");

            if skinFolder {
                let addFolder = skinFolder . "/";
            } else {
                let addFolder = "";
            }
            let front          = \limepie\framework::getInstance();
            let router         = front->getRouter();

            let access         = router->getParameter("access");
            let module         = router->getParameter("module");
            let controller     = router->getParameter("controller");
            let action         = router->getParameter("action");
            let basedir        = router->getParameter("basedir");
            let prefix         = router->getParameter("prefix");

            let path = strtr(path, [
                "<basedir>"         : basedir
                , "<access>"        : access
                , "<prefix>"        : prefix
                , "<module>"        : module
                , "<controller>"    : controller
                , "<action>"        : action
            ]);

            let this->tpl_[fid] = stream_resolve_include_path(addFolder . path);
            return this->tpl_[fid];

        }

    }

}
