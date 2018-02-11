package lix.api;

@:tink
interface Root {
	@:sub
	function owners():OwnersApi;
	@:sub
	function users():UsersApi;
  
  #if (environment == "local")
  @:sub
  function files():FilesApi;
  #end
  
  @:get('/debug/db')
  function debugDb():Promise<String> return db.Owner.all().swap('Connected');
}