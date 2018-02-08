package lix.server.db;

typedef User = {
  var id(default, never):Id<User>;
  var nick(default, never):VarChar<255>;
}