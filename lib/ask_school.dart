import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AskSchool extends StatefulWidget {
  const AskSchool({super.key});

  @override
  State<AskSchool> createState() => _AskSchoolState();
}

class _AskSchoolState extends State<AskSchool> {
  var textController_school = TextEditingController();
  String schoolName = "";
  void fetchGupsick() async {
    String baseUrl = "http://61.254.83.178:9700";
    DateTime now = DateTime.now();
    var url = Uri.parse(baseUrl);
    var finalUrl = url.replace(queryParameters: {
      "Type": "json",
      "SCHUL_NM": schoolName
    });
    var res = await http.get(finalUrl);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("님학교뭐야정확히입력해안그러면큰일남"),
            TextField(
              controller: textController_school,
              decoration: InputDecoration(hintText: "안녕"),
              onChanged: (v){
                setState(() {
                  schoolName = v;
                });
              },
            ),
            OutlinedButton(onPressed: (){}, child: Text("검색"))
          ],
        ),
      )),
    );
  }
}
