// import 'dart:io';
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:flutter/services.dart' show rootBundle;

// Future<String> loadServiceAccountJson() async {
//   return await rootBundle.loadString('assets/api_key.json');
// }

// Future<AutoRefreshingAuthClient> getAuthClientFromServiceAccount() async {
//   final serviceAccountJson = await loadServiceAccountJson();
//   final accountCredentials = ServiceAccountCredentials.fromJson(
//     serviceAccountJson,
//   );

//   final scopes = ['https://www.googleapis.com/auth/cloud-platform'];

//   return await clientViaServiceAccount(accountCredentials, scopes);
// }
