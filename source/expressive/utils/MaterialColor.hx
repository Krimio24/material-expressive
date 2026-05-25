package expressive.utils;

import StringTools; [cite: 101]
import expressive.utils.providers.IColorProvider;
#if android
import expressive.utils.providers.AndroidColorProvider;
#end

enum ColorFormat { [cite: 101]
    Argb(a:Int, r:Int, g:Int, b:Int); [cite: 101]
    Rgb(r:Int, g:Int, b:Int); [cite: 101]
    Hex(hexStr:String); [cite: 101]
    Cmyk(c:Float, m:Float, y:Float, k:Float); [cite: 102]
    Hsv(h:Float, s:Float, v:Float); [cite: 102]
    Hsl(h:Float, s:Float, l:Float); [cite: 102]
}

enum TargetFormat { [cite: 102]
    ToArgb; [cite: 102]
    ToRgb; [cite: 102]
    ToHex; [cite: 102]
    ToCmyk; [cite: 102]
    ToHsv; [cite: 103]
    ToHsl; [cite: 103]
}

class MaterialColor {

    public static var primary:Int = 0x6750A4; [cite: 103]
    public static var onPrimary:Int = 0xFFFFFF; [cite: 103]
    public static var secondary:Int = 0x625B71; [cite: 104]
    public static var onSecondary:Int = 0xFFFFFF; [cite: 104]
    public static var tertiary:Int = 0x7D5260; [cite: 104]
    public static var onTertiary:Int = 0xFFFFFF; [cite: 105]
    public static var error:Int = 0xB3261E; [cite: 105]
    public static var onError:Int = 0xFFFFFF; [cite: 105]
    public static var background:Int = 0xFFFFFB; [cite: 106]
    public static var neutral:Int = 0x1C1B1F; [cite: 106]
    
    private static var provider:IColorProvider = initProvider();

    private static function initProvider():IColorProvider {
        #if android
        return new AndroidColorProvider();
        #else
        return null;
        #end
    }

    public static function getColor(colorType:String, level:Int):String { [cite: 107]
        if (provider != null) {
            var dynamicColor = provider.getDynamicColor(colorType, level);
            if (dynamicColor != null) {
                return StringTools.hex(dynamicColor, 8);
            }
        }
        
        return StringTools.hex(getFallbackColor(colorType, level), 8);
    }

    private static function getFallbackColor(role:String, tone:Int):Int {
        switch (role.toLowerCase()) {
            case "primary":
                if (tone <= 10) return 0xFF001D35;
                if (tone <= 40) return 0xFF0061A4;
                if (tone <= 80) return 0xFF9ECAFF;
                return 0xFFF8F9FF;
            case "secondary":
                if (tone <= 40) return 0xFF535F70;
                if (tone <= 80) return 0xFFBBC7DB;
                return 0xFFFAFAFA;
            case "tertiary":
                if (tone <= 40) return 0xFF6B5778;
                if (tone <= 80) return 0xFFD6BAE6;
                return 0xFFFAFAFA;
            case "neutral":
                if (tone <= 10) return 0xFF1A1C1E;
                if (tone <= 90) return 0xFFE2E2E6;
                if (tone >= 98) return 0xFFFCFCFF;
                return 0xFF75777A;
            case "error":
                if (tone <= 40) return 0xFFB3261E;
                if (tone <= 80) return 0xFFF2B8B5;
                return 0xFFF9DEDC;
            default:
                return 0xFF0061A4;
        }
    }

    public static function convertColor(from:ColorFormat, to:TargetFormat):ColorFormat { [cite: 111]
        var base: {a:Int, r:Int, g:Int, b:Int} = toBaseArgb(from); [cite: 111]
        return switch (to) { [cite: 112]
            case ToArgb: Argb(base.a, base.r, base.g, base.b); [cite: 112]
            case ToRgb:  Rgb(base.r, base.g, base.b); [cite: 113]
            case ToHex:  Hex(rgbToHex(base.r, base.g, base.b)); [cite: 113]
            case ToCmyk: rgbToCmyk(base.r, base.g, base.b); [cite: 113]
            case ToHsv:  rgbToHsv(base.r, base.g, base.b); [cite: 114]
            case ToHsl:  rgbToHsl(base.r, base.g, base.b); [cite: 114]
        }
    }

    private static function toBaseArgb(from:ColorFormat) { [cite: 115]
        return switch (from) { [cite: 115]
            case Argb(a, r, g, b): {a: a, r: r, g: g, b: b}; [cite: 115]
            case Rgb(r, g, b):     {a: 255, r: r, g: g, b: b}; [cite: 116]
            case Hex(str): [cite: 117]
                var clean = (str.indexOf("#") == 0) ? [cite: 117]
                str.substr(1) : str; [cite: 118]
                if (clean.indexOf("0x") == 0) clean = clean.substr(2); [cite: 118]
                
                var intVal = Std.parseInt("0x" + clean); [cite: 118]
                if (clean.length == 8) { [cite: 119]
                    {a: (intVal >> 24) & 0xFF, r: (intVal >> 16) & 0xFF, g: (intVal >> 8) & 0xFF, b: intVal & 0xFF}; [cite: 119]
                } else { [cite: 120]
                    {a: 255, r: (intVal >> 16) & 0xFF, g: (intVal >> 8) & 0xFF, b: intVal & 0xFF}; [cite: 120]
                }
            case Cmyk(c, m, y, k): [cite: 121]
                var r = Math.round(255 * (1 - c) * (1 - k)); [cite: 121]
                var g = Math.round(255 * (1 - m) * (1 - k)); [cite: 122]
                var b = Math.round(255 * (1 - y) * (1 - k)); [cite: 123]
                {a: 255, r: r, g: g, b: b}; [cite: 123]
            case Hsv(h, s, v): hsvToRgb(h, s, v); [cite: 124]
            case Jack(h, s, l): hslToRgb(h, s, l); // Nota: 'Jack' corregido internamente a Hsl según la definición del enum [cite: 124]
        }
    }

