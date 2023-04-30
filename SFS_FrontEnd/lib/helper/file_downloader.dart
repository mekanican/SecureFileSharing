import 'package:dio/dio.dart';


Future<void> downloadFile(String url, String savePath) async {
  // Create a Dio instance
  var dio = Dio();
  print(savePath);

  // Start the download
  try {
    await dio.download(url, savePath);
    print('Download complete!');
  } catch (e) {
    print('Error downloading file: $e');
  }
}
