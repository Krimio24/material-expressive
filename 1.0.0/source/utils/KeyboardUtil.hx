package expressive.utils;

class KeyboardUtil {

    /**
     * Muestra el teclado virtual de Android con un tipo de entrada específico.
     * @param inputType El tipo de teclado a mostrar. Puede ser "number", "email" o cualquier otro valor para teclado de texto estándar.
     */
    public static function showSoftKeyboard(inputType:String):Void {
        #if android
        try {
            var jniShowKeyboard = lime.system.JNI.createStaticMethod("org/haxe/extension/JNIAccess", "showSoftKeyboard", "(Ljava/lang/String;)V", true);
            if (jniShowKeyboard != null) {
                jniShowKeyboard(inputType);
            }
        } catch(e:Dynamic) {}
        #end
    }

    /**
     * Oculta el teclado virtual de Android.
     */
    public static function hideSoftKeyboard():Void {
        #if android
        try {
            var jniHideKeyboard = lime.system.JNI.createStaticMethod("org/haxe/extension/JNIAccess", "hideSoftKeyboard", "()V", true);
            if (jniHideKeyboard != null) {
                jniHideKeyboard();
            }
        } catch(e:Dynamic) {}
        #end
    }
}