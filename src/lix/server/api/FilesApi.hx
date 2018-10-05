package lix.server.api;

using tink.io.Source;

class FilesApi extends BaseApi {
  
  @:put('/')
  @:params(path in query)
  @:params(content = body)
  public function upload(path:String, content:tink.io.Source.RealSource):Promise<{}> {
    return content.pipeTo(fs.write(path))
      .next(o -> switch o {
        case AllWritten: Promise.lift({});
        case SourceFailed(e) | SinkFailed(e, _): e;
        case SinkEnded(_): new Error('Sink ended unexpectedly');
      });
  }
  
  @:get('/')
  @:params(path in query)
  public function download(path:String):Promise<OutgoingResponse> {
    return new OutgoingResponse(
      new ResponseHeader(200, 'OK', [new HeaderField(CONTENT_TYPE, 'application/zip')]),
      fs.read(path).idealize(e -> {
        trace(e);
        Source.EMPTY;
      })
    );
  }
}