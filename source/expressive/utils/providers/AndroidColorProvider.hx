package expressive.utils.providers;

#if android
import lime.system.JNI;
#end

class AndroidColorProvider implements IColorProvider {
    
    public function new() {}

    public function getDynamicColor(role:String, tone:Int):Null<Int> {
        #if android
        try {
            // Ya no pasamos un Context desde Haxe. La firma JNI cambia a (String, Int) -> Int
            var getDynamicColor_jni = JNI.createStaticMethod("com/utils/MaterialColors", "getMaterialDynamicColor", "(Ljava/lang/String;I)I");
            
            var color:Int = getDynamicColor_jni(role, tone);
            
            // Si Java retorna -1, significa que no soportamos Material You o falló.
            if (color != -1) {
                return color;
            }
        } catch(e:Dynamic) {
            trace("JNI Error: " + e);
        }
        #end
        
        return null;
    }
}