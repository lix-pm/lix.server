package lix.api;

import why.Fs;

interface VersionApi {
  // @:post('/')
  // @:params(archive = body)
  // function submit(archive:tink.io.Source.RealSource):Promise<tink.Url>;
  
  @:get('/')
  public function download():Promise<UrlRequest>;
  
  @:put('/')
  @:restrict(this.canUpload(user))
  public function upload():Promise<UrlRequest>;
  
  function canUpload(user:AuthUser):Promise<Bool>;
}