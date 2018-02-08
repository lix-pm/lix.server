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
		
	public function read(path:String):RealSource
		return getFullPath(path).readStream();
	
	public function write(path:String):RealSink {
    var path = getFullPath(path);
    var folder = path.directory();
    return folder.exists().next(function(e) return e ? Noise : folder.createDirectory())
      .next(function(_) return path.writeStream());
  }
	
	public function delete(path:String):Promise<Noise>
		return getFullPath(path).deleteFile();
	
	public function publicUrl(path:String):Promise<String>
		return new Error('not implemented');
	
  inline function getFullPath(path:String)
    return '$root/$path';
}