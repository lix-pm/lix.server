package lix.server.db;

import lix.api.types.Role;

typedef OwnerRole = {
  @:primary var user(default, never):Id<User>;
  @:primary var owner(default, never):Id<Owner>;
  var role(default, never):Role;
}