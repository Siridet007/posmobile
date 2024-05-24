class GetProduct {
  String? rowNum;
  String? cODESALE;
  String? nAMESALE;
  String? bARCODE;
  String? pRICESALE;
  String? pACK;
  String? dISCOUNT;
  String? eNAMESALE;
  String? rEDLABEL;

  GetProduct(
      {this.rowNum,
      this.cODESALE,
      this.nAMESALE,
      this.bARCODE,
      this.pRICESALE,
      this.pACK,
      this.dISCOUNT,
      this.eNAMESALE,
      this.rEDLABEL});

  GetProduct.fromJson(Map<String, dynamic> json) {
    rowNum = json['row_num'];
    cODESALE = json['CODESALE'];
    nAMESALE = json['NAMESALE'];
    bARCODE = json['BARCODE'];
    pRICESALE = json['PRICESALE'];
    pACK = json['PACK'] ?? '-';
    dISCOUNT = json['DISCOUNT'] ?? '0';
    eNAMESALE = json['ENAMESALE'];
    rEDLABEL = json['REDLABEL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['row_num'] = rowNum;
    data['CODESALE'] = cODESALE;
    data['NAMESALE'] = nAMESALE;
    data['BARCODE'] = bARCODE;
    data['PRICESALE'] = pRICESALE;
    data['PACK'] = pACK;
    data['DISCOUNT'] = dISCOUNT;
    data['ENAMESALE'] = eNAMESALE;
    data['REDLABEL'] = rEDLABEL;
    return data;
  }

  static List<GetProduct>? fromJsonList(List list) {
    //if (list == null) return null;
    return list.map((item) => GetProduct.fromJson(item)).toList();
  }
}

class GetProductNew {
  String? cODESALE;
  String? nAMESALE;
  String? bARCODE;
  String? pRICESALE;
  String? pACK;
  String? eNAMESALE;
  String? rEDLABEL;

  GetProductNew(
      {this.cODESALE,
      this.nAMESALE,
      this.bARCODE,
      this.pRICESALE,
      this.pACK,
      this.eNAMESALE,
      this.rEDLABEL});

  GetProductNew.fromJson(Map<String, dynamic> json) {
    cODESALE = json['CODESALE'];
    nAMESALE = json['NAMESALE'];
    bARCODE = json['BARCODE'];
    pRICESALE = json['PRICESALE'];
    pACK = json['PACK'];
    eNAMESALE = json['ENAMESALE'];
    rEDLABEL = json['REDLABEL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CODESALE'] = cODESALE;
    data['NAMESALE'] = nAMESALE;
    data['BARCODE'] = bARCODE;
    data['PRICESALE'] = pRICESALE;
    data['PACK'] = pACK;
    data['ENAMESALE'] = eNAMESALE;
    data['REDLABEL'] = rEDLABEL;
    return data;
  }

  static List<GetProductNew>? fromJsonList(List list) {
    //if (list == null) return null;
    return list.map((item) => GetProductNew.fromJson(item)).toList();
  }
}

class ReceiveProduct {
  String? code;
  String? name;
  String? qauntity;
  String? price;
  String? discount;
  //String? discountpercent;
  String? total;

  ReceiveProduct({
    this.code,
    this.name,
    this.qauntity,
    this.price,
    this.discount,
    //this.discountpercent,
    this.total,
  });

  ReceiveProduct.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    qauntity = json['qauntity'];
    price = json['price'];
    discount = json['discount'] ?? '0.00';
    //discountpercent = json['discountpercent'] ?? '0.00';
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['qauntity'] = qauntity;
    data['price'] = price;
    data['discount'] = discount;
    //data['discountpercent'] = discountpercent;
    data['total'] = total;
    return data;
  }

  static List<ReceiveProduct>? fromJsonList(List list) {
    //if (list == null) return null;
    return list.map((item) => ReceiveProduct.fromJson(item)).toList();
  }
}

class GetShopTrolley {
  String? idshop;
  String? shopchar;
  String? shopname;
  String? ipPrinter;
  String? taxid;

  GetShopTrolley(
      {this.idshop, this.shopchar, this.shopname, this.ipPrinter, this.taxid});

  GetShopTrolley.fromJson(Map<String, dynamic> json) {
    idshop = json['idshop'];
    shopchar = json['shopchar'];
    shopname = json['shopname'];
    ipPrinter = json['ip_printer'];
    taxid = json['taxid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idshop'] = idshop;
    data['shopchar'] = shopchar;
    data['shopname'] = shopname;
    data['ip_printer'] = ipPrinter;
    data['taxid'] = taxid;
    return data;
  }

  static List<GetShopTrolley>? fromJsonList(List list) {
    //if (list == null) return null;
    return list.map((item) => GetShopTrolley.fromJson(item)).toList();
  }
}

class GetAccMaster {
  String? accode;
  String? accName;

  GetAccMaster({this.accode, this.accName});

