import "package:http/http.dart" as http;

class NoteReq {
  String api = "https://electricalnotesapi.herokuapp.com/note";

  void changeApi(String newApi) {
    api = newApi;
  }

  Future<http.Response> reqNote() async {
    return await http.get(Uri.parse(api));
  }
}
