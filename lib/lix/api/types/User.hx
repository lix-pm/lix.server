package lix.api.types;

typedef User = {
  final id:Int;
  final username:String;
  @:optional final nickname:String;
}