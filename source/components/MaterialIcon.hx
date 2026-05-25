package expressive.components.icons;

import expressive.utils.Text;
import expressive.components.Component;
import expressive.utils.MaterialColor;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.utils.Assets;
import lime.system.System;

enum IconType {
    Rounded;
    Sharp;
    Outlined;
}

class MaterialIcon extends TextField {

      public function new(icon:String, type:IconType, color:MaterialColor = MaterialColor.primary, size:Float, x:Float = 0, y:Float = 0) {

        var format:TextFormat = new TextFormat('fonts/Material_Symbols_$type/M.ttf', size, color);
        this.defaultTextFormat = format;
        this.embedFonts = true; 
        this.text = icon; 
        this.x = x;
        this.y = y;
        this.width = size;
        this.height = size;
        addChild(this);

      }
}