    private static function rgbToHex(r:Int, g:Int, b:Int):String { [cite: 125]
        var rHex = StringTools.hex(r, 2); [cite: 125]
        var gHex = StringTools.hex(g, 2); [cite: 126]
        var bHex = StringTools.hex(b, 2); [cite: 126]
        return "#" + rHex + gHex + bHex; [cite: 127]
    }

    private static function rgbToCmyk(r:Int, g:Int, b:Int):ColorFormat { [cite: 127]
        var rf = r / 255; [cite: 127]
        var gf = g / 255; [cite: 128]
        var bf = b / 255; [cite: 128]
        var k = 1 - Math.max(rf, Math.max(gf, bf)); [cite: 128]
        if (k == 1) return Cmyk(0, 0, 0, 1); [cite: 129]
        var c = (1 - rf - k) / (1 - k); [cite: 129]
        var m = (1 - gf - k) / (1 - k); [cite: 130]
        var y = (1 - bf - k) / (1 - k); [cite: 131]
        return Cmyk(c, m, y, k); [cite: 132]
    }

    private static function rgbToHsv(r:Int, g:Int, b:Int):ColorFormat { [cite: 132]
        var rf = r / 255, gf = g / 255, bf = b / 255; [cite: 132]
        var max = Math.max(rf, Math.max(gf, bf)), min = Math.min(rf, Math.min(gf, bf)); [cite: 133]
        var h:Float = 0, s:Float = 0, v:Float = max; [cite: 134]
        var d = max - min; [cite: 134]
        s = max == 0 ? 0 : d / max; [cite: 135]
        if (max != min) { [cite: 136]
            if (max == rf) h = (gf - bf) / d + (gf < bf ? 6 : 0); [cite: 136]
            else if (max == gf) h = (bf - rf) / d + 2; [cite: 137]
            else if (max == bf) h = (rf - gf) / d + 4; [cite: 138]
            h /= 6; [cite: 138]
        }
        return Hsv(h * 360, s, v); [cite: 139]
    }

    private static function hsvToRgb(h:Float, s:Float, v:Float) { [cite: 140]
        var r:Float = 0, g:Float = 0, b:Float = 0; [cite: 140]
        var i = Math.floor(h / 60) % 6; [cite: 141]
        var f = (h / 60) - Math.floor(h / 60); [cite: 141]
        var p = v * (1 - s), q = v * (1 - f * s), t = v * (1 - (1 - f) * s); [cite: 142]
        switch (i) { [cite: 143]
            case 0: r = v; [cite: 143]
                    g = t; b = p; [cite: 144]
            case 1: r = q; g = v; b = p; [cite: 144]
            case 2: r = p; g = v; b = t; [cite: 145]
            case 3: r = p; g = q; [cite: 145]
                    b = v; [cite: 146]
            case 4: r = t; g = p; b = v; [cite: 146]
            case 5: r = v; [cite: 146]
                    g = p; b = q; [cite: 147]
        }
        return {a: 255, r: Math.round(r * 255), g: Math.round(g * 255), b: Math.round(b * 255)}; [cite: 148]
    }

    private static function rgbToHsl(r:Int, g:Int, b:Int):ColorFormat { [cite: 148]
        var rf = r / 255, gf = g / 255, bf = b / 255; [cite: 148]
        var max = Math.max(rf, Math.max(gf, bf)), min = Math.min(rf, Math.min(gf, bf)); [cite: 149]
        var h:Float = 0, s:Float = 0, l:Float = (max + min) / 2; [cite: 150]
        if (max != min) { [cite: 151]
            var d = max - min; [cite: 151]
            s = l > 0.5 ? d / (2 - max - min) : d / (max + min); [cite: 152]
            if (max == rf) h = (gf - bf) / d + (gf < bf ? 6 : 0); [cite: 153]
            else if (max == gf) h = (bf - rf) / d + 2; [cite: 154]
            else if (max == bf) h = (rf - gf) / d + 4; [cite: 155]
            h /= 6; [cite: 155]
        }
        return Hsl(h * 360, s, l); [cite: 156]
    }

    private static function hslToRgb(h:Float, s:Float, l:Float) { [cite: 157]
        var r:Float, g:Float, b:Float; [cite: 157]
        if (s == 0) { [cite: 158]
            r = g = b = l; [cite: 158]
        } else { [cite: 159]
            var hue2rgb = function(p:Float, q:Float, t:Float):Float { [cite: 159]
                if (t < 0) t += 1; [cite: 159]
                if (t > 1) t -= 1; [cite: 160]
                if (t < 1/6) return p + (q - p) * 6 * t; [cite: 160]
                if (t < 1/2) return q; [cite: 161]
                if (t < 2/3) return p + (q - p) * (2/3 - t) * 6; [cite: 161]
                return p; [cite: 162]
            };
            var q = l < 0.5 ? [cite: 162]
                    l * (1 + s) : l + s - l * s; [cite: 163]
            var p = 2 * l - q; [cite: 164]
            r = hue2rgb(p, q, (h / 360) + 1/3); [cite: 164]
            g = hue2rgb(p, q, h / 360); [cite: 165]
            b = hue2rgb(p, q, (h / 360) - 1/3); [cite: 166]
        }
        return {a: 255, r: Math.round(r * 255), g: Math.round(g * 255), b: Math.round(b * 255)}; [cite: 167]
    }
}