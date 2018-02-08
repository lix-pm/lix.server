package lix.api;

interface VersionApi {
  @:post('/')
  @:params(archive = body)
  function submit(archive:tink.io.Source.RealSource):Promise<{}>;
	
  @:get('/')
  function download():Promise<OutgoingResponse>;
}