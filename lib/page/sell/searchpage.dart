// ignore_for_file: prefer_typing_uninitialized_variables


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../model/model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  double? width;
  double? height;
  TextEditingController search = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController discbath = TextEditingController();
  TextEditingController disc = TextEditingController();
  double qty = 1.0;
  double? enteredValue;
  List<GetProductNew>? productList = [];
  List<GetProductNew>? list = [];
  var takeCode;
  var takeName;
  var takeQty;
  var takePrice;
  var takeUnit;
  var takeTotal;
  var takeDisBath;
  var takeDatetime;
  var takeDisPercent;
  var takeVat;
  var takeEname;
  DateTime dateTime = DateTime.now();
  String _twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    }
    return '0$n';
  }

  Future<List<GetProductNew>?> getProduct() async {
    String domain2 =
        "http://172.2.100.14/application/query_pos_trolley/fluttercon.php?mode=get_product";

    String urlAPI = domain2;

    Response response = await Dio().post(urlAPI);
    //print(jsonDecode(response.data));
    var result = GetProductNew.fromJsonList(response.data);
    return result;
  }

  Future<List<GetProductNew>?> filterProduct() async {
    return list?.toList();
  }

  @override
  void initState() {
    super.initState();
    getProduct().then((value) {
      setState(() {
        list = value;
        filterProduct().then((value) {
          setState(() {
            productList = value;
          });
        });
      });
    });
    amount.text = qty.toString();
  }

  Future selectFuture(BuildContext context) => showDialog(
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
          content: SingleChildScrollView(
            child: Container(
              width: width,
              height: height! * .4,
              //decoration: BoxDecoration(border: Border.all(color: Colors.black)),
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 60,
                        child: TextField(
                          controller: amount,
                          style: const TextStyle(fontSize: 20),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            labelText: 'ใส่จำนวน',
                            labelStyle: TextStyle(fontSize: 20),
                          ),
                          onChanged: (value) {
                            setState(() {
                              enteredValue = double.tryParse(value) ?? 0.0;
                            });
                          },
                          onSubmitted: (value) {
                            amount.text = enteredValue.toString();
                            qty = double.parse(amount.text);
                          },
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black),
                                color: Colors.green),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  qty++;
                                  amount.text = qty.toString();
                                });
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black),
                              color: Colors.red,
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  qty--;
                                  if (qty <= 1.0) {
                                    qty = 1.0;
                                  }
                                  amount.text = qty.toString();
                                });
                              },
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  const Text('ส่วนลดสินค้า (จำนวนเงิน)'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 110,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: TextField(
                          controller: discbath,
                          enabled: takePrice == '0.00' ? false : true,
                          style: const TextStyle(fontSize: 18),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            hintText: 'Disc(THB)',
                            hintStyle: TextStyle(fontSize: 18),
                          ),
                          onSubmitted: (value) {
                            setState(() {
                              disc.clear();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black),
                          color:
                              takePrice == '0.00' ? Colors.red[50] : Colors.red,
                        ),
                        child: IconButton(
                          onPressed: takePrice == '0.00'
                              ? null
                              : () {
                                  setState(() {
                                    discbath.clear();
                                  });
                                },
                          icon: const Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  const Text('ส่วนลดสินค้า (เปอร์เซ็นต์)'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 110,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: TextField(
                          controller: disc,
                          enabled: takePrice == '0.00' ? false : true,
                          style: const TextStyle(fontSize: 18),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            hintText: 'Disc(%)',
                            hintStyle: TextStyle(fontSize: 18),
                          ),
                          onSubmitted: (value) {
                            setState(() {
                              discbath.clear();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black),
                          color:
                              takePrice == '0.00' ? Colors.red[50] : Colors.red,
                        ),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              disc.clear();
                            });
                          },
                          icon: const Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
                  double qty = double.parse(amount.text);
                  double? sum;
                  double price = double.parse(takePrice);
                  double? dis;
                  double? d = price * qty;
                  if (takePrice == '0.00') {
                    sum = 0.00;
                    takeDisBath = '0.00';
                    takeTotal = sum.toStringAsFixed(2);
                    takeDisPercent = '0.00';
                  } else {
                    if (discbath.text.isNotEmpty) {
                      double disb = double.parse(discbath.text);
                      takeDisBath = disb.toStringAsFixed(2);
                      dis = d - disb;
                      takeTotal = dis.toStringAsFixed(2);
                      double perc = (disb / dis) * 100;
                      takeDisPercent = perc.toStringAsFixed(2);
                    } else if (disc.text.isNotEmpty) {
                      double disp = double.parse(disc.text);
                      double percent = d * (disp / 100);
                      takeDisPercent = disp.toStringAsFixed(2);
                      takeDisBath = percent.toStringAsFixed(2);
                      dis = d - percent;
                      takeTotal = dis.toStringAsFixed(2);
                    } else {
                      takeDisBath = '0.00';
                      takeDisPercent = '0.00';
                      dis = d - 0.0;
                      takeTotal = dis.toStringAsFixed(2);
                    }
                  }
                  double vat = double.parse(takeTotal) * 0.07;
                  takeVat = vat.toStringAsFixed(2);
                  takeQty = qty.toStringAsFixed(2);
                  //print('$takeCode $takeName $takeQty $takePrice $takeDisBath $takeDisPercent $takeTotal $takeVat $takeEname $takeDatetime');
                  Navigator.of(context).pop();
                  Navigator.of(context).pop([
                    takeName,
                    takeCode,
                    takeQty,
                    takeUnit,
                    takePrice,
                    takeTotal,
                    takeVat,
                    takeDisBath,
                    takeDatetime,
                    takeEname,
                    takeDisPercent,
                  ]);
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
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    String date =
        '${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)} ${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}:${_twoDigits(dateTime.second)}';
    //var time = DateFormat.Hms().parse(dateTime.toString());
    takeDatetime = date;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(237, 0, 140, 1),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            setState(() {
              Navigator.of(context).pop();
            });
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'เพิ่มรายการสินค้า',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: Container(
        color: Colors.pink[50],
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .12,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.pink[50],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 290,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: search,
                      style: const TextStyle(fontSize: 18),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        labelText: 'Search',
                        labelStyle: TextStyle(fontSize: 18),
                      ),
                      onChanged: (value) {
                        setState(() {
                          productList = list!
                              .where((element) => element.cODESALE!
                                  .toLowerCase()
                                  .contains(search.text.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              //color: Colors.pink[50],
              child: productList!.isEmpty
                  ? LoadingAnimationWidget.fallingDot(
                      color: const Color.fromRGBO(237, 0, 140, 1),
                      size: 100,
                    )
                  : ListView.builder(
                      itemCount: productList!.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: width,
                          height: height! * .18,
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side:
                                  const BorderSide(color: Colors.pink, width: 2),
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  takeCode = productList![index].cODESALE;
                                  takeName = productList![index].nAMESALE;
                                  takePrice = productList![index].pRICESALE;
                                  takeUnit = productList![index].pACK;
                                  takeEname = productList![index].eNAMESALE;
                                  selectFuture(context);
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        /*SizedBox(
                                    width: width! * .17,
                                    child: Row(
                                      children: [
                                        const Text(
                                          'No : ',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.green),
                                        ),
                                        Text(
                                          '${index + 1}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),*/
                                        SizedBox(
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: width! * .25,
                                                child: const Text(
                                                  'รหัสสินค้า : ',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.brown),
                                                ),
                                              ),
                                              Text(
                                                '${productList![index].cODESALE}',
                                                style:
                                                    const TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        /*Container(
                                    width: width! * .17,
                                  ),*/
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: width! * .25,
                                              child: const Text(
                                                'ชื่อสินค้า : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.indigo),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width! * .65,
                                              child: Text(
                                                '${productList![index].nAMESALE}',
                                                style:
                                                    const TextStyle(fontSize: 16),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width! * .45,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                child: Text(
                                                  'ราคา : ',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.red),
                                                ),
                                              ),
                                              SizedBox(
                                                child: Text(
                                                  '${productList![index].pRICESALE}',
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: width! * .45,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                child: Text(
                                                  'หน่วย : ',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.green),
                                                ),
                                              ),
                                              SizedBox(
                                                child: Text(
                                                  '${productList![index].pACK}',
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
    /*return AlertDialog(
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
            '  เพิ่มรายการสินค้า',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),      
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .9,
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: const Color.fromRGBO(237, 0, 140, 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(left: 10)),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: const Color.fromRGBO(237, 0, 140, 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );*/
  }
}
