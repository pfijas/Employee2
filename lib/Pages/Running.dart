import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import '../Models/Dinning.dart';
import '../Models/Provider/ReorderUsingProvider.dart';
import '../Models/Reorder.dart'; // Import Reorder model
import '../Utils/GlobalFn.dart';

class RunningTab extends StatefulWidget {
  final int tabIndex;
  final List<OrderList>? orderList;
  final List<Voucher>? voucher;
  final TabController tabController;
  final void Function(String, String) onOrderSelected; // Callback function

  const RunningTab({
    Key? key,
    required this.tabIndex,
    required this.orderList,
    required this.voucher,
    required this.tabController,
    required this.onOrderSelected,
  }) : super(key: key);

  @override
  _RunningTabState createState() => _RunningTabState();
}

class _RunningTabState extends State<RunningTab> {
  String? deviceId = "";
  List<Reorder> reorderList = [];
  List<KotData>reorderitems =[];


  @override
  void initState() {
    super.initState();
    _loadDataFromApi();
  }

  Future<void> _loadDataFromApi() async {
    await _loadOrderListFromApi();
  }

  Future<void> _loadOrderListFromApi() async {
    try {
      String? baseUrl = await fnGetBaseUrl();
      String apiUrl = '$baseUrl/api/Dinein/saveKOT?DeviceId=$deviceId';
      await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({}),
      );
    } catch (e) {
      print('Error calling saveKOT API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: widget.orderList?.length ?? 0,
        itemBuilder: (context, index) {
          final orderList = widget.orderList?[index];
          return GestureDetector(
            onDoubleTap: () {
              setState(() {
                final deletedId = widget.orderList?[index]?.id;
                widget.orderList?.removeAt(index);
                print('Deleted ID: $deletedId');
              });
            },
            child: Card(
              child: InkWell(
                onTap: () async {
                  SelectedItemsProvider selectedItemsProvider = Provider.of<SelectedItemsProvider>(context, listen: false);
                  String? tableName = orderList?.tableName;
                  String? chairIdList = orderList?.chairIdList;
                  int? issueCodeInt = orderList?.issueCode;
                  String? issueCode = issueCodeInt?.toString();
                  String? vno = orderList?.vNo;
                  String? ledCode = orderList?.ledcodeCr;

                  try {
                    String? baseUrl = await fnGetBaseUrl();
                    String apiUrl =
                        '$baseUrl/api/Dinein/getbyid?DeviceId=$deviceId&IssueCode=$issueCode&Vno=$vno&LedCode=$ledCode&VType=KOT';
                    final response = await http.get(
                      Uri.parse(apiUrl),
                      headers: {'Content-Type': 'application/json'},
                    );

                    if (response.statusCode == 200) {
                      final jsonResponse = json.decode(response.body);
                      final kotData = jsonResponse['Data']['KotData'];
                      print('KOT Data: $kotData');
                      if (kotData != null && kotData is Map<String, dynamic>) {
                        List<dynamic> kotItemsData = kotData['KotItems'] ?? [];
                        List<KotItem> kotItemList = kotItemsData.map((item) {
                          return KotItem.fromJson(item);
                        }).toList();

                        // Create ReOrderItems object with parsed data
                        KotData kotOrder = KotData(
                          mode: kotData['Mode'] ?? '',
                          deviceId: kotData['DeviceId'] ?? '',
                          issueCode: int.parse(issueCode ?? '0'),
                          vno: int.parse(vno ?? '0'),
                          ledCode: int.parse(ledCode ?? '0'),
                          vType: kotData['VType'] ?? '',
                          tableId: kotData['TableId'] ?? 0,
                          tableSeat: kotData['TableSeat'] ?? '',
                          employeeId: kotData['EmployeeId'] ?? 0,
                          totalAmount: kotData['TotalAmount']?.toDouble() ?? 0.0,
                          extraNote: kotData['ExtraNote'] ?? '',
                          kotItems: kotItemList,
                        );
                        print("kkkkkkkotorder  $kotOrder");
                        selectedItemsProvider.Runningitems(kotItemList);
                        selectedItemsProvider.RunningTabTbCh(tableName ?? '', chairIdList ?? '');
                        Provider.of<SelectedItemsProvider>(context, listen: false)
                            .UpdateselectedSeatIntoRunningTabTbCh();
                        Provider.of<SelectedItemsProvider>(context, listen: false)
                            .UpdateselectedItemsRtoS();
                        widget.tabController.animateTo(1);

                      } else {
                        print('Invalid KOT Data');
                      }
                    } else {
                      print('Failed to fetch order list from API. Status code: ${response.statusCode}');
                    }
                  } catch (e) {
                    print('Error: $e');
                  }
                },
                child: SizedBox(
                  height: 100,
                  child: ListTile(
                    title: Text(
                      orderList?.tableName ?? '',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ID: ${orderList?.tableId ?? ''}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
                        ),
                        Text(
                          'Time ${orderList?.timeAgo ?? ''}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