  GetAccMaster.fromJson(Map<String, dynamic> json) {
    accode = json['Accode'];
    accName = json['AccName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Accode'] = accode;
    data['AccName'] = accName;
    return data;
  }

  static List<GetAccMaster>? fromJsonList(List list) {
    //if (list == null) return null;
    return list.map((item) => GetAccMaster.fromJson(item)).toList();
  }
}

class GetDetail {
  String? saleno;
  String? salecode;
  String? quantity;
  String? unit;
  String? priceunit;
  String? total;
  String? vat;
  String? discount;
  String? updateDate;
  String? salename;
  String? deposit;
  String? disPercent;
  String? postflag;
  String? loadcons;

  GetDetail(
      {this.saleno,
      this.salecode,
      this.quantity,
      this.unit,
      this.priceunit,
      this.total,
      this.vat,
      this.discount,
      this.updateDate,
      this.salename,
      this.deposit,
      this.disPercent,
      this.postflag,
      this.loadcons});

  GetDetail.fromJson(Map<String, dynamic> json) {
    saleno = json['saleno'] ?? '';
    salecode = json['salecode'] ?? '';
    quantity = json['quantity'] ?? '';
    unit = json['unit'] ?? '';
    priceunit = json['priceunit'] ?? '';
    total = json['total'] ?? '';
    vat = json['vat'] ?? '';
    discount = json['discount'] ?? '';
    updateDate = json['update_date'] ?? '';
    salename = json['salename'] ?? '';
    deposit = json['deposit'] ?? '';
    disPercent = json['dis_percent'] ?? '';
    postflag = json['postflag'] ?? '';
    loadcons = json['loadcons'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['saleno'] = saleno;
    data['salecode'] = salecode;
    data['quantity'] = quantity;
    data['unit'] = unit;
    data['priceunit'] = priceunit;
    data['total'] = total;
    data['vat'] = vat;
    data['discount'] = discount;
    data['update_date'] = updateDate;
    data['salename'] = salename;
    data['deposit'] = deposit;
    data['dis_percent'] = disPercent;
    data['postflag'] = postflag;
    data['loadcons'] = loadcons;
    return data;
  }

  static List<GetDetail>? fromJsonList(List list) {
    //if (list == null) return null;
    return list.map((item) => GetDetail.fromJson(item)).toList();
  }
}

class GetSaleNo {
  String? saleno;

  GetSaleNo({this.saleno});

  GetSaleNo.fromJson(Map<String, dynamic> json) {
    saleno = json['saleno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['saleno'] = saleno;
    return data;
  }

  static List<GetSaleNo>? fromJsonList(List list) {
    //if (list == null) return null;
    return list.map((item) => GetSaleNo.fromJson(item)).toList();
  }
}

class GetSellDay {
  String? saleno;
  String? saledate;
  String? taxid;
  String? guidecode;
  String? qtygood;
  String? total;
  String? totRec;
  String? totChange;
  String? totDiscount;
  String? vat;
  String? grandTotal;
  String? idCard;
  String? flag;
  String? shopcode;
  String? location;
  String? personId;
  String? staffcode;
  String? sysdate;
  String? cardtype;
  String? accode;
  String? saleuser;
  String? totCreditcard;
  String? billtype;
  String? percentDiscount;
  String? entcode;
  String? voucher;
  String? coupon;
  String? queue;
  String? totType;

  GetSellDay(
      {this.saleno,
      this.saledate,
      this.taxid,
      this.guidecode,
      this.qtygood,
      this.total,
      this.totRec,
      this.totChange,
      this.totDiscount,
      this.vat,
      this.grandTotal,
      this.idCard,
      this.flag,
      this.shopcode,
      this.location,
      this.personId,
      this.staffcode,
      this.sysdate,
      this.cardtype,
      this.accode,
      this.saleuser,
      this.totCreditcard,
      this.billtype,
      this.percentDiscount,
      this.entcode,
      this.voucher,
      this.coupon,
      this.queue,
      this.totType});

