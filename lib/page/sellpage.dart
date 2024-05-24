// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pos_mobile/model/model.dart';
import 'package:pos_mobile/page/firstpage.dart';
import 'package:pos_mobile/page/sell/paypage.dart';
import 'package:pos_mobile/page/sell/searchpage.dart';

class SellPage extends StatefulWidget {
  final String? username;
  final String? taxid;
  final String? shopchar;
  final String? shopid;
  const SellPage(
      {super.key, this.username, this.taxid, this.shopchar, this.shopid});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  double? width;
  double? height;
  TextEditingController seat = TextEditingController();
  TextEditingController queue = TextEditingController();
  TextEditingController discbath = TextEditingController();
  TextEditingController disc = TextEditingController();
  List<ReceiveProduct>? product = [];
  List? net = [];
  List? qty = [];
  String netSum = '0.00';
  String qtySum = '0.00';
  List<GetDetail>? detailList = [];
  var takeCode;
  var takeQty;
  var takeUnit;
  var takePriceUnit;
  var takeTotal;
  var takeVat;
  var takeDisBath;
  var takeDate;
  var takeSellname;
  var takeDisPercent;
  DateTime dateTime = DateTime.now();
  List<GetSaleNo>? saleList = [];
  var takeBillno;

  Future<List<GetSaleNo>?> getSaleNo(lo) async {
    FormData formData = FormData.fromMap({
      "mode": 'get_saleno',
      "location": lo,
    });
    String domain2 =
        "http://172.2.100.14/application/query_pos_trolley/fluttercon.php";

    String urlAPI = domain2;

    Response response = await Dio().post(urlAPI, data: formData);
    //print(jsonDecode(response.data));
    var result = GetSaleNo.fromJsonList(response.data);
    return result;
  }

