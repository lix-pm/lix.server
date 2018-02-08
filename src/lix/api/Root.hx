package lix.api;

interface Root {
	@:sub
	function owners():OwnersApi;
  
  #if (environment == "local")
  @:sub
  function files():FilesApi;
  #end
}