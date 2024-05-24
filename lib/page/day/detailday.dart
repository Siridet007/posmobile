// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pos_mobile/model/model.dart';
import 'package:pos_mobile/page/day/daypage.dart';

class DetailDayPage extends StatefulWidget {
  final String? sellno;
  final String? location;
  final String? flag;
  const DetailDayPage({super.key, this.sellno, this.location, this.flag});

  @override
  State<DetailDayPage> createState() => _DetailDayPageState();
}

class _DetailDayPageState extends State<DetailDayPage> {
  double? width;
  double? height;

  List<GetDetailDay>? detailList = [];

  Future<List<GetDetailDay>?> getDetail(sellno) async {
    FormData formData = FormData.fromMap({
      "mode": "get_dpos",
      "saleno": sellno,
    });
    String domain2 =
        "http://172.2.100.14/application/query_pos_trolley/fluttercon.php";

    String urlAPI = domain2;

    Response response = await Dio().post(urlAPI, data: formData);
    var result = GetDetailDay.fromJsonList(response.data);
    return result;
  }

  Future<List<GetProduct>?> cancelData(sellno) async {
    FormData formData = FormData.fromMap(
      {
        "mode": "CANCEL",
        "saleno": sellno,
      },
    );

    String domain2 =
        "http://172.2.100.14/application/query_pos_trolley/fluttercon.php";

    String urlAPI = domain2;
    var result;
    try {
      Response response = await Dio().post(urlAPI, data: formData);
      result = GetProduct.fromJsonList(response.data);
    } catch (e) {
      // ignore: avoid_print
      print('Error $e');
    }
    return result;
  }

  Future cancelFuture(BuildContext context) => showDialog(
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
                '  Alert',
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
          content: const Text(
            'ต้องการยกเลิกบิลนี้หรือไม่',
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
                  cancelData(widget.sellno);
                  setState(() {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DayPage(location: widget.location),
                      ),
                    );
                  });
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
    getDetail(widget.sellno).then((value) {
      setState(() {
        detailList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(      
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(237, 0, 140, 1),
        centerTitle: true,
        title: const Text(
          'รายละเอียด',
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          widget.flag == 'N' ? IconButton(
            onPressed: () {
              setState(() {
                cancelFuture(context);
              });
            },
            icon: const Icon(Icons.cancel),
            tooltip: 'cancel bill',
          ):Container(),
        ],
      ),
      body: Container(
        color: Colors.pink[50],
        child: Column(
          children: [
            /*Container(
              width: width,
              height: height! * .12,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.pink[50],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*Container(
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
                          /*productList = list!
                              .where((element) => element.cODESALE!
                                  .toLowerCase()
                                  .contains(search.text.toLowerCase()))
                              .toList();*/
                        });
                      },
                    ),
                  ),*/
                ],
              ),
            ),*/
            Container(
              width: width,
              height: height! * .864,
              child: detailList!.isEmpty
                  ? Center(
                      child: LoadingAnimationWidget.fourRotatingDots(
                          color: Colors.pink, size: 100),
                    )
                  : ListView.builder(
                      itemCount: detailList!.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: width,
                          height: height! * .2,
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side:
                                  const BorderSide(color: Colors.pink, width: 2),
                            ),
                            child: InkWell(
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width! * .1,
                                          child: Row(
                                            children: [
                                              //const Text('Item : ',style: TextStyle(fontSize: 16),),
                                              Text('${index + 1}',style: const TextStyle(fontSize: 20,decoration: TextDecoration.underline,decorationColor: Colors.deepOrange),)
                                            ],
                                          ),
                                        ),
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
                                          '${detailList![index].salecode}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width! * .1,                                        
                                        ),
                                        SizedBox(
                                          width: width! * .25,
                                          child: const Text(
                                            'ชื่อสินค้า : ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.purple),
                                          ),
                                        ),
                                        Text(
                                          '${detailList![index].salename}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width! * .1,                                        
                                        ),
                                        SizedBox(
                                          width: width! * .35,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                child: Text(
                                                  'จำนวน : ',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.red),
                                                ),
                                              ),
                                              SizedBox(
                                                child: Text(
                                                  '${detailList![index].quantity}',
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                child: Text(
                                                  'หน่วยละ : ',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.blue),
                                                ),
                                              ),
                                              SizedBox(
                                                child: Text(
                                                  '${detailList![index].priceunit}',
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width! * .1,                                        
                                        ),
                                        SizedBox(
                                          width: width! *.35,
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
                                                  '${detailList![index].unit}',
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                child: Text(
                                                  'ราคา : ',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.pink),
                                                ),
                                              ),
                                              SizedBox(
                                                child: Text(
                                                  '${detailList![index].total}',
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
  }
}