  Future resetFuture(BuildContext context) => showDialog(
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
            'ต้องการรีเซ็ตสินค้าใช่หรือไม่',
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
                  setState(() {
                    product!.clear();
                    netSum = '0.00';
                    Navigator.of(context).pop();
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
    getSaleNo(widget.shopchar).then((value) {
      setState(() {
        saleList = value;
        takeBillno = '${saleList!.first.saleno}';
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
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(237, 0, 140, 1),
        centerTitle: true,
        title: const Text(
          'Sell',
          style: TextStyle(fontSize: 25),
        ),
        leading: IconButton(
          onPressed: () {
            setState(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => FirstPage(
                    username: widget.username,
                    shopchar: widget.shopchar,
                    taxid: widget.taxid,
                    shopid: widget.shopid,
                  ),
                ),
              );
            });
          },
          tooltip: 'ย้อนกลับ',
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
              if (result != null && result.length == 11) {
                setState(() {
                  product!.add(
                    ReceiveProduct(
                      code: result[1],
                      name: result[0],
                      qauntity: result[2],
                      price: result[4],
                      discount: result[7],
                      //discountpercent: result[5],
                      total: result[5],
                    ),
                  );
                  takeCode = result[1];
                  takeQty = result[2];
                  takeUnit = result[3];
                  takePriceUnit = result[4];
                  takeTotal = result[5];
                  takeVat = result[6];
                  takeDisBath = result[7];
                  takeDate = result[8];
                  takeSellname = result[9];
                  takeDisPercent = result[10];
                  detailList!.add(
                    GetDetail(
                      salecode: takeCode,
                      quantity: takeQty,
                      unit: takeUnit,
                      priceunit: takePriceUnit,
                      total: takeTotal,
                      vat: takeVat,
                      discount: takeDisBath,
                      updateDate: takeDate,
                      salename: takeSellname,
                      deposit: 'N',
                      disPercent: takeDisPercent,
                      postflag: 'N',
                      loadcons: 'N',
                    ),
                  );
                  net!.add([result[5]]);
                  double sum = 0.0;
                  List flatList = net!.expand((sublist) => sublist).toList();
                  for (var n in flatList) {
                    sum += double.parse(n);
                  }
                  netSum = sum.toStringAsFixed(2);

                  qty!.add([result[2]]);
                  double q = 0.0;
                  List qList = qty!.expand((element) => element).toList();
                  for (var t in qList) {
                    q += double.parse(t);
                  }
                  qtySum = q.toStringAsFixed(2);
                });
              }
            },
            icon: const Icon(Icons.search),
            tooltip: 'เพิ่มสินค้า',
          ),
        ],
      ),
      body: saleList!.isEmpty
          ? Center(
              child: LoadingAnimationWidget.dotsTriangle(
                  color: Colors.pink, size: 100))
          : Container(
              width: width,
              height: height,
              color: Colors.pink[50],
              child: Column(
                children: [
                  Container(
                    width: width,
                    height: height! * .2,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.pink[50],
                    ),
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text(
                                'Bill No : ',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.green),
                              ),
                            ),
                            Text(
                              takeBillno,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text(
                                'Seat : ',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.pink,
                                ),
                              ),
                            ),
                            Container(
                              width: 130,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              child: TextField(
                                controller: seat,
                                style: const TextStyle(fontSize: 18),
                                inputFormatters: [
                                  UpperCaseTextFormatter(),
                                ],
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10, 10, 0, 0),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  ),
                                  labelText: 'Seat',
                                  labelStyle: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            /*Container(
                        width: 130,
                        height: 40,
                        child: TextField(
                          controller: queue,
                          style: const TextStyle(fontSize: 18),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            hintText: 'Queue',
                            hintStyle: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),*/
                          ],
                        ),
                        /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 130,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: TextField(
                          controller: discbath,
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
                            labelText: 'Disc(THB)',
                            labelStyle: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      Container(
                        width: 130,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: TextField(
                          controller: disc,
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
                            labelText: 'Disc(%)',
                            labelStyle: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),*/
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 130,
                              child: Row(
                                children: [
                                  Text(
                                    product!.length >= 2
                                        ? 'Records : '
                                        : 'Record : ',
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.red),
                                  ),
                                  Text(
                                    '${product!.length}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 130,
                              child: Row(
                                children: [
                                  const Text(
                                    'NET : ',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.blue),
                                  ),
                                  Text(
                                    netSum,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: width,
                    height: height! * .562,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.pink[50],
                    ),
                    child: product!.isEmpty
                        ? const Center(
                            child: Text(
                            'ยังไม่มีสินค้า',
                            style: TextStyle(fontSize: 30),
                          ))
                        : ListView.builder(
                            itemCount: product!.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: width,
                                height: height! * .2,
                                child: Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      side: const BorderSide(
                                          color: Colors.pink, width: 2)),
                                  child: InkWell(
                                    child: Stack(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: width! * .17,
                                                    child: Row(
                                                      children: [
                                                        const Text(
                                                          'No : ',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                        Text(
                                                          '${index + 1}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    child: Row(
                                                      children: [
                                                        const Text(
                                                          'Code : ',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.brown),
                                                        ),
                                                        Text(
                                                          '${product![index].code}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Name : ',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.indigo),
                                                      ),
                                                      SizedBox(
                                                        width: width! * .72,
                                                        child: Text(
                                                          '${product![index].name}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 16),
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
                                                      children: [
                                                        const Text(
                                                          'Price : ',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.cyan),
                                                        ),
                                                        Text(
                                                          '${product![index].price}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'QTY : ',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.blue),
                                                      ),
                                                      Text(
                                                        '${product![index].qauntity}',
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: width! * .45,
                                                    child: Row(
                                                      children: [
                                                        const Text(
                                                          'Disc. : ',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                        Text(
                                                          '${product![index].discount}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Total : ',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.pink),
                                                      ),
                                                      Text(
                                                        '${product![index].total}',
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: -10,
                                          right: -10,
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: Row(
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black),
                                                            color: const Color
                                                                    .fromRGBO(
                                                                237, 0, 140, 1),
                                                          ),
                                                          child: const Icon(
                                                            Icons.delete,
                                                            color: Colors.white,
                                                            size: 30,
                                                          ),
                                                        ),
                                                        const Text(
                                                          '  Delete',
                                                          style: TextStyle(
                                                              fontSize: 30,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      Container(
                                                        width: 70,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black),
                                                          color: const Color
                                                                  .fromRGBO(
                                                              237, 0, 140, 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              product!.removeAt(
                                                                  index);
                                                              net!.removeAt(
                                                                  index);
                                                              double sum = 0.0;
                                                              List flatList = net!
                                                                  .expand(
                                                                      (sublist) =>
                                                                          sublist)
                                                                  .toList();
                                                              for (var n
                                                                  in flatList) {
                                                                sum += double
                                                                    .parse(n);
                                                              }
                                                              netSum = sum
                                                                  .toStringAsFixed(
                                                                      2);

                                                              qty!.removeAt(
                                                                  index);
                                                              double q = 0.0;
                                                              List qList = qty!
                                                                  .expand(
                                                                      (element) =>
                                                                          element)
                                                                  .toList();
                                                              for (var t
                                                                  in qList) {
                                                                q += double
                                                                    .parse(t);
                                                              }
                                                              qtySum = q
                                                                  .toStringAsFixed(
                                                                      2);
                                                            });

                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text(
                                                            'YES',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 70,
                                                        height: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black),
                                                          color: const Color
                                                                  .fromRGBO(
                                                              237, 0, 140, 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                          child: const Text(
                                                            'NO',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });
                                            },
                                            tooltip: 'ลบ',
                                            icon: const Icon(
                                              Icons.delete_forever,
                                              size: 35,
                                              color: Colors.red,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  Container(
                    width: width,
                    height: height! * .1,
                    color: Colors.pink[50],
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /*Container(
                    width: 90,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.yellow[300])),
                      child: const Text(
                        'Last Bill',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),*/
                        Container(
                          width: 90,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ElevatedButton(
                            onPressed: product!.isEmpty
                                ? null
                                : () {
                                    setState(() {
                                      resetFuture(context);
                                    });
                                  },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith((states) =>
                                      product!.isEmpty
                                          ? Colors.purple[50]
                                          : Colors.purple[400]),
                            ),
                            child: const Text(
                              'Reset',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        Container(
                          width: 90,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ElevatedButton(
                            onPressed: product!.isEmpty || seat.text.isEmpty
                                ? null
                                : () {
                                    setState(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PayPage(
                                            price: netSum,
                                            productList: detailList,
                                            seat: seat.text,
                                            billNo: takeBillno,
                                            username: widget.username,
                                            qtygood: qtySum,
                                            shopchar: widget.shopchar,
                                            taxid: widget.taxid,
                                            shopid: widget.shopid,
                                          ),
                                        ),
                                      );
                                    });
                                  },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => product!.isEmpty ||
                                                seat.text.isEmpty
                                            ? Colors.pink[50]
                                            : Colors.pink[300])),
                            child: const Text(
                              'Pay',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
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
