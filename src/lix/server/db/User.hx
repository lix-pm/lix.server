package lix.server.db;

typedef User = {
  @:primary @:autoIncrement var id(default, never):Id<User>;
  @:unique var username(default, never):VarChar<255>;
  @:optional var nickname(default, never):VarChar<255>;
  @:optional var passwordHash(default, never):VarChar<1024>; // should be Char<1024>
  @:optional var passwordSalt(default, never):VarChar<40>; // should be Char<40>
  @:optional var passwordIterations(default, never):Integer<10>;
  @:unique @:optional var githubId(default, never):Integer<15>;
}