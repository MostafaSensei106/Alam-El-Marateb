/// Contract for downloading and opening order attachments in‑app.
///
/// Images are displayed full‑screen; non‑image files (PDFs, etc.) are
/// downloaded to the device's local storage and optionally opened with
/// an external viewer.
abstract interface class BaseAttachmentHandlerService {
  /// Resolves a (possibly relative) attachment [url] to a full URL using
  /// the API base.
  String resolveFullUrl(String url);

  /// Downloads the remote file at [url] to the device and returns the
  /// local path on success.
  ///
  /// [onProgress] reports download progress as a 0‥1 fraction.
  Future<String> downloadFile({
    required String url,
    required String fileName,
    void Function(double progress)? onProgress,
  });
}
