import 'package:flutter/widgets.dart';

class Config {
  Config._();

  ///Odoo URLs
  static const String OdooDevURL = "http://192.168.20.186:10016/";
  static const String OdooProdURL = "http://192.168.20.186:10016/";
  static const String OdooUATURL = "http://192.168.20.186:10016/";

  /// SelfSignedCert:
  static const selfSignedCert = false;

  /// API Config
  static const timeout = 60000;
  static const logNetworkRequest = true;
  static const logNetworkRequestHeader = true;
  static const logNetworkRequestBody = true;
  static const logNetworkResponseHeader = false;
  static const logNetworkResponseBody = true;
  static const logNetworkError = true;

  /// Localization Config
  static const supportedLocales = <Locale>[Locale('en', ''), Locale('pt', '')];

  /// Common Const
  static const actionLocale = 'locale';
  static const int SIGNUP = 0;
  static const int SIGNIN = 1;
  static const String CURRENCY_SYMBOL = "€";
  static String FCM_TOKEN = "";
  static String DB = "";
}
