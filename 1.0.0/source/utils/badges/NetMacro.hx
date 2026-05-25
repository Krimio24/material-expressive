package;

import haxe.macro.Compiler;
import sys.net.Host;

class NetMacro {
    public static function init() {
        try {
            var host = new Host("8.8.8.8");
            if (host.ip != null) {
                Compiler.define("online");
            }
        } catch(e:Dynamic) {}
    }
}