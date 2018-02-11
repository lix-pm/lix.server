package lix.api.types;

@:enum abstract OAuthAction(String) to String {
  var Login = 'login';
  var Register = 'register';
}