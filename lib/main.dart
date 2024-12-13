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
        DateFormat("yyyyMMdd").format(now.add(const Duration(days: 90)));
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

    var navBarColor = Color.fromRGBO(69, 165, 255, 1);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: navBarColor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AskSchool()));
              },
              icon: Icon(Icons.settings_rounded))
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              color: navBarColor,
              padding: EdgeInsets.only(top: 30, bottom: 30),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
            if (mealInfo != null &&
                mealInfo.isNotEmpty &&
                mealInfo[1]["row"] != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: mealInfo[1]["row"].sublist(1).map<Widget>((a) {
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromRGBO(0, 0, 0, 0.1)),
                          margin: EdgeInsets.only(bottom: 8),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${a["MLSV_YMD"].substring(4, 6)}월 ${a["MLSV_YMD"].substring(6, 8)}일\n",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("${a["DDISH_NM"].replaceAll("<br/>", ", ")}")
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            if (mealInfo == null || mealInfo.isEmpty)
              const Text("급식 정보를 불러오는데 실패했습니다."),
          ],
        ),
      ),
    );
  }
}
