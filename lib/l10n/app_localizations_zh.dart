// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get hello => '你好';

  @override
  String get welcome => '歡迎！';

  @override
  String get personalinfo => '個人資訊';

  @override
  String get logout => '登出';

  @override
  String get deleteaccount => '刪除帳號';

  @override
  String get sure => '確定';

  @override
  String get cancel => '取消';
}
