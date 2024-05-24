// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../model/model.dart';

class SummaryPage extends StatefulWidget {
  final String? location;
  const SummaryPage({super.key, this.location});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  TextEditingController search = TextEditingController();
  double? width;
  double? height;
  List<GetSellDay>? sellList = [];
  List<GetSellDay>? list = [];
  List<GetDetailDate>? detailList = [];
  DateTime dateTime = DateTime.now();
  var date;
  var typePay;
  var pricePay;
  List sumTotal = [];
  List sumRec = [];
  List sumChange = [];
  List sumCredit = [];
  List sumDiscount = [];
  List sumQty = [];
  List sumBill = [];
  var takeSumTotal;
  var takeSumCash;
  var takeSumCredit;
  var takeSumDis;
  var takeSumQty;
  var takeSumBill;

  Future<List<GetSellDay>?> getSell(date, location) async {
    FormData formData = FormData.fromMap({
      "mode": "get_hpos",
      "saledate": date,
      "flag": 'N',
      "location": location,
    });
    String domain2 =
        "http://172.2.100.14/application/query_pos_trolley/fluttercon.php";

    String urlAPI = domain2;

    Response response = await Dio().post(urlAPI, data: formData);
    //print(response.data);
    var result = GetSellDay.fromJsonList(response.data);
    return result;
  }

  Future<List<GetDetailDate>?> getDetail(date) async {
    FormData formData = FormData.fromMap({
      "mode": "get_dpos_saledate",
      "saledate": date,
    });
    String domain2 =
        "http://172.2.100.14/application/query_pos_trolley/fluttercon.php";

    String urlAPI = domain2;

    Response response = await Dio().post(urlAPI, data: formData);
    //print(response.data);
    var result = GetDetailDate.fromJsonList(response.data);
    return result;
  }

