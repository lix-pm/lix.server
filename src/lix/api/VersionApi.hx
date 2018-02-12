package lix.api;

interface VersionApi {
  // @:post('/')
  // @:params(archive = body)
  // function submit(archive:tink.io.Source.RealSource):Promise<tink.Url>;
  
  @:get
  @:params(upload in query)
  public function url(?upload:Bool):Promise<{url:String}>;
  
  @:get('/')
  public function download():Promise<OutgoingResponse>;
  
  @:put('/')
  public function upload():Promise<OutgoingResponse>;
}