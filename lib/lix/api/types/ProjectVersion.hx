package lix.api.types;

typedef ProjectVersion = {
  final version:Version;
  final dependencies:Array<Dependency>;
  final haxe:Constraint;
  final published:Date;
  @:optional final deprecated:String;
}