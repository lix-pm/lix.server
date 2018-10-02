package lix.api;

import why.Fs;

interface VersionApi {
  var owner(default, null):OwnerName;
  var project(default, null):ProjectName;
  
  // @:post('/')
  // @:params(archive = body)
  // function submit(archive:tink.io.Source.RealSource):Promise<tink.Url>;
  
  @:get('/')
  public function download():Promise<UrlRequest>;
  
  @:put('/')
  @:restrict(user.hasRole(Project(this.owner, this.project), Publisher))
  public function upload():Promise<UrlRequest>;
}