package expressive.utils;

import StringTools;

enum ColorFormat {
    Argb(a:Int, r:Int, g:Int, b:Int);
    Rgb(r:Int, g:Int, b:Int);
    Hex(hexStr:String);
    Cmyk(c:Float, m:Float, y:Float, k:Float); 
    Hsv(h:Float, s:Float, v:Float);           
    Hsl(h:Float, s:Float, l:Float);           
}

enum TargetFormat {
    ToArgb;
    ToRgb;
    ToHex;
    ToCmyk;
    ToHsv;
    ToHsl;
}

class MaterialColor {

    public static var primary:Int = 0x6750A4;
    public static var onPrimary:Int = 0xFFFFFF;
    public static var secondary:Int = 0x625B71;
    public static var onSecondary:Int = 0xFFFFFF;
    public static var tertiary:Int = 0x7D5260;
    public static var onTertiary:Int = 0xFFFFFF;
    public static var error:Int = 0xB3261E;
    public static var onError:Int = 0xFFFFFF;
    public static var background:Int = 0xFFFFFB;
    public static var neutral:Int = 0x1C1B1F;

    public static function getColor(colorType:String, level:Int):String {
    
        #if android
        try {
            var getMaterialDynamicColor_jni = JNI.createStaticMethod("com/utils/MaterialYouUtils", "getMaterialDynamicColor", "(Landroid/content/Context;Ljava/lang/String;I)I"
            );
            
            var context = lime.app.Application.current.window.context; 
            
            var color = getMaterialDynamicColor_jni(context, colorType, level);
            return StringTools.hex('0x$color');
        } catch(e:Dynamic) {
            trace(e);
        }
        #end
        
        return 0xFF75777A;
    }

    public static function convertColor(from:ColorFormat, to:TargetFormat):ColorFormat {
        var base: {a:Int, r:Int, g:Int, b:Int} = toBaseArgb(from);

        return switch (to) {
            case ToArgb: Argb(base.a, base.r, base.g, base.b);
            case ToRgb:  Rgb(base.r, base.g, base.b);
            case ToHex:  Hex(rgbToHex(base.r, base.g, base.b));
            case ToCmyk: rgbToCmyk(base.r, base.g, base.b);
            case ToHsv:  rgbToHsv(base.r, base.g, base.b);
            case ToHsl:  rgbToHsl(base.r, base.g, base.b);
        }
    }

    private static function toBaseArgb(from:ColorFormat) {
        return switch (from) {
            case Argb(a, r, g, b): {a: a, r: r, g: g, b: b};
            case Rgb(r, g, b):     {a: 255, r: r, g: g, b: b};
            case Hex(str):
                var clean = (str.indexOf("#") == 0) ? str.substr(1) : str;
                if (clean.indexOf("0x") == 0) clean = clean.substr(2);
                
                var intVal = Std.parseInt("0x" + clean);
                if (clean.length == 8) {
                    {a: (intVal >> 24) & 0xFF, r: (intVal >> 16) & 0xFF, g: (intVal >> 8) & 0xFF, b: intVal & 0xFF};
                } else {
                    {a: 255, r: (intVal >> 16) & 0xFF, g: (intVal >> 8) & 0xFF, b: intVal & 0xFF};
                }
            case Cmyk(c, m, y, k):
                var r = Math.round(255 * (1 - c) * (1 - k));
                var g = Math.round(255 * (1 - m) * (1 - k));
                var b = Math.round(255 * (1 - y) * (1 - k));
                {a: 255, r: r, g: g, b: b};
            case Hsv(h, s, v): hsvToRgb(h, s, v);
            case Hsl(h, s, l): hslToRgb(h, s, l);
        }
    }

    private static function rgbToHex(r:Int, g:Int, b:Int):String {
        var rHex = StringTools.hex(r, 2);
        var gHex = StringTools.hex(g, 2);
        var bHex = StringTools.hex(b, 2);
        return "#" + rHex + gHex + bHex;
    }

    private static function rgbToCmyk(r:Int, g:Int, b:Int):ColorFormat {
        var rf = r / 255;
        var gf = g / 255;
        var bf = b / 255;
        var k = 1 - Math.max(rf, Math.max(gf, bf));
        if (k == 1) return Cmyk(0, 0, 0, 1);
        var c = (1 - rf - k) / (1 - k);
        var m = (1 - gf - k) / (1 - k);
        var y = (1 - bf - k) / (1 - k);
        return Cmyk(c, m, y, k);
    }

    private static function rgbToHsv(r:Int, g:Int, b:Int):ColorFormat {
        var rf = r / 255, gf = g / 255, bf = b / 255;
        var max = Math.max(rf, Math.max(gf, bf)), min = Math.min(rf, Math.min(gf, bf));
        var h:Float = 0, s:Float = 0, v:Float = max;
        var d = max - min;
        s = max == 0 ? 0 : d / max;
        if (max != min) {
            if (max == rf) h = (gf - bf) / d + (gf < bf ? 6 : 0);
            else if (max == gf) h = (bf - rf) / d + 2;
            else if (max == bf) h = (rf - gf) / d + 4;
            h /= 6;
        }
        return Hsv(h * 360, s, v);
    }

    private static function hsvToRgb(h:Float, s:Float, v:Float) {
        var r:Float = 0, g:Float = 0, b:Float = 0;
        var i = Math.floor(h / 60) % 6;
        var f = (h / 60) - Math.floor(h / 60);
        var p = v * (1 - s), q = v * (1 - f * s), t = v * (1 - (1 - f) * s);
        switch (i) {
            case 0: r = v; g = t; b = p;
            case 1: r = q; g = v; b = p;
            case 2: r = p; g = v; b = t;
            case 3: r = p; g = q; b = v;
            case 4: r = t; g = p; b = v;
            case 5: r = v; g = p; b = q;
        }
        return {a: 255, r: Math.round(r * 255), g: Math.round(g * 255), b: Math.round(b * 255)};
    }

    private static function rgbToHsl(r:Int, g:Int, b:Int):ColorFormat {
        var rf = r / 255, gf = g / 255, bf = b / 255;
        var max = Math.max(rf, Math.max(gf, bf)), min = Math.min(rf, Math.min(gf, bf));
        var h:Float = 0, s:Float = 0, l:Float = (max + min) / 2;
        if (max != min) {
            var d = max - min;
            s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
            if (max == rf) h = (gf - bf) / d + (gf < bf ? 6 : 0);
            else if (max == gf) h = (bf - rf) / d + 2;
            else if (max == bf) h = (rf - gf) / d + 4;
            h /= 6;
        }
        return Hsl(h * 360, s, l);
    }

    private static function hslToRgb(h:Float, s:Float, l:Float) {
        var r:Float, g:Float, b:Float;
        if (s == 0) {
            r = g = b = l;
        } else {
            var hue2rgb = function(p:Float, q:Float, t:Float):Float {
                if (t < 0) t += 1;
                if (t > 1) t -= 1;
                if (t < 1/6) return p + (q - p) * 6 * t;
                if (t < 1/2) return q;
                if (t < 2/3) return p + (q - p) * (2/3 - t) * 6;
                return p;
            };
            var q = l < 0.5 ? l * (1 + s) : l + s - l * s;
            var p = 2 * l - q;
            r = hue2rgb(p, q, (h / 360) + 1/3);
            g = hue2rgb(p, q, h / 360);
            b = hue2rgb(p, q, (h / 360) - 1/3);
        }
        return {a: 255, r: Math.round(r * 255), g: Math.round(g * 255), b: Math.round(b * 255)};
    }
}