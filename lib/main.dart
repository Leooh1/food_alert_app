import 'package:flutter/material.dart';
import 'package:food_alert_app/ask_school.dart';
import 'package:http/http.dart' as http;
import "dart:convert";
import 'package:intl/intl.dart';

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
  Map gupsickData = {'ㅇ': "초기화안됨"};

  @override
  void initState() {
    super.initState();
    fetchGupsick();
  }

  void fetchGupsick() async {
    String gupsickUrl = "http://61.254.83.178:9700";
    DateTime now = DateTime.now();
    String fromYmd = DateFormat("yyyyMMdd").format(now);
    String toYmd =
        DateFormat("yyyyMMdd").format(now.add(const Duration(days: 7)));
    var url = Uri.parse(gupsickUrl);
    var finalUrl = url.replace(queryParameters: {
      "Type": "json",
      "SD_SCHUL_CODE": "7130155",
      "ATPT_OFCDC_SC_CODE": "B10",
      "MLSV_FROM_YMD": fromYmd,
      "MLSV_TO_YMD": toYmd
    });
    var res = await http.get(finalUrl);
    setState(() {
      gupsickData = jsonDecode(utf8.decode(res.bodyBytes));
    });
  }

  @override
  Widget build(BuildContext context) {
    var mealInfo = gupsickData["mealServiceDietInfo"];
    var row =
        mealInfo != null && mealInfo.isNotEmpty ? mealInfo[1]["row"] : null;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AskSchool()));
              },
              icon: Icon(Icons.settings_rounded))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
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
                      if (mealInfo != null &&
                          mealInfo.isNotEmpty &&
                          mealInfo[1]["row"] != null)
                        Text(
                          "${mealInfo[1]["row"][0]["DDISH_NM"].replaceAll("<br/>", ", ")}",
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
            if (mealInfo != null &&
                mealInfo.isNotEmpty &&
                mealInfo[1]["row"] != null)
              Column(
                children: mealInfo[1]["row"].map<Widget>((a) {
                  return Text(
                      "${a["MLSV_YMD"]} : ${a["DDISH_NM"].replaceAll("<br/>", ", ")}");
                }).toList(),
              ),
            if (mealInfo == null || mealInfo.isEmpty)
              const Text("급식 정보를 불러오는데 실패했습니다."),
          ],
        ),
      ),
    );
  }
}
