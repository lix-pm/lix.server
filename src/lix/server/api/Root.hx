package lix.server.api;

class Root implements lix.api.Root {
	public function new() {}
	public function projects() return new ProjectsApi();
}