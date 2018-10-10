package lix.util;

import lix.util.Config.*;
import tink.http.Client.*;
import tink.http.Header;
import tink.Chunk;

using tink.CoreApi;

class OAuthHelper {
  static var COGNITO_CLIENT_SECRET = Sys.getEnv('COGNITO_CLIENT_SECRET');
  
  public static function authorize(?state:String, type:ResponseType, redirect:String):tink.Url {
    return 'https://login.lix.pm/oauth2/authorize?' + 
      tink.QueryString.build({
        response_type: type,
        client_id: COGNITO_CLIENT_ID,
        state: state,
        redirect_uri: redirect,
      });
  }
  
  public static function callback(code:String, redirect:String, ?state:String):Promise<TokenResponse> {
    return fetch('https://login.lix.pm/oauth2/token', {
      method: POST,
      headers: [
        new HeaderField(AUTHORIZATION, HeaderValue.basicAuth(COGNITO_CLIENT_ID, COGNITO_CLIENT_SECRET)),
        new HeaderField(CONTENT_TYPE, 'application/x-www-form-urlencoded'),
        new HeaderField(ACCEPT, 'application/json'),
      ],
      body: tink.QueryString.build({
        grant_type: 'authorization_code',
        client_id: COGNITO_CLIENT_ID,
        redirect_uri: redirect,
        code: code,
      }),
    }).all()
      .next(res -> tink.Json.parse((res.body:TokenResponse)));
  }
  
  public static function getUserInfo(accessToken:String) {
    return fetch('https://login.lix.pm/oauth2/userInfo', { 
        headers: [new HeaderField(AUTHORIZATION, 'Bearer $accessToken')],
    }).all().next(res -> tink.Json.parse((res.body:UserInfo)));
  }
}

typedef TokenResponse = {
  access_token:String,
  ?refresh_token:String,
  token_type:String,
  id_token:String,
  expires_in:Int,
}

typedef UserInfo = {
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

@:enum
abstract ResponseType(String) to String {
  var ImplicitCodeGrant = 'token';
  var AuthorizationCodeGrant = 'code';
}