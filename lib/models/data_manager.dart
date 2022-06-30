// import "package:path_provider/path_provider.dart";
import "package:share_plus/share_plus.dart";
// import "dart:io";

// TODO: MAKE API FOR SAVING DATA

class DataManager {
  // Future<String> getDirectory() async {
  //   Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  //   String filePath = "${appDocumentsDirectory.path}/electricdata.json";
  //   return filePath;
  // }

  // void saveFile(String data) async {
  //   File file = File(await getDirectory());
  //   file.writeAsStringSync(data);
  // }

  // Future<String> readFile() async {
  //   File file = File(await getDirectory());
  //   String fileContent = file.readAsStringSync();
  //   return fileContent;
  // }

  // void shareFile() async {
  //   Share.shareFiles([await getDirectory()]);
  // }

  void shareText(String str) {
    Share.share(str);
  }
}
