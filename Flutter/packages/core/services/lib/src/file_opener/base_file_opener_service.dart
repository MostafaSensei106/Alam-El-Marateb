/// Contract for opening remote files (PDFs, images, spreadsheets, etc.)
/// in an external application.
abstract interface class BaseFileOpenerService {
  /// Opens the file at [url] using an external viewer.
  ///
  /// The implementation decides whether to download first or delegate
  /// to the OS's URL handler.
  Future<void> openFile({required String url});
}
