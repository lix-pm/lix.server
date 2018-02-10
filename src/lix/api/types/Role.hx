package lix.api.types;


private typedef Impl = #if tink_sql tink.sql.Types.VarChar<255> #else String #end;

@:enum abstract Role(Impl) to String {
  var Owner = 'owner';
  var Admin = 'admin';
  var Publisher = 'publisher';
}