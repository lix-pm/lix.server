package lix.server;

import haxe.DynamicAccess;
import lix.server.db.*;
import js.aws.cognitoidentityserviceprovider.*;

using tink.CoreApi;

/**
 * Pre Token Generation hook for Cognito
 * 
 * Check if the cognito user contains the "custom:lix_userid" attribute.
 * If not, look for (or create) the cognito user in lix database
 * and add the lix user id as "custom:lix_userid" attribute in Cognito
 */
@:build(futurize.Futurize.build())
class PreToken {
  @:expose('index') @:keep
  static function index(event:Event, ctx, cb) {
    trace(haxe.Json.stringify(event, '  '));
    var attr = event.request.userAttributes;
    ctx.callbackWaitsForEmptyEventLoop = false;
    if(!attr.exists('custom:lix_userid')) {
      var db = Db.get();
      var cognitoId:String = attr['sub'];
      
      function saveLixUserIdIntoCognito(id:Int) {
        var cognito = new CognitoIdentityServiceProvider();
        return @:futurize cognito.adminUpdateUserAttributes({
          UserAttributes: [{
            Name: 'custom:lix_userid',
            Value: Std.string(id),
          }],
          UserPoolId: event.userPoolId,
          Username: event.userName,
        }, $cb1).swap(id);
      }
      
      db.User.where(User.cognitoId == cognitoId).first()
        .flatMap(o -> switch o {
          case Success(user):
            saveLixUserIdIntoCognito(user.id);
          case Failure(e) if(e.code == NotFound):
            db.User.insertOne({
              id: null,
              cognitoId: cognitoId,
              username: null,
              nickname: null,
            }).next(saveLixUserIdIntoCognito);
          case Failure(e):
            Future.sync(Failure(e));
        })
        .handle(function(o:Outcome<Int, Error>) switch o {
          case Success(id): 
            event.response = {
              claimsOverrideDetails: {
                claimsToAddOrOverride: {
                  'custom:lix_userid': Std.string(id),
                },
                claimsToSuppress: [],
                groupOverrideDetails: event.request.groupConfiguration,
              }
            }
            cb(null, event);
          case Failure(e):
            trace(e.message);
            trace(e.data);
            trace('Pool ID: ${event.userPoolId}');
            cb(e, null);
        });
    } else {
      cb(null, event);
    }
  }
}

private typedef Event = {
  userPoolId:String,
  userName:String,
  request:{
    userAttributes:DynamicAccess<String>,
    groupConfiguration:Dynamic,
  },
  response:Dynamic,
}