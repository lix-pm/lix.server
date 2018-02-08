package lix.server.service.fs;

using tink.CoreApi;
using tink.io.Source;
using tink.io.Sink;

@:build(futurize.Futurize.build())
class S3 implements lix.server.service.Fs {
  
  var bucket:String;
  var s3:_S3;
  
  public function new(bucket) {
    this.bucket = bucket;
    s3 = new _S3();
  }
  
  public function exists(path:String):Promise<Bool>
    return @:futurize s3.headObject({Bucket: bucket, Key: path}, $cb1)
      .next(function(_) return true)
      .recover(function(_) return false);
  
	public function read(path:String):RealSource
    return new Error('not implemented');
  
	public function write(path:String):RealSink
    return new Error('not implemented');
  
	public function delete(path:String):Promise<Noise>
    return @:futurize s3.deleteObject({Bucket: bucket, Key: path}, $cb1);
  
	public function getDownloadUrl(path:String):Promise<String>
    return @:futurize s3.getSignedUrl('getObject', {Bucket: bucket, Key: path}, $cb1);
  
	public function getUploadUrl(path:String):Promise<String>
    return @:futurize s3.getSignedUrl('putObject', {Bucket: bucket, Key: path}, $cb1);
  
}

@:jsRequire('aws-sdk', 'S3')
extern class _S3 {
  function new(?options:{});
  function getSignedUrl(op:String, params:{}, cb:js.Error->String->Void):Void;
  function headObject(params:{}, cb:js.Error->Dynamic->Void):Void;
  function deleteObject(params:{}, cb:js.Error->Dynamic->Void):Void;
}