package expressive.components.icons;

import expressive.utils.Text;
import expressive.components.Component;
import expressive.utils.MaterialColor;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.utils.Assets;
import lime.system.System;



class MaterialIcon extends TextField {


      public function new(icon:String, type:String, color:MaterialColor = MaterialColor.primary, size:Float, x:Float = 0, y:Float = 0) {

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
      public function getIcons():String {
        System.openURL("https://fonts.google.com/icons", "_blank");
      }
}