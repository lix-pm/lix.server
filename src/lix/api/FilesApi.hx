package lix.api;

interface FilesApi {
  @:put('/')
  @:params(path in query)
  @:params(content = body)
  function upload(path:String, content:tink.io.Source.RealSource):Promise<{}>;
  
  @:get('/')
  @:params(path in query)
  function download(path:String):Promise<OutgoingResponse>;
}