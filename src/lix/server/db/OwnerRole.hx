package lix.server.db;

import lix.api.types.Role;

typedef OwnerRole = {
  @:primary final user:Id<User>;
  @:primary final owner:Id<Owner>;
  final role:Role;
}