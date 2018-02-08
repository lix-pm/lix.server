package lix.server.api;

class VersionApi extends BaseApi implements lix.api.VersionApi {
  var owner:OwnerName;
  var project:ProjectName;
  var version:String;
  var path:String;
  
  public function new(owner, project, version) {
    this.owner = owner;
    this.project = project;
    this.version = version;
    this.path = '/libraries/$owner/$project/$version';
  }

  public function submit(archive:tink.io.Source.RealSource):Promise<{}> {
    return archive.pipeTo(fs.write('$path/archive.zip'))
      .next(function(o) return switch o {
        case AllWritten: Promise.lift({});
        case SourceFailed(e) | SinkFailed(e, _): e;
        case SinkEnded(_): new Error('Sink ended unexpectedly');
      });
  }
  
  public function download():Promise<OutgoingResponse>
    return new Error('Not Implemented');
}