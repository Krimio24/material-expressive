package expressive.components;

import expressive.component.Component;
import expressive.utils.MaterialColor;
import openfl.display.BitmapData;

class Shape extends Component {
    
    public var type:String; 
    public var color:String;
    public var borderColor:String;
    public var fill:Bool;
    public var width:Float;
    public var height:Float;
    public var texture:BitmapData;

    public function new(shape:String, colorName:String, colorLevel:Int, x:Float, y:Float, size:Float, colorBorderName:String = null, borderLevel:Int = 0, fill:Bool = true) {
        super();
        type = shape;
        color = MaterialColor.getColor(colorName, colorLevel);
        borderColor = (colorBorderName != null) ? MaterialColor.getColor(colorBorderName, borderLevel) : null;
        this.fill = fill;
        this.x = x;
        this.y = y;
        width = size;
        height = size;
        drawShape();
    }

    public function setTexture(bitmap:BitmapData):Void {
        texture = bitmap;
        drawShape();
    }

    public function drawShape():Void {
        var gfx = this.graphics;
        gfx.clear();

        if (borderColor != null) {
            gfx.lineStyle(2, parseColor(borderColor));
        }

        if (texture != null) {
            gfx.beginBitmapFill(texture, null, true, true);
        } else if (fill) {
            gfx.beginFill(parseColor(color));
        }

        var cx:Float = width / 2;
        var cy:Float = height / 2;
        var r:Float = Math.min(width, height) / 2; 

        switch (type) {
            
            case 'Square':
                gfx.drawRect(0, 0, width, height);

            case 'Circle':
                gfx.drawCircle(cx, cy, r);

            case 'Oval':
                gfx.drawEllipse(0, 0, width, height);

            case 'Pill':
                gfx.drawRoundRect(0, 0, width, height, r, r);

            case 'Semicircle':
                gfx.moveTo(0, height);
                gfx.curveTo(cx, cy - r, width, height);
                gfx.lineTo(0, height);

            case 'Triangle':
                gfx.moveTo(cx, 0);
                gfx.lineTo(width, height);
                gfx.lineTo(0, height);
                gfx.lineTo(cx, 0);

            case 'Diamond':
                gfx.moveTo(cx, 0);
                gfx.lineTo(width, cy);
                gfx.lineTo(cx, height);
                gfx.lineTo(0, cy);
                gfx.lineTo(cx, 0);

            case 'Pentagon':
                drawPolygon(gfx, cx, cy, 5, r);

            case 'Hexagon':
                drawPolygon(gfx, cx, cy, 6, r);

            case '4SC' | '6SC' | '7SC' | '9SC' | '12SC':
                var radiusValue:Float = Std.parseFloat(type.split('SC')[0]);
                gfx.drawRoundRect(0, 0, width, height, radiusValue, radiusValue);

            case '4LFC':
                gfx.drawRoundRectComplex(0, 0, width, height, 24, 24, 0, 0);

            case '8LFC':
                gfx.drawRoundRectComplex(0, 0, width, height, 48, 48, 0, 0);

            case 'Slanted':
                var dephase:Float = width * 0.2; 
                gfx.moveTo(dephase, 0);
                gfx.lineTo(width, 0);
                gfx.lineTo(width - dephase, height);
                gfx.lineTo(0, height);
                gfx.lineTo(dephase, 0);

            case 'Arch':
                gfx.moveTo(0, height);
                gfx.lineTo(0, r);
                gfx.curveTo(cx, -r/2, width, r);
                gfx.lineTo(width, height);
                gfx.lineTo(0, height);

            case 'Puffy':
                gfx.moveTo(0, cy);
                gfx.curveTo(0, 0, cx, 0);
                gfx.curveTo(width, 0, width, cy);
                gfx.curveTo(width, height, cx, height);
                gfx.curveTo(0, height, 0, cy);

            case 'PuffyDiamond':
                gfx.moveTo(cx, 0);
                gfx.curveTo(width, 0, width, cy);
                gfx.curveTo(width, height, cx, height);
                gfx.curveTo(0, height, 0, cy);
                gfx.curveTo(0, 0, cx, 0);

            case 'Flower':
                gfx.moveTo(cx, cy - r);
                gfx.curveTo(cx + r, cy - r, cx + r, cy);
                gfx.curveTo(cx + r, cy + r, cx, cy + r);
                gfx.curveTo(cx - r, cy + r, cx - r, cy);
                gfx.curveTo(cx - r, cy - r, cx, cy - r);

            case 'Fan':
                gfx.moveTo(0, height);
                gfx.lineTo(0, 0);
                gfx.curveTo(width, 0, width, height);
                gfx.lineTo(0, height);

            case 'Bun':
                gfx.moveTo(0, height);
                gfx.curveTo(0, 0, cx, 0);
                gfx.curveTo(width, 0, width, height);
                gfx.lineTo(0, height);

            case 'Gem':
                var inset:Float = r * 0.4;
                gfx.moveTo(inset, 0);
                gfx.lineTo(width - inset, 0);
                gfx.lineTo(width, inset);
                gfx.lineTo(width, height - inset);
                gfx.lineTo(width - inset, height);
                gfx.lineTo(inset, height);
                gfx.lineTo(0, height - inset);
                gfx.lineTo(0, inset);
                gfx.lineTo(inset, 0);

            case 'Boom' | 'Burst':
                var puntas:Int = (type == 'Boom') ? 8 : 12;
                drawStar(gfx, cx, cy, puntas, r, r * 0.4);

            case 'SoftBoom' | 'SoftBurst':
                var puntas:Int = (type == 'SoftBoom') ? 8 : 16;
                drawStarSmoth(gfx, cx, cy, puntas, r, r * 0.5);

            case 'Sunny':
                drawStarSmoth(gfx, cx, cy, 8, r, r * 0.7);

            case 'VerySunny':
                drawStarSmoth(gfx, cx, cy, 24, r, r * 0.85);

            case 'Arrow':
                var tail:Float = height * 0.35; 
                gfx.moveTo(0, tail);
                gfx.lineTo(cx, tail);
                gfx.lineTo(cx, 0);
                gfx.lineTo(width, cy); 
                gfx.lineTo(cx, height);
                gfx.lineTo(cx, height - tail);
                gfx.lineTo(0, height - tail);
                gfx.lineTo(0, tail);

            case 'GhostIsh':
                gfx.moveTo(0, height);
                gfx.lineTo(0, cy);
                gfx.curveTo(0, 0, cx, 0); 
                gfx.curveTo(width, 0, width, cy); 
                gfx.lineTo(width, height);
                gfx.lineTo(width * 0.75, height - 10);
                gfx.lineTo(width * 0.5, height);
                gfx.lineTo(width * 0.25, height - 10);
                gfx.lineTo(0, height);

            case 'Heart':
                gfx.moveTo(cx, height * 0.85);
                gfx.curveTo(0, cy * 0.6, cx * 0.5, 0);
                gfx.curveTo(cx, 0, cx, cy * 0.4);
                gfx.curveTo(cx, 0, width - (cx * 0.5), 0);
                gfx.curveTo(width, cy * 0.6, cx, height * 0.85);

            case 'PixelCircle':
                var steps:Int = 6;
                var sizeX:Float = width / steps;
                var sizeY:Float = height / steps;
                for (row in 0...steps) {
                    for (col in 0...steps) {
                        var dx:Float = (col + 0.5) - (steps / 2);
                        var dy:Float = (row + 0.5) - (steps / 2);
                        if ((dx*dx + dy*dy) < (steps*steps / 3.8)) {
                            gfx.drawRect(col * sizeX, row * sizeY, sizeX, sizeY);
                        }
                    }
                }

            case 'PixelTriangle':
                var steps:Int = 5;
                var blockW:Float = width / steps;
                var blockH:Float = height / steps;
                for (i in 0...steps) {
                    var blocksInRow:Int = (i * 2) + 1;
                    var startX:Float = cx - (blocksInRow * blockW / 2);
                    for (b in 0...blocksInRow) {
                        gfx.drawRect(startX + (b * blockW), i * blockH, blockW, blockH);
                    }
                }

            case _:
                gfx.drawRect(0, 0, width, height);
        }

        if (texture != null || fill) {
            gfx.endFill();
        }
    }