  @override
  void initState() {
    super.initState();
    var date = DateFormat('yyyy-MM-dd').format(dateTime);
    getSell(date, widget.location).then((value) {
      setState(() {
        sellList = value;
        if (sellList!.first.saleno == '') {
        } else {          
          takeSumBill = sellList!.length;
          for (int i = 0; i < sellList!.length; i++) {
            sumTotal.add([sellList![i].total]);
            sumRec.add([sellList![i].totRec]);
            sumChange.add([sellList![i].totChange]);
            sumCredit.add([sellList![i].totCreditcard]);
            sumQty.add([sellList![i].qtygood]);
            sumDiscount.add([sellList![i].totDiscount]);
          }
          for (int i = 0; i < sellList!.length; i++) {
            if (sellList![i].accode == '100') {
              typePay = 'เงินสด';
              pricePay = (double.parse(sellList![i].totRec.toString()) -
                      double.parse(sellList![i].totChange.toString()))
                  .toStringAsFixed(2);
            } else if (sellList![i].accode == '101') {
              typePay = 'บัตรเครดิต';
              pricePay = sellList![i].totCreditcard;
            }
          }
          getDetail(date).then((value) {
            setState(() {
              detailList = value;
              for (int i = 0; i < detailList!.length; i++) {
                print(detailList![i].discount);
                if(detailList![i].discount == ''){
                  
                }else{
                  sumDiscount.add([detailList![i].discount]);
                }
                
              }
              //discount
              print(sumDiscount);
              double sum6 = 0.0;
              List flatList6 =
                  sumDiscount.expand((sublist) => sublist).toList();
              for (var n in flatList6) {
                sum6 += double.parse(n);
              }
              takeSumDis = sum6.toStringAsFixed(2);
            });
          });
          //total
          double sum = 0.0;
          List flatList = sumTotal.expand((sublist) => sublist).toList();
          for (var n in flatList) {
            sum += double.parse(n);
          }
          takeSumTotal = sum.toStringAsFixed(2);
          //จำนวนเงิน
          double sum2 = 0.0;
          List flatList2 = sumRec.expand((sublist) => sublist).toList();
          for (var n in flatList2) {
            sum2 += double.parse(n);
          }
          //เงินทอน
          double sum3 = 0.0;
          List flatList3 = sumChange.expand((sublist) => sublist).toList();
          for (var n in flatList3) {
            sum3 += double.parse(n);
          }
          takeSumCash = (sum2 - sum3).toStringAsFixed(2);
          //เงินเครดิต
          double sum4 = 0.0;
          List flatList4 = sumCredit.expand((sublist) => sublist).toList();
          for (var n in flatList4) {
            sum4 += double.parse(n);
          }
          takeSumCredit = sum4.toStringAsFixed(2);
          //qty
          double sum5 = 0.0;
          List flatList5 = sumQty.expand((sublist) => sublist).toList();
          for (var n in flatList5) {
            sum5 += double.parse(n);
          }
          takeSumQty = sum5.toStringAsFixed(2);
        }
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
          'Summary',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: sellList!.isEmpty
          ? Center(
              child: LoadingAnimationWidget.fallingDot(
                  color: Colors.pink, size: 100),
            )
          : sellList!.first.saleno == ''
              ? const Center(
                  child: Text(
                    'ยังไม่มีข้อมูล',
                    style: TextStyle(fontSize: 50),
                  ),
                )
              : Container(
                color: Colors.pink[50],
                child: Column(
                    children: [
                      /*Container(
                        width: width,
                        height: height! * .714,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: Colors.pink[50],
                        ),
                        child: ListView.builder(
                          itemCount: sellList!.length,
                          itemBuilder: (context, index) {
                            DateTime time = DateFormat('yyyy-MM-dd')
                                .parse(sellList![index].saledate.toString());
                            date = DateFormat('yyyy-MM-dd').format(time);
                            if (sellList![index].accode == '100') {
                              typePay = 'เงินสด';
                              pricePay = (double.parse(
                                          sellList![index].totRec.toString()) -
                                      double.parse(
                                          sellList![index].totChange.toString()))
                                  .toStringAsFixed(2);
                            } else if (sellList![index].accode == '101') {
                              typePay = 'บัตรเครดิต';
                              pricePay = sellList![index].totCreditcard;
                            }
                            return SizedBox(
                              width: width,
                              height: height! * .12,
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: const BorderSide(
                                      color: Colors.pink, width: 2),
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
                                              width: width! * .2,
                                              child: const Text(
                                                'เลขที่บิล : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.brown),
                                              ),
                                            ),
                                            Text(
                                              '${sellList![index].saleno}',
                                              style:
                                                  const TextStyle(fontSize: 16),
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
                                                      'ประเภท : ',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.blue),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    child: Text(
                                                      '$typePay',
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
                                                      'ราคา : ',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.pink),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    child: Text(
                                                      '${sellList![index].total}',
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
                      ),*/
                      Container(
                        padding: const EdgeInsets.fromLTRB(30, 20, 10, 20),
                        width: width,
                        height: height! * .86,
                        color: Colors.pink[50],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: width! * .4,
                                  child: const Text(
                                    'Total : ',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.amber),
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    '$takeSumTotal',
                                    style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: width! * .4,
                                  child: const Text(
                                    'เงินสด : ',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.green),
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    '$takeSumCash',
                                    style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: width! * .4,
                                  child: const Text(
                                    'Credit : ',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.deepOrange),
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    '$takeSumCredit',
                                    style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: width! * .4,
                                  child: const Text(
                                    'ส่วนลด : ',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.red),
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    '$takeSumDis',
                                    style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: width! * .4,
                                  child: const Text(
                                    'จำนวน : ',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.deepPurple),
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    '$takeSumQty',
                                    style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: width! * .4,
                                  child: const Text(
                                    'จำนวนบิล : ',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.teal),
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    '$takeSumBill',
                                    style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ),
    );
  }
}
