package lix.api;

interface VersionApi {
  var owner(default, null):OwnerName;
  var project(default, null):ProjectName;
  
  // @:post('/')
  // @:params(archive = body)
  // function submit(archive:tink.io.Source.RealSource):Promise<tink.Url>;
  
  
  @:get
  @:params(upload in query)
  @:restrict(upload ? user.hasRole(Project(this.owner, this.project), Publisher) : true)
  public function url(?upload:Bool):Promise<{url:String}>;
  
  @:get('/')
  public function download():Promise<OutgoingResponse>;
  
  @:put('/')
  @:restrict(user.hasRole(Project(this.owner, this.project), Publisher))
  public function upload():Promise<OutgoingResponse>;
}