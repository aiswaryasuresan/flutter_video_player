import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_video_player/app/common/storage/storage.dart';
import 'package:flutter_video_player/app/common/utils/constants.dart';
import 'package:flutter_video_player/app/data/models/model_s3_video.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class VideoStorage {
  static Future<void> downloadAndEncryptVideo(ModelS3Video video) async {
    print("Starting download video : ${video.url}");
    final urlMd5 = _getUrlMd5(video.url);
    if (Storage.hasData(urlMd5)) {
      return;
    }
    try {
      var response = await http.get(Uri.parse(video.url));
      if (response.statusCode == 200) {
        Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
        String extension = video.url.split('.').last;
        String videoFilePath = '${appDocumentsDirectory.path}/temp_$urlMd5.$extension';
        print("Video File url: $videoFilePath");
        File videoFile = File(videoFilePath);
        final videoBytes = response.bodyBytes;
        await videoFile.writeAsBytes(videoBytes);
        final encryptedFilePath = '${appDocumentsDirectory.path}/$urlMd5.$extension';

        print("Video encryptedFilePath: $encryptedFilePath");
        final videoString = String.fromCharCodes(videoBytes);
        final key = encrypt.Key.fromUtf8(Constants.videoEncryptionKey);
        final iv = encrypt.IV.fromLength(16);
        final encrypter = encrypt.Encrypter(encrypt.AES(key));
        final encryptedVideoBytes = encrypter.encrypt(videoString, iv: iv);

        File encryptedVideoFile = File(encryptedFilePath);
        await encryptedVideoFile.writeAsBytes(encryptedVideoBytes.bytes);
        Storage.saveValueForce(urlMd5, encryptedFilePath);
        print('Video downloaded, encrypted, and stored successfully.');
      } else {
        print('Failed to download video. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Got error while downloading video : $e}");
    }
  }

  static Future<File?> getLocalVideo(ModelS3Video video) async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String extension = video.url.split('.').last;
    final urlMd5 = _getUrlMd5(video.url);
    if (Storage.hasData(urlMd5)) {
      String videoFilePath = '${appDocumentsDirectory.path}/temp_$urlMd5.$extension';
      String encryptedVideoFilePath = '${appDocumentsDirectory.path}/$urlMd5.$extension';
      File tempFile = File(videoFilePath);
      if (await tempFile.exists()) {
        return tempFile;
      }
      return await decryptAndSaveTemporary(encryptedVideoFilePath);
    }
    return null;
  }

  static Future<bool> isDownloaded(String videoUrl) async {
    String md5Val = _getUrlMd5(videoUrl);
    return Storage.hasData(md5Val);
  }

  static _getUrlMd5(String url) {
    var videoUrlBytes = utf8.encode(url);
    return md5.convert(videoUrlBytes).toString();
  }

  static Future<File?> decryptAndSaveTemporary(String encryptedFilePath) async {
    try {
      final encryptedFile = File(encryptedFilePath);
      if (!await encryptedFile.exists()) {
        print('Encrypted file does not exist.');
      } else {
        final encryptedBytes = await encryptedFile.readAsBytes();
        final key = encrypt.Key.fromUtf8(Constants.videoEncryptionKey);
        final iv = encrypt.IV.fromLength(16);
        final encrypter = encrypt.Encrypter(encrypt.AES(key));
        final decryptedBytes = encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: iv);

        final originalFileName = path.basename(encryptedFilePath);

        final appDocumentsDirectory = await getApplicationDocumentsDirectory();
        final tempFilePath = '${appDocumentsDirectory.path}/temp_$originalFileName';

        final tempFile = File(tempFilePath);
        await tempFile.writeAsBytes(decryptedBytes);

        print('File decrypted and saved as: $tempFilePath');
        return tempFile;
      }
    } catch (e) {
      print("Error decrypting file: $e");
    }
    return null;
  }

  void deleteTempFiles() async {
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    if (!appDocumentsDirectory.existsSync()) {
      print('Directory does not exist.');
      return;
    }

    appDocumentsDirectory.listSync().forEach((entity) {
      if (entity is File && entity.path.split('/').last.startsWith('temp_')) {
        entity.deleteSync();
        print('Deleted: ${entity.path}');
      }
    });
  }
}
