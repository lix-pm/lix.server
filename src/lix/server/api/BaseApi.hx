package lix.server.api;

import lix.server.service.*;
import lix.server.service.fs.*;
import lix.server.db.*;


class BaseApi {
  
  public function new() {}
  
  var fs:Fs = #if (environment == "production") new S3('lix-production') #else new Local('./storage') #end ;
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