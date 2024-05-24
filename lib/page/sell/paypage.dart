// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_mobile/model/model.dart';
import 'package:pos_mobile/page/sellpage.dart';

class PayPage extends StatefulWidget {
  final String? billNo;
  final String? taxid;
  final String? seat;
  final String? qtygood;
  final String? price;
  final String? shopid;
  final String? shopchar;
  final String? username;
  final List? productList;
  const PayPage(
      {super.key,
      this.price,
      this.seat,
      this.billNo,
      this.productList,
      this.taxid,
      this.qtygood,
      this.shopchar,
      this.username,
      this.shopid});

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  TextEditingController amount = TextEditingController();
  TextEditingController discount = TextEditingController();
  TextEditingController total = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController change = TextEditingController();
  TextEditingController creditCard = TextEditingController();
  double money = 0.0;
  bool errorText = false;
  bool symbol = true;
  bool thousand = false;
  bool fivehundred = false;
  bool hundred = false;
  bool fifty = false;
  bool twenty = false;
  double? enterNum;
  double? sum;
  double? enterAmount;
  double? sumPrice;
  double? p;
  double? t;
  bool errorCheck = false;
  bool credit = false;
  List<GetDetail>? list = [];
  List<GetAccMaster>? accList = [];
  var takePercent;
  DateTime now = DateTime.now();
  var takeDate;
  var takeDatetime;
  String _twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    }
    return '0$n';
  }

  var grandTotal;
  var takeVat;
  var takeAccode;
  var takeCreditCard;
  var takeTotalCredit;

  Future<List<GetAccMaster>?> getAcc() async {
    String domain2 =
        "http://172.2.100.14/application/query_pos_trolley/fluttercon.php?mode=AcMaster";

    String urlAPI = domain2;

    Response response = await Dio().post(urlAPI);
    //print(response.data);
    var result = GetAccMaster.fromJsonList(response.data);
    return result;
  }

  Future<List<GetProduct>?> updateData(
      sellno,
      date,
      taxid,
      seat,
      qty,
      total,
      totrec,
      totch,
      totdis,
      vat,
      grand,
      card,
      shopid,
      shoplo,
      datetime,
      accode,
      username,
      totcre,
      percent,
      detail) async {
    String jsonData = json.encode(detail);
    FormData formData = FormData.fromMap(
      {
        "mode": "INSERT_DATA",
        "saleno": sellno,
        "saledate": date,
        "taxid": taxid,
        "guidecode": seat,
        "qtygood": qty,
        "total": total,
        "tot_rec": totrec,
        "tot_change": totch,
        "tot_discount": totdis,
        "vat": vat,
        "grand_total": grand,
        "id_card": card,
        "flag": 'N',
        "shopcode": shopid,
        "location": shoplo,
        "person_id": '',
        "staffcode": '',
        "sysdate": datetime,
        "cardtype": accode,
        "accode": accode,
        "saleuser": username,
        "tot_creditcard": totcre,
        "billtype": '',
        "percent_discount": percent,
        "entcode": '',
        "voucher": '',
        "coupon": '',
        "queue": '',
        "tot_type": '0',
        "detail": jsonData,
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
      print('Error $e');
    }
    return result;
  }

  Future saveFuture(BuildContext context) => showDialog(
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
            'ต้องการบันทึกรายการนี้ใช่หรือไม่',
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
                  updateData(
                    widget.billNo,
                    takeDate,
                    widget.taxid,
                    widget.seat,
                    widget.qtygood,
                    widget.price,
                    price.text,
                    change.text,
                    discount.text,
                    takeVat,
                    grandTotal,
                    takeCreditCard,
                    widget.shopid,
                    widget.shopchar,
                    takeDatetime,
                    takeAccode,
                    widget.username,
                    takeTotalCredit,
                    takePercent,
                    list,
                  );
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => SellPage(
                        shopchar: widget.shopchar,
                        taxid: widget.taxid,
                        username: widget.username,
                        shopid: widget.shopid,
                      ),
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
    getAcc().then((value) {
      setState(() {
        accList = value;
      });
    });
    price.text = money.toStringAsFixed(2);
    amount.text = widget.price.toString();
    discount.text = '0.00';
    total.text = widget.price.toString();
    change.text = '0.00';
    if (total.text == '0.00') {
      errorCheck = true;
    } else {
      errorCheck = false;
    }
    list = widget.productList!.cast<GetDetail>();
  }

  @override
  Widget build(BuildContext context) {
    takeDate = '${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)}';
    takeDatetime =
        '${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)} ${_twoDigits(now.hour)}:${_twoDigits(now.minute)}:${_twoDigits(now.second)}';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(237, 0, 140, 1),
        centerTitle: true,
        title: const Text(
          'Pay',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.pink[50],
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              /*Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .4,
                decoration: BoxDecoration(border: const Border(bottom: BorderSide(color: Colors.black)),color: Colors.pink[50]),
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Transform.scale(
                          scale: !symbol ? 1.2 : 1,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black),
                              color: !symbol ? Colors.red : Colors.red[100],
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  symbol = false;
                                });
                              },
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: thousand ? Colors.pink : Colors.black,
                              width: 2,
                            ),
                          ),
                          width: 130,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                thousand = true;
                                fivehundred = false;
                                hundred = false;
                                fifty = false;
                                twenty = false;
                                if (symbol) {
                                  money += 1000.0;
                                } else {
                                  if (money <= 0 || money < 1000) {
                                    money = 0.0;
                                  } else {
                                    money -= 1000.0;
                                  }
                                }
                                price.text = money.toString();
                              });
                            },
                            child: Image.asset('assets/images/1000THB.jpg'),
                          ),
                        ),
                        Transform.scale(
                          scale: symbol ? 1.2 : 1,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black),
                              color: symbol ? Colors.green : Colors.green[100],
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  symbol = true;
                                });
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: fivehundred ? Colors.pink : Colors.black,
                              width: 2,
                            ),
                          ),
                          width: 130,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                thousand = false;
                                fivehundred = true;
                                hundred = false;
                                fifty = false;
                                twenty = false;
                                if (symbol) {
                                  money += 500.0;
                                } else {
                                  if (money <= 0 || money < 500) {
                                    money = 0.0;
                                  } else {
                                    money -= 500.0;
                                  }
                                }
                                price.text = money.toString();
                              });
                            },
                            child: Image.asset('assets/images/500THB.jpg'),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: hundred ? Colors.pink : Colors.black,
                              width: 2,
                            ),
                          ),
                          width: 130,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                thousand = false;
                                fivehundred = false;
                                hundred = true;
                                fifty = false;
                                twenty = false;
                                if (symbol) {
                                  money += 100.0;
                                } else {
                                  if (money <= 0 || money < 100) {
                                    money = 0.0;
                                  } else {
                                    money -= 100.0;
                                  }
                                }
                                price.text = money.toString();
                              });
                            },
                            child: Image.asset('assets/images/100THB.jpg'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: fifty ? Colors.pink : Colors.black,
                              width: 2,
                            ),
                          ),
                          width: 130,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                thousand = false;
                                fivehundred = false;
                                hundred = false;
                                fifty = true;
                                twenty = false;
                                if (symbol) {
                                  money += 50.0;
                                } else {
                                  if (money <= 0 || money < 50) {
                                    money = 0.0;
                                  } else {
                                    money -= 50.0;
                                  }
                                }
                                price.text = money.toString();
                              });
                            },
                            child: Image.asset('assets/images/50THB.jpg'),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: twenty ? Colors.pink : Colors.black,
                              width: 2,
                            ),
                          ),
                          width: 130,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                thousand = false;
                                fivehundred = false;
                                hundred = false;
                                fifty = false;
                                twenty = true;
                                if (symbol) {
                                  money += 20.0;
                                } else {
                                  if (money <= 0 || money < 20) {
                                    money = 0.0;
                                  } else {
                                    money -= 20.0;
                                  }
                                }
                                price.text = money.toString();
                              });
                            },
                            child: Image.asset('assets/images/20THB.jpg'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),*/
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .75,
                color: Colors.pink[50],
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ราคาสินค้า',
                          style: TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                        Container(
                          width: 150,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            '${widget.price}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ส่วนลด',
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ),
                        Container(
                          width: 150,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          child: TextField(
                            controller: discount,
                            style: const TextStyle(fontSize: 20),
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
                            ),
                            onChanged: (value) {
                              setState(() {
                                enterNum = double.tryParse(value) ?? 0.0;
                                sum = double.parse(widget.price.toString()) -
                                    double.parse(enterNum.toString());
                                total.text = sum!.toStringAsFixed(2);
                              });
                            },
                            onSubmitted: (value) {
                              setState(() {
                                discount.text = enterNum!.toStringAsFixed(2);
                              });
                            },
                            onTap: () {
                              discount.selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: discount.text.length,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ราคารวม',
                          style: TextStyle(fontSize: 20, color: Colors.brown),
                        ),
                        Container(
                          width: 150,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            total.text,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'จำนวนเงิน',
                          style: TextStyle(fontSize: 20, color: Colors.green),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                              child: TextField(
                                controller: price,
                                style: const TextStyle(fontSize: 20),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  fillColor: Colors.red,
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10, 10, 0, 0),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    enterAmount = double.tryParse(value) ?? 0.0;
                                    p = double.parse(enterAmount.toString());
                                    t = double.parse(total.text);
                                    if (p! >= t!) {
                                      errorCheck = true;
                                      change.text = (p! - t!).toStringAsFixed(2);
                                    } else {
                                      errorCheck = false;
                                      change.text = '0.00';
                                    }
                                  });
                                },
                                onSubmitted: (value) {
                                  setState(() {
                                    price.text = enterAmount!.toStringAsFixed(2);
                                    p = double.parse(price.text);
                                    t = double.parse(total.text);
                                    if (p! >= t!) {
                                      errorCheck = true;
                                      change.text = (p! - t!).toStringAsFixed(2);
                                    } else {
                                      errorCheck = false;
                                      change.text = '0.00';
                                    }
                                  });
                                },
                                onTap: () {
                                  price.selection = TextSelection(
                                    baseOffset: 0,
                                    extentOffset: price.text.length,
                                  );
                                },
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(top: 10)),
                            errorCheck
                                ? Container()
                                : const Text(
                                    'ใส่จำนวนเงินให้ถูกต้อง',
                                    style: TextStyle(color: Colors.red),
                                  ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'เงินทอน',
                          style: TextStyle(fontSize: 20, color: Colors.pink),
                        ),
                        Container(
                          width: 150,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            change.text,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Padding(padding: EdgeInsets.only(left: 5)),
                        Container(
                          width: 20,
                          height: 20,
                          color: Colors.white,
                          child: Transform.scale(
                            scale: 1.5,
                            child: Checkbox(
                              value: credit,
                              activeColor: Colors.amber,
                              onChanged: (value) {
                                setState(() {
                                  credit = value!;
                                  if (!credit) {
                                    creditCard.clear();
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 20)),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              credit = !credit;
                              if (!credit) {
                                creditCard.clear();
                              }
                            });
                          },
                          child: const Text(
                            'บัตรเครดิต',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ),
                        credit
                            ? Container(
                                width: 100,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                child: TextField(
                                  controller: creditCard,
                                  maxLength: 4,
                                  style: const TextStyle(fontSize: 20),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(10, 10, 0, 0),
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      counterText: '',
                                      labelText: '4ตัวหลัง'),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * .11,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                color: Colors.pink[50],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*Container(
                      width: 90,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            /*money = 0.0;
                            price.text = money.toString();*/
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.purple[400]),
                        ),
                        child: const Text(
                          'Reset',
                          style: TextStyle(fontSize: 20),
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
                        onPressed: !errorCheck
                            ? null
                            : () {
                                setState(() {
                                  double vat = double.parse(total.text) * 0.07;
                                  double grand = double.parse(total.text) - vat;
                                  grandTotal = grand.toStringAsFixed(2);
                                  takeVat = vat.toStringAsFixed(2);
                                  double? percent;
                                  if (discount.text.isEmpty) {
                                    takePercent = '0.00';
                                  } else {
                                    percent = (double.parse(discount.text) /
                                            double.parse(
                                                widget.price.toString())) *
                                        100;
                                    takePercent = percent.toStringAsFixed(2);
                                  }
                                  if (!credit) {
                                    takeAccode = accList![0].accode;
                                    takeCreditCard = '';
                                    takeTotalCredit = '0.00';
                                  } else {
                                    takeAccode = accList![1].accode;
                                    takeCreditCard = creditCard.text;
                                    takeTotalCredit = total.text;
                                  }
                                  /*print('sellno => ${widget.billNo}');
                                  print('selldate => ${takeDate}');
                                  print('taxid => ${widget.taxid}');
                                  print('guidecode => ${widget.seat}');
                                  print('qtygood => ${widget.qtygood}');
                                  print('total => ${widget.price}');
                                  print('total_rec => ${price.text}');
                                  print('total_change => ${change.text}');
                                  print('total_dis => ${discount.text}');
                                  print('vat => ${takeVat}');
                                  print('grand => ${grandTotal}');
                                  print('creditcard => ${takeCreditCard}');
                                  print('flag => N');
                                  print('shopcode => ${widget.shopid}');
                                  print('location => ${widget.shopchar}');
                                  print('person => ');
                                  print('staffcode => ');
                                  print('sysdate =>$takeDatetime');
                                  print('cardtype => $takeAccode');
                                  print('accode => $takeAccode');
                                  print('saleuser => ${widget.username}');
                                  print('tot_cre => ${takeTotalCredit}');
                                  print('biil_type => ');
                                  print('percent => $takePercent');
                                  print('entcode => ');
                                  print('voucher => ');
                                  print('coupon => ');
                                  print('queue => ');
                                  print('tot_type => 0');*/
                                  saveFuture(context);
                                });
                              },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => !errorCheck
                                  ? Colors.pink[50]
                                  : Colors.pink[300]),
                        ),
                        child: const Text(
                          'Save',
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
      ),
    );
  }
}

class CreditCardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove any non-digit characters from the new value
    String cleanedText = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Ensure the length does not exceed 16 characters (12 digits + 3 dashes)
    if (cleanedText.length > 16) {
      cleanedText = cleanedText.substring(0, 16);
    }

    // Add dashes to the credit card number
    List<String> chunks = [];
    for (int i = 0; i < cleanedText.length; i += 4) {
      chunks.add(cleanedText.substring(i, i + 4));
    }
    final formattedText = chunks.join('-');

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
