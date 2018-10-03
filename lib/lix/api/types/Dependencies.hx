package lix.api.types;

@:forward
abstract Dependencies(Array<Dependency>) from Array<Dependency> to Array<Dependency> {
  @:to
  public inline function toString()
    return tink.Json.stringify(this);
    
  public static inline function parse(v:String)
    return tink.Json.parse((v:Dependencies));
}