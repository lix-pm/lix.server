package lix.server.auth;

import lix.server.db.*;
import lix.server.util.*;
import tink.http.Request;

using tink.CoreApi;

class Session {
  var header:IncomingRequestHeader;
  var db = Db.get();
  
  public function new(header)
    this.header = header;
    
  public function getUser():Promise<Option<AuthUser>> {
    return switch header.getAuth() {
      case Success(Bearer(token)):
        new Error(BadRequest, 'Bearer authorization is not supported');
      case Success(Basic(username, password)):
        db.User.where(User.username == username).first()
          .next(function(user) {
            return
              if(user.passwordHash == null)
                new Error(Unauthorized, 'Password login is not enabled')
              else
                Password.encrypt(password, user.passwordSalt, user.passwordIterations)
                  .next(function(hash) {
                    return
                      if(user.passwordHash == hash) Some(new AuthUser(user.id, user))
                      else new Error(Unauthorized, 'Incorrect password');
                  });
          });
      case Success(Others(scheme, params)): 
        new Error(BadRequest, 'Unsupported authorization header "$scheme $params"');
      case Failure(_):
        new Error(BadRequest, 'Authorization header is not present');
    }
  }
  
}