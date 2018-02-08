package lix.server.db;

typedef ProjectContributor = {
  var user(default, never):Id<User>;
  var project(default, never):VarChar<255>;
  var role(default, never):ContributorRole;
}

@:enum abstract ContributorRole(VarChar<255>) to String {
  var Owner = 'owner';
  var Admin = 'admin';
  var Publisher = 'publisher';
}