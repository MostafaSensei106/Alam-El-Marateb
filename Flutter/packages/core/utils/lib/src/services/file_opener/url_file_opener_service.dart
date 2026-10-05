import 'package:injectable/injectable.dart';

import '../url_launcher/base_url_launcher_services.dart';
import 'base_file_opener_service.dart';

@Injectable(as: BaseFileOpenerService)
final class UrlFileOpenerService implements BaseFileOpenerService {
  const UrlFileOpenerService(this._urlLauncher);

  final BaseUrlLauncherServices _urlLauncher;

  @override
  Future<void> openFile({required String url}) async {
    await _urlLauncher.launchWebsite(url: url);
  }
}
