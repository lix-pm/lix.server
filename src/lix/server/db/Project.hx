package lix.server.db;

typedef Project = {
  @:primary @:autoIncrement final id:Id<Project>;
  @:unique('slug') final name:VarChar<255>;
  @:unique('slug') final owner:Id<Owner>;
  @:optional final description:VarChar<1024>;
  @:optional final url:VarChar<1024>;
  final deprecated:Bool;
}