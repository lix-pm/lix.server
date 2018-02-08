package lix.api.types;

typedef ProjectFilter = {
  @:optional var tags:Array<Tag>;
  @:optional var textSearch:String;
  @:optional var includeDeprecated:Bool;
  @:optional var modifiedSince:Date;
  @:optional var limit:Int;
  @:optional var offset:Int;
}