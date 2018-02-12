package lix.server.service.fs;

using tink.CoreApi;
using tink.io.Source;
using tink.io.Sink;
using StringTools;
using haxe.io.Path;

@:build(futurize.Futurize.build())
class S3 implements lix.server.service.Fs {
  
  var bucket:String;
  var s3:_S3;
  
  public function new(bucket) {
    this.bucket = bucket;
    #if (environment == "local") 
      var aws = js.Lib.require('aws-sdk');
      aws.config.credentials = untyped __js__('new {0}.SharedIniFileCredentials({profile: "lix"})', aws);
      aws.config.region = 'us-east-2';
    #end
    s3 = new _S3();
  }
  
  public function list(path:String):Promise<Array<String>> {
    var prefix = sanitize(path).addTrailingSlash();
    return @:futurize s3.listObjects({Bucket: bucket, Prefix: prefix}, $cb1)
      .next(function(o):Array<String> return [for(obj in o.data.Contents) obj.Key.substr(prefix.length)]);
  }
  
  public function exists(path:String):Promise<Bool>
    return @:futurize s3.headObject({Bucket: bucket, Key: sanitize(path)}, $cb1)
      .next(function(_) return true)
      .recover(function(_) return false);
  
  public function read(path:String):RealSource
    return new Error('not implemented');
  
  public function write(path:String):RealSink
    return new Error('not implemented');
  
  public function delete(path:String):Promise<Noise> {
    // TODO: delete folder
    return @:futurize s3.deleteObject({Bucket: bucket, Key: sanitize(path)}, $cb1);
  }
  
  public function getDownloadUrl(path:String):Promise<String>
    return @:futurize s3.getSignedUrl('getObject', {Bucket: bucket, Key: sanitize(path), Expires: 300}, $cb1);
  
  public function getUploadUrl(path:String):Promise<String>
    return @:futurize s3.getSignedUrl('putObject', {Bucket: bucket, Key: sanitize(path), Expires: 300}, $cb1);
  
  static function sanitize(path:String) {
    if(path.startsWith('/')) path = path.substr(1);
    return path;
  }
  
}

@:jsRequire('aws-sdk', 'S3')
extern class _S3 {
  function new(?options:{});
  function getSignedUrl(op:String, params:{}, cb:js.Error->String->Void):Void;
  function listObjects(params:{}, cb:js.Error->{data:{Contents:Array<{Key:String}>}}->Void):Void;
  function headObject(params:{}, cb:js.Error->Dynamic->Void):Void;
  function deleteObject(params:{}, cb:js.Error->Dynamic->Void):Void;
}