package lix.api;

import why.Fs;

interface VersionApi {
  @:get('/archive')
  function download():Promise<UrlRequest>;
  
  @:put('/archive')
  @:restrict(this.canUpload(user))
  function upload():Promise<UrlRequest>;
  
  @:put
  @:restrict(this.canDeprecate(user))
  @:params(message in body)
  function deprecate(message:String):Promise<Noise>;
  
  
  function canUpload(user:AuthUser):Promise<Bool>;
  function canDeprecate(user:AuthUser):Promise<Bool>;
}