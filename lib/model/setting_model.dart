import 'package:Wandering/local_environment.dart';

class SettingModel {
  double? fontSize;
  String? theme;
  String? language;
  String? region;
  String? currency;
  String? timeZone;

  SettingModel({
    this.fontSize,
    this.theme,
    this.language,
    this.region,
    this.currency,
    this.timeZone,
  });

  Map<String, dynamic> toMap() {
    return {
      'fontSize': fontSize,
      'theme': theme,
      'language': language,
      'region': region,
      'currency': currency,
      'timeZone': timeZone,
    };
  }

  factory SettingModel.fromMap(Map<String, dynamic> map) {
    return SettingModel(
      fontSize: map['fontSize'],
      theme: map['theme'],
      language: map['language'],
      region: map['region'],
      currency: map['currency'],
      timeZone: map['timeZone'],
    );
  }
}
