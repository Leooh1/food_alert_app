import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "dart:convert";

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Home());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = "오채승파산";
  String gupsickUrl = "https://open.neis.go.kr/hub/mealServiceDietInfo";
  Map gupsickData = {'ㅇ': "초기화안됨"};
  @override
  void initState() {
    super.initState();
    fetchGupsick();
  }

  void fetchGupsick() async {
    String gupsickUrl = "https://open.neis.go.kr/hub/mealServiceDietInfo";

    String apiKey = "ce7a974d58d14584ab0d35adcf0fe682";

    var url = Uri.parse(gupsickUrl);
    var finalUrl = url.replace(queryParameters: {
      "KEY": apiKey,
      "Type": "json",
      "SD_SCHUL_CODE": "7130155",
      "ATPT_OFCDC_SC_CODE": "B10",
      "MLSV_YMD": "20241211"
    });
    print(finalUrl.toString());
    var res = await http.get(finalUrl);
    setState(() {
      gupsickData = jsonDecode(res.body); // JsonDecoder 대신 jsonDecode 사용
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jsonEncode(gupsickData),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        '오Te파산',
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        '오Te파산',
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        '오Te파산',
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Image.network(
                  "https://ichef.bbci.co.uk/ace/standard/976/cpsprodpb/16620/production/_91408619_55df76d5-2245-41c1-8031-07a4da3f313f.jpg.webp",
                  width: 100,
                )
              ],
            ),
            Row(
              children: [
                Column(),
                Column(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
