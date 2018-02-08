package lix.server.db;

typedef ProjectTag = {
  var project(default, never):VarChar<255>;
  var tag(default, never):VarChar<255>;
}