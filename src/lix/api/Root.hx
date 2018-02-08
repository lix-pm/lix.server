package lix.api;

interface Root {
	@:sub
	function projects():ProjectsApi;
}