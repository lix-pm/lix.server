package lix.server.db;

typedef ProjectTag = {
  var project(default, never):Id<Project>;
  var tag(default, never):VarChar<255>;
}