    private function drawPolygon(gfx:Dynamic, centerX:Float, centerY:Float, sides:Int, radius:Float):Void {
        var angleStep:Float = (Math.PI * 2) / sides;
        var initialAngle:Float = (sides % 2 != 0) ? -Math.PI / 2 : 0; 
        gfx.moveTo(centerX + Math.cos(initialAngle) * radius, centerY + Math.sin(initialAngle) * radius);
        for (i in 1...sides + 1) {
            var currentAngle:Float = initialAngle + (i * angleStep);
            gfx.lineTo(centerX + Math.cos(currentAngle) * radius, centerY + Math.sin(currentAngle) * radius);
        }
    }

    private function drawStar(gfx:Dynamic, centerX:Float, centerY:Float, points:Int, outerRadius:Float, innerRadius:Float):Void {
        var numSteps:Int = points * 2;
        var angleStep:Float = Math.PI / points;
        gfx.moveTo(centerX, centerY - outerRadius);
        for (i in 1...numSteps + 1) {
            var currentRadius:Float = (i % 2 == 0) ? outerRadius : innerRadius;
            var currentAngle:Float = -Math.PI / 2 + (i * angleStep);
            gfx.lineTo(centerX + Math.cos(currentAngle) * currentRadius, centerY + Math.sin(currentAngle) * currentRadius);
        }
    }

    private function drawStarSmoth(gfx:Dynamic, centerX:Float, centerY:Float, points:Int, outerRadius:Float, innerRadius:Float):Void {
        var numSteps:Int = points * 2;
        var angleStep:Float = Math.PI / points;
        
        var currentX:Float = centerX;
        var currentY:Float = centerY - outerRadius;
        gfx.moveTo(currentX, currentY);

        for (i in 1...numSteps + 1) {
            var controlRadius:Float = (i % 2 != 0) ? outerRadius : innerRadius;
            var anchorRadius:Float = (i % 2 == 0) ? outerRadius : innerRadius;
            
            var controlAngle:Float = -Math.PI / 2 + (i * angleStep) - (angleStep / 2);
            var anchorAngle:Float = -Math.PI / 2 + (i * angleStep);
            
            var controlX:Float = centerX + Math.cos(controlAngle) * controlRadius;
            var controlY:Float = centerY + Math.sin(controlAngle) * controlRadius;
            var anchorX:Float = centerX + Math.cos(anchorAngle) * anchorRadius;
            var anchorY:Float = centerY + Math.sin(anchorAngle) * anchorRadius;

            gfx.curveTo(controlX, controlY, anchorX, anchorY);
        }
    }

    private function parseColor(c:String):Int {
        if (c == null) return 0;
        if (c.indexOf("#") == 0) return Std.parseInt("0x" + c.substr(1));
        if (c.indexOf("0x") == 0) return Std.parseInt(c);
        return 0x6750A4; 
    }
}