package lix.api.types;

typedef ProjectDescription = {
  final name:ProjectName;
  final description:String;
  final authors:Array<Author>;
  @:optional final tags:Array<Tag>;
  @:optional final deprecated:Bool;
}