import 'package:package_info_plus/package_info_plus.dart';

/// Versão da aplicação no formato da tag (v1.2.3 ou v1.2.3-4), montada a partir
/// do `version` do pubspec.yaml (1.2.3+0 ou 1.2.3+4), que é atualizado pelo
/// workflow de release.
Future<String> loadAppVersion() async {
  final info = await PackageInfo.fromPlatform();
  final build = info.buildNumber;
  if (build.isEmpty || build == '0') return 'v${info.version}';
  return 'v${info.version}-$build';
}
