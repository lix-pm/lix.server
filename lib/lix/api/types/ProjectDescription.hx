package lix.api.types;

typedef ProjectDescription = {
  final id:Int;
  final owner:OwnerName;
  final name:ProjectName;
  @:optional final authors:Array<Author>;
  @:optional final url:String;
  @:optional final description:String;
  @:optional final tags:Array<Tag>;
  @:optional final deprecated:String;
}