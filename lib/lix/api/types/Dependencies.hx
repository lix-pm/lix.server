package lix.api.types;

import tink.json.Representation;
using tink.CoreApi;

@:forward
abstract Dependencies(Array<Dependency>) from Array<Dependency> to Array<Dependency> {
  @:to
  public inline function toString():String
    return toStringArray().join(',');
  
  @:from
  public static inline function fromString(v:String):Dependencies
    return parse(v).sure();
  
  public static function parse(v:String):Outcome<Dependencies, Error> {
    var ret:Array<Dependency> = [];
    for(s in v.split(',')) {
      switch s.indexOf('#') {
        case -1: ret.push({name: s});
        case i: 
          switch Constraint.parse(s.substr(i + 1)) {
            case Success(constraint): ret.push({name: s.substr(0, i), constraint: constraint});
            case Failure(e): return Failure(e);
          }
      }
    }
    return Success(ret);
  }
  
  function toStringArray()
    return [for(dep in this) dep.name + (dep.constraint == null ? '' : '#' + dep.constraint.toString())];
}