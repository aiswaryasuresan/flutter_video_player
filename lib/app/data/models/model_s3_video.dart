class ModelS3Video {
  ModelS3Video({
    required this.id,
    required this.url,
    this.isDownloaded = false,
  });

  String id;
  String url;
  bool isDownloaded = false;
}
