import 'dart:convert';

class Reorder{
  String tableName;
  String chairIdList;

  Reorder({
    required this.tableName,
    required this.chairIdList,
  });

  Map<String, dynamic> toJson() {
    return {
      'tableName':tableName,
      'ChairIdList':chairIdList,
    };
  }

  factory Reorder.fromJson(Map<String, dynamic> json) {
    return Reorder(
      tableName: json['TableName'],
      chairIdList: json['ChairIdList'],
    );
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}


class KotData {
  final String mode;
  final String? deviceId;
  final int issueCode;
  final int vno;
  final int ledCode;
  final String vType;
  final int tableId;
  final String tableSeat;
  final int employeeId;
  final double totalAmount;
  final String extraNote;
  final List<KotItem> kotItems;

  KotData({
    required this.mode,
    this.deviceId,
    required this.issueCode,
    required this.vno,
    required this.ledCode,
    required this.vType,
    required this.tableId,
    required this.tableSeat,
    required this.employeeId,
    required this.totalAmount,
    required this.extraNote,
    required this.kotItems,
  });

  factory KotData.fromJson(Map<String, dynamic> json) {
    // Parse 'KotItems' from the JSON map
    List<dynamic> kotItemsData = json['KotItems'] ?? [];
    List<KotItem> kotItemList = kotItemsData.map((item) {
      return KotItem.fromJson(item);
    }).toList();

    return KotData(
      mode: json['Mode'] ?? '',
      deviceId: json['DeviceId'],
      issueCode: json['IssueCode'],
      vno: json['Vno'],
      ledCode: json['LedCode'],
      vType: json['VType'] ?? '',
      tableId: json['TableId'],
      tableSeat: json['TableSeat'] ?? '',
      employeeId: json['EmployeeId'],
      totalAmount: json['TotalAmount']?.toDouble() ?? 0.0,
      extraNote: json['ExtraNote'] ?? '',
      kotItems: kotItemList,
    );
  }

  @override
  String toString() {
    return '{ mode: $mode, deviceId: $deviceId, issueCode: $issueCode, vno: $vno, ledCode: $ledCode, '
        'vType: $vType, tableId: $tableId, tableSeat: $tableSeat, employeeId: $employeeId, '
        'totalAmount: $totalAmount, extraNote: $extraNote, kotItems: $kotItems }';
  }
}

class KotItem {
  int slNo;
  int itemId;
  String name;
  double sRate;
  double NetAmount;
  List<AddonItem> addonItems;
  double quantity; // Add quantity field to KotItem

  KotItem({
    required this.slNo,
    required this.itemId,
    required this.name,
    required this.sRate,
    required this.NetAmount,
    required this.addonItems,
    required this.quantity,
  });

  factory KotItem.fromJson(Map<String, dynamic> json) {
    List<dynamic> addonItemsJson = json['AddonItems'] ?? [];
    List<AddonItem> addonItems = addonItemsJson.map((addonJson) => AddonItem.fromJson(addonJson)).toList();

    return KotItem(
      slNo: json['SlNo'] ?? 0,
      itemId: json['ItemId'] ?? 0,
      name: json['Name'] ?? '',
      sRate: json['SRate']?.toDouble() ?? 0.0,
      NetAmount: json['NetAmount']?.toDouble(),
      addonItems: addonItems,
      quantity: json['Qty']?.toDouble(), // Retrieve quantity from JSON
    );
  }

  @override
  String toString() {
    return 'KotItem ( slNo: $slNo, itemId: $itemId, name: $name, sRate: $sRate,quantity: $quantity,NetAmount:$NetAmount, addonItems: $addonItems, )';
  }
}

class AddonItem {
  final int parentItemId;
  final int itemId;
  final String name;
  final double sRate;
  final double NetAmount;
  final double quantity;

  AddonItem({
    required this.parentItemId,
    required this.itemId,
    required this.name,
    required this.sRate,
    required this.NetAmount,
    required this.quantity,
  });

  factory AddonItem.fromJson(Map<String, dynamic> json) {
    return AddonItem(
      parentItemId: json['ParentItemId'],
      itemId: json['ItemId'],
      name: json['Name'] ?? '',
      sRate: json['SRate']?.toDouble() ?? 0.0,
      NetAmount: json['NetAmount']?.toDouble(),
      quantity: json['Qty']?.toDouble() ?? 1.0,
    );
  }
  @override
  String toString() {
    return '{ parentItemId: $parentItemId, itemId: $itemId, name: $name, Qty: $quantity, NetAmount:$NetAmount, sRate: $sRate,}';
  }
}
