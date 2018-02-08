package lix.server.api;

using tink.io.Source;

class FilesApi extends BaseApi implements lix.api.FilesApi {
  
  public function new() {} 
  
  public function upload(path:String, content:tink.io.Source.RealSource):Promise<{}> {
    return content.pipeTo(fs.write(path))
      .next(function(o) return switch o {
        case AllWritten: Promise.lift({});
        case SourceFailed(e) | SinkFailed(e, _): e;
        case SinkEnded(_): new Error('Sink ended unexpectedly');
      });
  }
    
  public function download(path:String):Promise<OutgoingResponse> {
    return new OutgoingResponse(
      new ResponseHeader(200, 'OK', []),
      fs.read(path).idealize(function(e) {
        trace(e);
        return Source.EMPTY;
      })
    );
  }
}