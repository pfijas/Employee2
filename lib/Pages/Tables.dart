
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/Dinning.dart';
import '../Models/Provider/ReorderUsingProvider.dart';
import '../Utils/GlobalFn.dart';

class TablesTab extends StatefulWidget {
  final int tabIndex;
  final List<Tables>? tables;
  final TabController tabController;
  final List<OrderList>? orderList;
  final void Function(Map<String, Set<String>>)? onSavePressed;
  final void Function(String tableName, Set<String> seats, String tableId)?
  onClosePressed;
  final void Function(String tableName, Set<String> seats)?
  onSelectionChanged; // Callback to send selected data to parent widget
  const TablesTab({
    super.key,
    required this.tabIndex,
    required this.orderList,
    this.tables,
    required this.tabController,
    this.onSavePressed,
    this.onClosePressed,
    this.onSelectionChanged, // Initialize callback
  });

  @override
  _TablesTabState createState() => _TablesTabState();
}

class _TablesTabState extends State<TablesTab> {
  Map<String, Set<String>> selectedSeatsMap = {};
  String? DeviceId = "";

  @override
  Widget build(BuildContext context) {
    return widget.tabIndex == 0
        ? _buildTablesGrid()
        : Text("Content for Tab ${widget.tabIndex}");
  }

  Widget _buildTablesGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: widget.tables?.length ?? 0,
      itemBuilder: (context, index) {
        final table = widget.tables?[index];
        return _buildTableCard(table);
      },
    );
  }

  Future<void> loadAPISeats() async {
    try {
      String? baseUrl = await fnGetBaseUrl();
      String apiUrl = '$baseUrl/api/Dinein/alldata?DeviceId=$DeviceId';
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final orderList = jsonResponse['Data']['OrderList'];
        print('OrderList from API: $orderList');
      } else {
        print(
            'Failed to fetch order list from API. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    selectedSeatsMap.clear();
  }

  Widget _buildTableCard(Tables? table) {
    final cardColor = _getTableStatusColor(table?.tableStatus ?? '');
    final List<OrderList>? orderList = widget.orderList;

    return SizedBox(
      height: 1000,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                table?.tableName ?? '',
                style:
                const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Text(
                'TableId: ${table?.tableId ?? ''}', // Display TableId
                style:
                const TextStyle(fontSize: 6, fontWeight: FontWeight.w100),
              ),
              Text(
                'Capacity: ${table?.chair}',
                style:
                const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              Text(
                'Guest: ${table?.guest}',
                style:
                const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              _buildStatusButton(table, cardColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusButton(Tables? table, Color cardColor) {
    return InkWell(
      onTap: () => _buildPopupDialog(context, table),
      child: SizedBox(
        width: double.infinity,
        height: 25,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          color: cardColor,
          child: Center(
            child: Text(
              '${table?.tableStatus}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Color _getTableStatusColor(String status) {
    switch (status) {
      case 'Free':
        return Colors.green;
      case 'Full':
        return Colors.red;
      case 'Seated':
        return Colors.yellow;
      default:
        return Colors.white;
    }
  }

  void _buildPopupDialog(BuildContext context, Tables? table) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              '${table?.tableName ?? 'Select Seats'} - Table ID: ${table?.tableId ?? 'Unknown'}'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return SingleChildScrollView(
                child: Column(
                  children: List.generate(table?.chair ?? 0, (index) {
                    String seatName = 'S${index + 1}';
                    final String tableName = table?.tableName ?? 'Unknown table';
                    final String tableId = table?.tableId?.toString() ?? 'Unknown table';
                    bool isSelected = selectedSeatsMap[tableName]?.contains(seatName) ?? false;
                    // Check if orderList contains an order with matching tableName
                    bool CheckSeats = widget.orderList?.any((order) => order.tableName == tableName) ?? false;
                    // Determine which image to display based on ChairIdList presence
                    bool isSeatBooked = CheckSeats && widget.orderList!.any((order) => order.tableName == tableName && order.chairIdList!.contains(seatName));

                    String imagePath = isSeatBooked ? 'assets/images/Bookedseat.jpg' : 'assets/images/notbookedseat.jpg';

                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          // Check if the seat is already booked for this tableName
                          bool isSeatBooked = widget.orderList?.any((order) =>
                          order.tableName == tableName &&
                              order.chairIdList != null &&
                              order.chairIdList!.contains(seatName)) ??
                              false;
                          // Only proceed with seat selection/unselection if it's not part of a booked order
                          if (!isSeatBooked) {
                            bool isSelected = selectedSeatsMap[tableName]?.contains(seatName) ?? false;
                            if (isSelected) {
                              selectedSeatsMap[tableName]?.remove(seatName);
                              selectedSeatsMap[tableId]?.remove; // Remove from tableId map too
                            } else {
                              selectedSeatsMap[tableName] ??= Set<String>();
                              selectedSeatsMap[tableName]?.add(seatName);
                              selectedSeatsMap[tableId] ??= Set<String>();
                              selectedSeatsMap[tableId]?.add; // Add to tableId map too
                            }
                            // Notify parent widget about selection change
                            if (widget.onSelectionChanged != null) {
                              widget.onSelectionChanged!(tableName, selectedSeatsMap[tableName] ?? {});
                            }
                          }
                          setState(() {
                          print("Selected Seats: $selectedSeatsMap");
                            if(widget.onSavePressed!=null){
                              widget.onSavePressed!(selectedSeatsMap);
                            }
                            Provider.of<SelectedItemsProvider>(context,listen: false)
                            .updateSelectedSeatsMap(selectedSeatsMap);
                          });
                          // Print updated selectedSeatsMap with tableId included
                          print("Selected Seats: $selectedSeatsMap");
                        });
                      },


                      child:Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              (isSelected || isSeatBooked)
                                  ? 'assets/images/Bookedseat.jpg'
                                  : 'assets/images/notbookedseat.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                    );
                  }),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                setState(() {
                  final String tableName = table?.tableName ?? 'Unknown table';
                  final String tableId = table?.tableId?.toString() ?? 'Unknown table';
                  if (widget.onClosePressed != null) {
                    widget.onClosePressed!(
                      tableName,
                      selectedSeatsMap[tableName] ?? {},
                      tableId,
                    );
                  }
                  selectedSeatsMap.remove(tableName);
                  selectedSeatsMap.remove(tableId);
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  print("Selected Seats: $selectedSeatsMap");
                  if (widget.onSavePressed != null) {
                    widget.onSavePressed!(selectedSeatsMap);
                  }
                });
                Navigator.of(context).pop();
                widget.tabController.animateTo(widget.tabIndex + 1);
              },
            ),
          ],
        );
      },
    );
  }
}