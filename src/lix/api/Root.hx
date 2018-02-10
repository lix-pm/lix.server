package lix.api;

interface Root {
	@:sub
	function owners():OwnersApi;
	@:sub
	function users():UsersApi;
  
  #if (environment == "local")
  @:sub
  function files():FilesApi;
  #end
}