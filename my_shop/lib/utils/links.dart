class Links{
  static const databaseUrl = 'https://my-shop-82dad.firebaseio.com';
  static const webAPIKey = 'AIzaSyDUGFwGu77GTxQZMebz7PGpLkMoZoV7kr8';
  static const baseAuthUrl = 'https://identitytoolkit.googleapis.com/v1/accounts';
  static const signUpUrl = '$baseAuthUrl:signUp?key=$webAPIKey';
  static const signInUrl = '$baseAuthUrl:signInWithPassword?key=$webAPIKey';

}