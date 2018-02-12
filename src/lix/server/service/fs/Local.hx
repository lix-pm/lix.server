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
    
  public function list(path:String):Promise<Array<String>> {
    return Future.async(function(cb) {
      var fullpath = getFullPath(path).addTrailingSlash();
      var ret = [];
      var working = 0;
      function read(f:String) {
        working ++;
        return 
          f.readDirectory()
            .handle(function(o) switch o {
              case Success(items):
                for(item in items) {
                  var path = f.addTrailingSlash() + item;
                  item.isDirectory()
                    .handle(function(isDir) if(isDir) read(path.addTrailingSlash()) else ret.push(path));
                }
                if(--working == 0)
                  cb(Success([for(item in ret) item.substr(fullpath.length)]));
                  
              case Failure(e):
                cb(Failure(e));
            });
      }
      read(fullpath);
    });
  }
    
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
    return Future.async(function(cb) {
      var fullpath = getFullPath(path).addTrailingSlash();
      var ret = [];
      var working = 0;
      
      function done() if(--working == 0) cb(Success(Noise));
      function fail(e) cb(Failure(e));
      
      var rm:String->Void;
      
      function rmfile(f:String) {
        working++;
        f.deleteFile().handle(function(o) switch o {
          case Success(_): done();
          case Failure(e): fail(e);
        });
      }
      
      function rmdir(f:String) {
        working ++;
        return 
          f.readDirectory()
            .handle(function(o) switch o {
              case Success(items):
                for(item in items) rm(f.addTrailingSlash() + item);
                done();
              case Failure(e):
                cb(Failure(e));
            });
      }
      
      rm = function(f:String) {
        working++;
        f.isDirectory().handle(function(isDir) {
          working--;
          if(isDir) rmdir(f.addTrailingSlash()) else rmfile(f);
        });
      }
      
      rm(fullpath);
    });
  }
  
  public function getDownloadUrl(path:String):Promise<String>
    return 'http://localhost:1234/files?path=$path';
    
  public function getUploadUrl(path:String):Promise<String>
    return 'http://localhost:1234/files?path=$path';
  
  inline function getFullPath(path:String)
    return '$root/$path'.normalize();
}