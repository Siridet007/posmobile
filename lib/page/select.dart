import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pos_mobile/model/model.dart';
import 'package:pos_mobile/page/firstpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class SelectPage extends StatefulWidget {
  final String? username;
  const SelectPage({super.key, this.username});

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  double? width;
  double? height;
  SharedPreferences? sharedPreferences;
  List<GetShopTrolley>? trolleyList = [];

  Future removePass() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences!.remove('password');
  }

  Future getShare() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<List<GetShopTrolley>?> getTrolley() async {
    String domain2 =
        "http://172.2.100.14/application/query_pos_trolley/fluttercon.php?mode=get_shop_trolley";

    String urlAPI = domain2;

    Response response = await Dio().post(urlAPI);
    //print(response.data);
    var result = GetShopTrolley.fromJsonList(response.data);
    return result;
  }

  Future exitFuture(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                  color: const Color.fromRGBO(237, 0, 140, 1),
                ),
                child: const Icon(
                  Icons.question_mark,
                  color: Colors.white,
                ),
              ),
              const Text(
                '  Confirm',
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
          content: const Text(
            'ต้องการออกจากระบบใช่หรือไม่',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            Container(
              width: 70,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(237, 0, 140, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  removePass();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                child: const Text(
                  'YES',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              width: 70,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(237, 0, 140, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'NO',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  @override
  void initState() {
    super.initState();
    getShare();
    getTrolley().then((value) {
      setState(() {
        trolleyList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {        
        return await exitFuture(context);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromRGBO(237, 0, 140, 1),
          centerTitle: true,
          title: const Text('POS Mobile'),
          actions: [
            IconButton(
              onPressed: () {
                exitFuture(context);
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: Container(
          width: width,
          height: height,
          color: Colors.pink[50],
          child: trolleyList!.isEmpty
              ? Center(
                  child: LoadingAnimationWidget.bouncingBall(
                    color: Colors.pink,
                    size: 100,
                  ),
                )
              : GridView.count(
                  childAspectRatio: 0.7,
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    Container(
                      color: Colors.pink[100],
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FirstPage(
                                    username: widget.username,
                                    taxid: trolleyList![0].taxid,
                                    shopchar: trolleyList![0].shopchar,
                                    shopid: trolleyList![0].idshop),
                              ),
                            );
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AspectRatio(
                              aspectRatio: 1.0,
                              child: Container(
                                decoration: const BoxDecoration(),
                                child: Image.asset(
                                  'assets/images/trolley1.png',
                                ),
                              ),
                            ),
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 2.0,
                                child: Center(
                                  child: Text(
                                    '${trolleyList![0].shopname}',
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.pink[100],
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FirstPage(
                                    username: widget.username,
                                    taxid: trolleyList![1].taxid,
                                    shopchar: trolleyList![1].shopchar,
                                    shopid: trolleyList![1].idshop),
                              ),
                            );
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AspectRatio(
                              aspectRatio: 1.0,
                              child: Container(
                                decoration: const BoxDecoration(),
                                child: Image.asset(
                                  'assets/images/trolley2.png',
                                  scale: 1.5,
                                ),
                              ),
                            ),
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 2.0,
                                child: Center(
                                  child: Text(
                                    '${trolleyList![1].shopname}',
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
