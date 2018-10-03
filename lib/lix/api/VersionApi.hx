package lix.api;

import why.Fs;

interface VersionApi {
  @:get('/archive')
  public function download():Promise<UrlRequest>;
  
  @:put('/archive')
  @:restrict(this.canUpload(user))
  public function upload():Promise<UrlRequest>;
  
  function canUpload(user:AuthUser):Promise<Bool>;
}