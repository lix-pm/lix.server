package lix.server.api;

import lix.api.OAuthApi;
import lix.util.Config.*;
import tink.http.Fetch.fetch;

class OAuthApi extends BaseApi implements lix.api.OAuthApi {
  
  static var COGNITO_CLIENT_SECRET = Sys.getEnv('COGNITO_CLIENT_SECRET');
  
  public function authorize(?state:String):tink.Url {
    return 'https://lix.auth.us-east-2.amazoncognito.com/oauth2/authorize?' + 
      tink.QueryString.build({
        response_type: 'code',
        client_id: COGNITO_CLIENT_ID,
        state: state,
        redirect_uri: '$API_SERVER_URL/oauth2/callback',
      });
  }
  
  public function callback(code:String, ?state:String, ?action:String):Promise<OutgoingResponse> {
    trace(action);
    return fetch('https://lix.auth.us-east-2.amazoncognito.com/oauth2/token', {
      method: POST,
      headers: [
        new HeaderField(AUTHORIZATION, HeaderValue.basicAuth(COGNITO_CLIENT_ID, COGNITO_CLIENT_SECRET)),
        new HeaderField(CONTENT_TYPE, 'application/x-www-form-urlencoded'),
        new HeaderField(ACCEPT, 'application/json')
      ],
      body: tink.QueryString.build({
        grant_type: 'authorization_code',
        client_id: COGNITO_CLIENT_ID,
        redirect_uri: '$API_SERVER_URL/oauth2/callback',
        code: code,
      })
    }).all()
      .next(res -> tink.Json.parse((res.body:TokenResponse)))
      // .next(token -> getUserInfo(token.access_token).swap(token))
      .next(token -> new Error('TODO'));
  }
  
  static function redirect(action:OAuthAction, query:String) {
    return new OutgoingResponse(
      new ResponseHeader(302, 'Found', [new HeaderField(LOCATION, '$SITE_URL/$action?$query')]),
      tink.io.Source.EMPTY
    );
  }
  
  static function getUserInfo(accessToken:String) {
    return fetch('https://lix.auth.us-east-2.amazoncognito.com/oauth2/userInfo', { 
        headers: [new HeaderField(AUTHORIZATION, 'Bearer $accessToken')],
    }).all().next(res -> tink.Json.parse((res.body:UserInfo)));
  }
  
  static function randomString()
    return haxe.crypto.Sha1.encode('${Date.now().getTime()}${Math.random()}');
    
}

private typedef TokenResponse = {
  access_token:String,
  refresh_token:String,
  token_type:String,
  id_token:String,
  expires_in:Int,
}

private typedef UserInfo = {
  sub:String,
  website:String,
  email_verified:String,
  updated_at:String,
  profile:String,
  name:String,
  email:String,
  picture:String,
  username:String,
}