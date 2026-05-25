package expressive.utils.providers;

interface IColorProvider {
    function getDynamicColor(role:String, tone:Int):Null<Int>;
}