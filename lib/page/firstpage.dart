import 'package:flutter/material.dart';
import 'package:pos_mobile/page/cancel/cancel.dart';
import 'package:pos_mobile/page/day/daypage.dart';
import 'package:pos_mobile/page/select.dart';
import 'package:pos_mobile/page/sellpage.dart';
import 'package:pos_mobile/page/summary/summary.dart';

class FirstPage extends StatefulWidget {
  final String? taxid;
  final String? shopchar;
  final String? username;
  final String? shopid;
  const FirstPage(
      {super.key, this.username, this.taxid, this.shopchar, this.shopid});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  double? width;
  double? height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(237, 0, 140, 1),
        centerTitle: true,
        title: const Text('POS Mobile'),
        leading: IconButton(
          onPressed: () {
            setState(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectPage(username: widget.username),
                ),
              );
            });
          },
          tooltip: 'ย้อนกลับ',
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        width: width,
        height: height,
        color: Colors.pink[50],
        child: GridView.count(
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
                        builder: (context) => SellPage(
                            username: widget.username,
                            shopchar: widget.shopchar,
                            taxid: widget.taxid,
                            shopid: widget.shopid),
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
                          'assets/images/shop.png',
                        ),
                      ),
                    ),
                    const Expanded(
                      child: AspectRatio(
                        aspectRatio: 2.0,
                        child: Center(
                          child: Text(
                            'Sell',
                            style: TextStyle(fontSize: 60),
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
                        builder: (context) =>
                            DayPage(location: widget.shopchar),
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
                          'assets/images/day.png',
                        ),
                      ),
                    ),
                    const Expanded(
                      child: AspectRatio(
                        aspectRatio: 2.0,
                        child: Center(
                          child: Text(
                            'Sell / Day',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
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
                        builder: (context) =>
                            SummaryPage(location: widget.shopchar),
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
                          'assets/images/summary.png',
                        ),
                      ),
                    ),
                    const Expanded(
                      child: AspectRatio(
                        aspectRatio: 2.0,
                        child: Center(
                          child: Text(
                            'Summary',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
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
                        builder: (context) =>
                            CancelPage(location: widget.shopchar),
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
                          'assets/images/cancel.png',
                        ),
                      ),
                    ),
                    const Expanded(
                      child: AspectRatio(
                        aspectRatio: 2.0,
                        child: Center(
                          child: Text(
                            'Cancel Bill',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
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
        /*child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
          ),
          children: [
            Card(                
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              color: Colors.pink[100],
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SellPage(),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(),
                      child: Image.asset(
                        'assets/images/shop.png',
                      ),
                    ),
                    /*const Text(
                      'Sell',
                      style: TextStyle(fontSize: 60),
                    )*/
                  ],
                ),
              ),
            ),
            /*Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              color: Colors.pink[100],
              child: InkWell(
                onTap: () {
                  /*Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BusinessPage(),
                        ),);*/
                },
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(),
                      child: Image.asset(
                        'assets/images/day.png',
                        cacheHeight: 250,
                        cacheWidth: 250,
                      ),
                    ),
                    /*const Text(
                      'Sell per Day',
                      style: TextStyle(fontSize: 55),
                    )*/
                  ],
                ),
              ),
            ),
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              color: Colors.pink[100],
              child: InkWell(
                onTap: () {
                  /*Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BusinessPage(),
                        ),);*/
                },
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(),
                      child: Image.asset(
                        'assets/images/summary.png',
                      ),
                    ),
                    /*const Text(
                      'Summary',
                      style: TextStyle(fontSize: 60),
                    )*/
                  ],
                ),
              ),
            ),
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              color: Colors.pink[100],
              child: InkWell(
                onTap: () {
                  /*Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BusinessPage(),
                        ),);*/
                },
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(),
                      child: Image.asset(
                        'assets/images/cancel.png',
                        scale: .5,
                      ),
                    ),
                   /* const Text(
                      'Cancel Bill',
                      style: TextStyle(fontSize: 60),
                    )*/
                  ],
                ),
              ),
            ),*/
          ],
        ),*/
      ),
    );
  }
}
