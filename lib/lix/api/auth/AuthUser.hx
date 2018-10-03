package lix.api.auth;

interface AuthUser {
  var id(default, null):Int;
  function hasRole(target:Target, role:Role):Promise<Bool>;
}

enum Target {
  Owner(owner:OwnerName);
  Project(id:ProjectIdentifier);
}
