package lix.server.service.fs;

using asys.io.File;
using asys.FileSystem;
using tink.CoreApi;
using tink.io.Sink;
using tink.io.Source;
using haxe.io.Path;

class Local implements lix.server.service.Fs {
	
	var root:String;
	
	public function new(root:String)
		this.root = root.removeTrailingSlashes();
		
  public function exists(path:String):Promise<Bool>
    return getFullPath(path).exists();
    
	public function read(path:String):RealSource
		return getFullPath(path).readStream();
	
	public function write(path:String):RealSink {
    path = getFullPath(path);
    var folder = path.directory();
    return folder.exists().next(function(e) return e ? Noise : folder.createDirectory())
      .next(function(_) return path.writeStream());
  }
	
	public function delete(path:String):Promise<Noise> {
    path = getFullPath(path);
    return path.exists().next(function(e) return !e ? Noise : path.deleteFile());
  }
	
	public function getDownloadUrl(path:String):Promise<String>
		return 'http://localhost:1234/files?path=$path';
    
	public function getUploadUrl(path:String):Promise<String>
		return 'http://localhost:1234/files?path=$path';
	
  inline function getFullPath(path:String)
    return '$root/$path';
}