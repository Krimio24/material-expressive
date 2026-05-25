package expressive.utils;

import openfl.display.Sprite;
import openfl.display.Loader;
import openfl.net.URLRequest;

class WebSprite extends Sprite {
    
    public function new(url:String, x:Float, y:Float) {
        super();
        var loader:Loader = new Loader();
        var request:URLRequest = new URLRequest(url);
        loader.load(request);
        this.addChild(loaderInfo.content);
        addChild(this);
        this.x = x;
        this.y = y;
    }
}