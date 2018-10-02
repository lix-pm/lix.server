package lix.server.api;

import lix.util.Config.*;
import lix.server.db.*;
import tink.http.Method;
import why.Fs;
import why.fs.*;


class BaseApi {
  
  public function new() {}
  
  var fs:Fs =
    #if (environment == "prod")
      new S3('lix-production')
    #else
      new Local({
        root: './storage',
        getDownloadUrl: path -> {
          url: '$API_SERVER_URL/files?path=$path',
          method: GET,
        },
        getUploadUrl: (path, _) -> {
          url: '$API_SERVER_URL/files?path=$path',
          method: PUT,
        },
      })
    #end ;
  var db = Db.get();
  
  function path(?owner:OwnerName, ?project:ProjectName, ?version:String) {
    var path = '/libraries';
    if(owner != null) {
      path += '/$owner';
      if(project != null) {
        path += '/$project';
        if(version != null)
          path += '/$version';
      }
    }
    return path;
  }
}