  GetSellDay.fromJson(Map<String, dynamic> json) {
    saleno = json['saleno'];
    saledate = json['saledate'];
    taxid = json['taxid'];
    guidecode = json['guidecode'];
    qtygood = json['qtygood'];
    total = json['total'];
    totRec = json['tot_rec'];
    totChange = json['tot_change'];
    totDiscount = json['tot_discount'];
    vat = json['vat'];
    grandTotal = json['grand_total'];
    idCard = json['id_card'];
    flag = json['flag'];
    shopcode = json['shopcode'];
    location = json['location'];
    personId = json['person_id'];
    staffcode = json['staffcode'];
    sysdate = json['sysdate'];
    cardtype = json['cardtype'];
    accode = json['accode'];
    saleuser = json['saleuser'];
    totCreditcard = json['tot_creditcard'];
    billtype = json['billtype'];
    percentDiscount = json['percent_discount'];
    entcode = json['entcode'];
    voucher = json['voucher'];
    coupon = json['coupon'];
    queue = json['queue'];
    totType = json['tot_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['saleno'] = saleno;
    data['saledate'] = saledate;
    data['taxid'] = taxid;
    data['guidecode'] = guidecode;
    data['qtygood'] = qtygood;
    data['total'] = total;
    data['tot_rec'] = totRec;
    data['tot_change'] = totChange;
    data['tot_discount'] = totDiscount;
    data['vat'] = vat;
    data['grand_total'] = grandTotal;
    data['id_card'] = idCard;
    data['flag'] = flag;
    data['shopcode'] = shopcode;
    data['location'] = location;
    data['person_id'] = personId;
    data['staffcode'] = staffcode;
    data['sysdate'] = sysdate;
    data['cardtype'] = cardtype;
    data['accode'] = accode;
    data['saleuser'] = saleuser;
    data['tot_creditcard'] = totCreditcard;
    data['billtype'] = billtype;
    data['percent_discount'] = percentDiscount;
    data['entcode'] = entcode;
    data['voucher'] = voucher;
    data['coupon'] = coupon;
    data['queue'] = queue;
    data['tot_type'] = totType;
    return data;
  }

  static List<GetSellDay>? fromJsonList(List list) {
    //if (list == null) return null;
    return list.map((item) => GetSellDay.fromJson(item)).toList();
  }
}

class GetDetailDay {
  String? items;
  String? saleno;
  String? salecode;
  String? quantity;
  String? unit;
  String? priceunit;
  String? total;
  String? vat;
  String? discount;
  String? updateDate;
  String? salename;
  String? deposit;
  String? disPercent;
  String? postflag;
  String? loadcons;

  GetDetailDay(
      {this.items,
      this.saleno,
      this.salecode,
      this.quantity,
      this.unit,
      this.priceunit,
      this.total,
      this.vat,
      this.discount,
      this.updateDate,
      this.salename,
      this.deposit,
      this.disPercent,
      this.postflag,
      this.loadcons});

  GetDetailDay.fromJson(Map<String, dynamic> json) {
    items = json['items'];
    saleno = json['saleno'];
    salecode = json['salecode'];
    quantity = json['quantity'];
    unit = json['unit'];
    priceunit = json['priceunit'];
    total = json['total'];
    vat = json['vat'];
    discount = json['discount'];
    updateDate = json['update_date'];
    salename = json['salename'];
    deposit = json['deposit'];
    disPercent = json['dis_percent'];
    postflag = json['postflag'];
    loadcons = json['loadcons'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['items'] = items;
    data['saleno'] = saleno;
    data['salecode'] = salecode;
    data['quantity'] = quantity;
    data['unit'] = unit;
    data['priceunit'] = priceunit;
    data['total'] = total;
    data['vat'] = vat;
    data['discount'] = discount;
    data['update_date'] = updateDate;
    data['salename'] = salename;
    data['deposit'] = deposit;
    data['dis_percent'] = disPercent;
    data['postflag'] = postflag;
    data['loadcons'] = loadcons;
    return data;
  }

  static List<GetDetailDay>? fromJsonList(List list) {
    //if (list == null) return null;
    return list.map((item) => GetDetailDay.fromJson(item)).toList();
  }
}

class GetDetailDate {
  String? items;
  String? saleno;
  String? salecode;
  String? quantity;
  String? unit;
  String? priceunit;
  String? total;
  String? vat;
  String? discount;
  String? updateDate;
  String? salename;
  String? deposit;
  String? disPercent;
  String? postflag;
  String? loadcons;

  GetDetailDate(
      {this.items,
      this.saleno,
      this.salecode,
      this.quantity,
      this.unit,
      this.priceunit,
      this.total,
      this.vat,
      this.discount,
      this.updateDate,
      this.salename,
      this.deposit,
      this.disPercent,
      this.postflag,
      this.loadcons});

  GetDetailDate.fromJson(Map<String, dynamic> json) {
    items = json['items'];
    saleno = json['saleno'];
    salecode = json['salecode'];
    quantity = json['quantity'];
    unit = json['unit'];
    priceunit = json['priceunit'];
    total = json['total'];
    vat = json['vat'];
    discount = json['discount'];
    updateDate = json['update_date'];
    salename = json['salename'];
    deposit = json['deposit'];
    disPercent = json['dis_percent'];
    postflag = json['postflag'];
    loadcons = json['loadcons'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['items'] = items;
    data['saleno'] = saleno;
    data['salecode'] = salecode;
    data['quantity'] = quantity;
    data['unit'] = unit;
    data['priceunit'] = priceunit;
    data['total'] = total;
    data['vat'] = vat;
    data['discount'] = discount;
    data['update_date'] = updateDate;
    data['salename'] = salename;
    data['deposit'] = deposit;
    data['dis_percent'] = disPercent;
    data['postflag'] = postflag;
    data['loadcons'] = loadcons;
    return data;
  }

  static List<GetDetailDate>? fromJsonList(List list) {
    //if (list == null) return null;
    return list.map((item) => GetDetailDate.fromJson(item)).toList();
  }
}
