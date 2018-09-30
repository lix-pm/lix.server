package lix.api;

interface OAuthApi {
  @:get('/authorize')
  @:params(state in query)
  function authorize(?state:String):tink.Url;
  
  @:get('/callback')
  @:params(code in query, state in query, action in query)
  function callback(code:String, ?state:String, ?action:String):Promise<OutgoingResponse>;
}
