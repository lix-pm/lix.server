package lix.api.types;

typedef ProjectVersion = {
  final version:Version;
  final dependencies:Array<Dependency>;
  final haxe:Constraint;
  final published:Date;
  final deprecated:Bool;
}