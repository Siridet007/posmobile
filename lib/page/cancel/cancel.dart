// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../model/model.dart';
import '../day/detailday.dart';

class CancelPage extends StatefulWidget {
  final String? location;
  const CancelPage({super.key, this.location});

  @override
  State<CancelPage> createState() => _CancelPageState();
}

class _CancelPageState extends State<CancelPage> {
  TextEditingController search = TextEditingController();
  double? width;
  double? height;
  List<GetSellDay>? sellList = [];
  List<GetSellDay>? list = [];
  DateTime dateTime = DateTime.now();
  var date;

  Future<List<GetSellDay>?> getSell(date, location) async {
    FormData formData = FormData.fromMap({
      "mode": "get_hpos",
      "saledate": date,
      "flag": 'C',
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

  Future<List<GetSellDay>?> filterSell() async {
    return list?.toList();
  }

    @override
  void initState() {
    super.initState();
    var date = DateFormat('yyyy-MM-dd').format(dateTime);
    getSell(date, widget.location).then((value) {
      setState(() {
        list = value;
        filterSell().then((value) {
          setState(() {
            sellList = value;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(237, 0, 140, 1),
        centerTitle: true,
        title: const Text('Cancel Bill'),
      ),
      body: Container(
        color: Colors.pink[50],
        child: Column(
          children: [
            Container(
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
                        UpperCaseTextFormatter(),
                      ],
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
                          sellList = list!
                              .where((element) => element.saleno!
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
              child: sellList!.isEmpty
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
                      : ListView.builder(
                          itemCount: sellList!.length,
                          itemBuilder: (context, index) {
                            DateTime time = DateFormat('yyyy-MM-dd')
                                .parse(sellList![index].saledate.toString());
                            date = DateFormat('dd/MM/yyyy').format(time);
                            return SizedBox(
                              width: width,
                              height: height! * .15,
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: const BorderSide(
                                      color: Colors.pink, width: 2),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailDayPage(
                                              sellno: sellList![index].saleno,
                                              location: widget.location,
                                              flag: 'C'),
                                        ),
                                      );
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
                                            SizedBox(
                                              width: width! * .25,
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
                                                      'วันที่ : ',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    child: Text(
                                                      '$date',
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
                                                      'ประเภท : ',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.green),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    child: Text(
                                                      '${sellList![index].cardtype}',
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
                                              width: width! * .45,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    child: Text(
                                                      'จำนวนสินค้า : ',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.blue),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    child: Text(
                                                      '${sellList![index].qtygood}',
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
            ),
          ],
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
