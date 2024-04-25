// import 'dart:convert';
// import 'package:employees/Models/Dinning.dart';
// import 'package:employees/Models/KOT.dart';
// import 'package:employees/Pages/Dashboard.dart';
// import 'package:employees/Pages/Running.dart';
// import 'package:employees/Utils/GlobalFn.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import '../Models/Itemname.dart';
// import '../Models/Provider/ReorderUsingProvider.dart';
// import '../Models/Reorder.dart';
// import '../Models/SettingsSave.dart';
// import 'Category.dart';
// import 'ItemsTab.dart';
// import 'Tables.dart';
//
// void main() => runApp(const MyApp());
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     return const MaterialApp(
//       home: Homepage(),
//     );
//   }
// }
//
// class Homepage extends StatefulWidget {
//   final String? employeeName;
//   final int? employeeId;
//
//   const Homepage({Key? key, this.employeeName, this.employeeId})
//       : super(key: key);
//
//   @override
//   State<Homepage> createState() => _HomepageState();
// }
//
// class _HomepageState extends State<Homepage>
//     with SingleTickerProviderStateMixin {
//   late TabController tabController;
//   String? DeviceId = "";
//   int selectedQuantity = 1;
//   SQLMessage? sqlMessage;
//   List<ExtraAddOn>? extraddon;
//   List<Category>? category;
//   List<Items>? items;
//   List<Voucher>? voucher;
//   Future<Dinning>? dinningData;
//   int? selectedCategoryId;
//   Map<String, List<String>> selectedAddonsMap = {};
//   final List<SelectedItems> selectedItemsListee = [];
//   List<SelectExtra> selectedExtraAddons = [];
//   KOT? kot;
//   List<KOT> kotList = [];
//   late List<DeviceInfo> deviceinfo;
//   Map<String, Set<String>> selectedSeats = {};
//   Map<String, Set<String>> selectedSeatsWithTableIdMap = {};
//   TextEditingController noteController = TextEditingController();
//   int _sinoCounter = 1;
//   List<OrderList>? orderlist=[];
//   String? selectedTableName;
//   String? selectedChairIdList;
//   List<Voucher>? voucherss;
//
//
//
//   void resetSinoCounter() {
//     setState(() {
//       _sinoCounter = 1; // Reset SINO counter
//       updateSinoNumbers(); // Reassign SINO numbers
//     });
//   }
//
//   void _updateSelectedOrder(String tableName, String chairIdList) {
//     setState(() {
//       selectedTableName = tableName;
//       selectedChairIdList = chairIdList;
//     });
//   }
//   void updateSinoNumbers() {
//     setState(() {
//       for (int i = 0; i < selectedItemsListee.length; i++) {
//         selectedItemsListee[i].SINO = (i + 1).toString();
//       }
//     });
//   }
//
//   void addItemToList(SelectedItems newItem) {
//     setState(() {
//       selectedItemsListee.add(newItem);
//       updateSinoNumbers(); // Update SINO numbers after adding item
//     });
//   }
//
//   void removeItemFromList(double itemId) {
//     setState(() {
//       selectedItemsListee.removeWhere((item) => item.itemId == itemId);
//       updateSinoNumbers(); // Update  SINO  numbers  after  removing  item
//     });
//   }
//
//   Widget buildSelectExtras(List<SelectExtra>? selectExtras) {
//     if (selectExtras == null || selectExtras.isEmpty) {
//       return const SizedBox.shrink();
//     } else {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           for (var selectedAddon in selectExtras)
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '${selectedAddon.itemName}(${selectedAddon.qty})' ?? '',
//                   style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
//                 ),
//                 const Spacer(),
//                 Text(
//                   '${selectedAddon.sRate}',
//                 ),
//                 const SizedBox(width: 65),
//                 Text(
//                   '${selectedAddon.sRate * (selectedAddon.qty ?? 0)}', // Calculate total as sRate * qty
//                 ),
//                 const SizedBox(width: 60),
//               ],
//             ),
//         ],
//       );
//     }
//   }
//
//   void updateSelectExtras(List<SelectExtra> newSelectExtras) {
//     setState(() {
//       selectedExtraAddons = newSelectExtras;
//     });
//   }
//
//   void removeItemFromItemsTab(double itemId) {
//     setState(() {
//       selectedItemsListee.removeWhere((item) => item.itemId == itemId);
//     });
//   }
//
//   void _handleSavePressed(Map<String, Set<String>> selectedSeatsMap) {
//     setState(() {
//       selectedSeats = selectedSeatsMap;
//       selectedSeatsWithTableIdMap = selectedSeatsMap;
//     });
//   }
//
//   void _handleClosePressed(
//       String tableName, Set<String> seats, String tableId) {
//     setState(() {
//       selectedSeats.remove(tableName);
//       selectedSeats.remove(tableId);
//       selectedSeatsWithTableIdMap.remove(tableId);
//       selectedSeatsWithTableIdMap.remove(tableName);
//     });
//   }
//
//   double OverallTotal() {
//     double overallTotal = 0.0;
//
//     // Calculate total for selected items
//     for (int i = 0; i < selectedItemsListee.length; i++) {
//       double rate = selectedItemsListee[i].sRate;
//       int quantity = selectedItemsListee[i].quantity;
//       double total = rate * quantity;
//       overallTotal += total;
//
//       // Calculate total for selected add-ons related to the item
//       for (var selectedAddon in selectedItemsListee[i].selectextra ?? []) {
//         double addonRate = selectedAddon.sRate ?? 0.0;
//         int addonQuantity = selectedAddon.qty ?? 0;
//         double addonTotal = addonRate * addonQuantity;
//         overallTotal += addonTotal;
//       }
//     }
//     return overallTotal; // Make sure the function returns a double
//   }
//
//   void showExtraAddonDialog(
//       BuildContext context,
//       List<ExtraAddOn> extraAddonList,
//       SelectedItems selectedItem,
//       ) {
//
//     List<SelectExtra> selectedExtraAddons = selectedItem.selectextra ?? [];
//     TextEditingController extraNoteController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             return AlertDialog(
//               title: Center(
//                   child: Column(
//                     children: [
//                       const Text('Extra Add-On'),
//                       TextField(
//                         controller: extraNoteController,
//                         decoration:
//                         const InputDecoration(hintText: "Type ExtraNote here"),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       )
//                     ],
//                   )),
//               content: SingleChildScrollView(
//                 child: Container(
//                   constraints: const BoxConstraints(maxHeight: 600),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       for (var extraAddon in extraAddonList)
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               var existingAddon =
//                               selectedExtraAddons.firstWhere(
//                                     (selected) =>
//                                 selected.itemName == extraAddon.name,
//                                 orElse: () => SelectExtra(
//                                   itemId: extraAddon.itemId as int ?? 0,
//                                   itemName: extraAddon.name ?? '',
//                                   sRate: extraAddon.sRate ?? 0.0,
//                                   parentItemId: selectedItem.itemId,
//                                   NetAmount: (extraAddon.sRate ?? 0.0),
//                                   printer: extraAddon.printer ?? '',
//                                 ),
//                               );
//
//                               if (selectedExtraAddons.contains(existingAddon)) {
//                                 existingAddon.qty =
//                                     (existingAddon.qty ?? 0) + 1;
//                                 existingAddon.NetAmount =
//                                     (existingAddon.qty ?? 0) *
//                                         (extraAddon.sRate ?? 0.0);
//                               } else {
//                                 selectedExtraAddons.add(
//                                   SelectExtra(
//                                     parentItemId: selectedItem.itemId,
//                                     itemId: extraAddon.itemId as int ?? 0,
//                                     itemName: extraAddon.name ?? '',
//                                     sRate: extraAddon.sRate ?? 0.0,
//                                     qty: 1,
//                                     NetAmount: (extraAddon.sRate ?? 0.0),
//                                     printer: extraAddon.printer ?? '', // Check for null
//                                   ),
//                                 );
//                               }
//                               selectedItem.selectextra =
//                                   selectedExtraAddons.toList();
//                             });
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(5.0),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(extraAddon.name ?? ''),
//                                 const Spacer(),
//                                 Text(' ${extraAddon.sRate ?? 0.0}'),
//                                 const SizedBox(height: 20),
//                               ],
//                             ),
//                           ),
//                         ),
//                       const SizedBox(height: 10),
//                       const Text(
//                         'Selected Add-Ons:',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       for (var selectedAddon in selectedExtraAddons)
//                         Row(
//                           children: [
//                             Text(selectedAddon.itemName ??
//                                 'Item Name Not Available'),
//                             Text('Qty: ${selectedAddon.qty ?? 0}'),
//                             const Spacer(),
//                             IconButton(
//                               icon: const Icon(Icons.delete),
//                               onPressed: () {
//                                 setState(() {
//                                   selectedExtraAddons.removeWhere(
//                                         (selected) =>
//                                     selected.itemName ==
//                                         selectedAddon.itemName,
//                                   );
//                                   selectedItem.selectextra =
//                                       selectedExtraAddons.toList();
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     setState(() {
//                       selectedItem.selectextra = selectedExtraAddons.toList();
//                       selectedItem.extraNote = extraNoteController.text;
//                     });
//                     updateSelectExtras(selectedExtraAddons);
//                     Navigator.of(context).pop();
//                     selectedItem.extraNote;
//                   },
//                   child: const Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//   @override
//   void initState() {
//     super.initState();
//     dinningData = fetchData2();
//     tabController = TabController(length: 4, vsync: this, initialIndex: 0);
//   }
//
//   Future<Dinning> fetchData2() async {
//     DeviceId = await fnGetDeviceId();
//     final String? baseUrl = await fnGetBaseUrl();
//     String apiUrl = '${baseUrl}api/Dinein/alldata';
//
//     try {
//       apiUrl = '$apiUrl?DeviceId=$DeviceId';
//       final response = await http.get(
//         Uri.parse(apiUrl),
//         headers: {'Content-Type': 'application/json'},
//       );
//       if (response.statusCode == 200) {
//         Dinning dinning = Dinning.fromJson(json.decode(response.body));
//         sqlMessage = dinning.data?.sQLMessage;
//
//         if (sqlMessage?.code == "200") {
//           extraddon = dinning.data?.extraAddOn;
//           category = dinning.data?.category;
//           items = dinning.data?.items;
//           voucher = dinning.data?.voucher;
//           orderlist = dinning.data?.orderlist;
//         }
//         return dinning;
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       print('Error: $e');
//       rethrow;
//     }
//   }
//   Map<String, double> itemRates = {};
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primarySwatch: Colors.blueGrey,
//           hintColor: Colors.black87,
//         ),
//         darkTheme: ThemeData(
//           brightness: Brightness.dark,
//         ),
//         home: Scaffold(
//           body: LayoutBuilder(
//               builder: (BuildContext context, BoxConstraints constraints) {
//                 bool isPortrait =
//                     MediaQuery.of(context).orientation == Orientation.portrait;
//                 return isPortrait ? buildPortraitLayout() : buildLandscapeLayout();
//               }),
//         ));
//   }
//
//   Widget buildPortraitLayout() {
//     SelectedItemsProvider selectedItemsProvider = Provider.of<SelectedItemsProvider>(context);
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.blueGrey,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () {
//               int currentIndex = tabController.index;
//               if (currentIndex == 0) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const Dashboardpage(),
//                   ),
//                 );
//               }
//             },
//           ),
//           title: Text(widget.employeeName ?? 'Homepage'),
//           centerTitle: true,
//           bottom: TabBar(
//             controller: tabController,
//             indicatorColor: Colors.white,
//             unselectedLabelColor: Colors.black87,
//             labelColor: Colors.white,
//             tabs: const [
//               Tab(text: "Tables"),
//               Tab(text: "CATEGORY"),
//               Tab(text: "ITEMS"),
//               Tab(text: "RUNNING"),
//             ],
//           ),
//         ),
//         body: FutureBuilder<Dinning>(
//           future: dinningData,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (snapshot.data == null || snapshot.data!.data == null) {
//               return const Center(
//                   child: Text(
//                       'No data available'));
//             } else {
//               Dinning dinning = snapshot.data!;
//               List<OrderList>? orderlist = dinning.data?.orderlist;
//               List<Tables>? tables = dinning.data?.tables;
//               List<Voucher>? voucher = dinning.data?.voucher;
//               return TabBarView(
//                 controller: tabController,
//                 children: [
//                   Center(
//                     child: TablesTab(
//                       tabIndex: 0,
//                       tables: tables,
//                       tabController: tabController,
//                       onSavePressed: _handleSavePressed,
//                       onClosePressed: _handleClosePressed,
//                       orderList: orderlist,
//                     ),
//                   ),
//                   Center(
//                     child: CategoryTab(
//                       category: category,
//                       tabIndex: 1,
//                       tabController: tabController,
//                       onCategorySelected: (categoryId) {
//                         setState(() {
//                           selectedCategoryId = categoryId;
//                         });
//                       },
//                     ),
//                   ),
//                   Center(
//                     child: ItemsTab(
//                       tabIndex: 2,
//                       items: items,
//                       selectedCategoryId: selectedCategoryId,
//                       onItemAdded: (SelectedItems newItem) {
//                         setState(() {
//                           // Assign SINO based on the current length of selectedItemsListee
//                           newItem.SINO =
//                               (selectedItemsListee.length + 1).toString();
//                           selectedItemsListee.add(newItem);
//                           // Increment SINO counter
//                           _sinoCounter++;
//                           // Update SINO for all items in selectedItemsListee
//                           updateSinoNumbers();
//                         });
//                       },
//                       removeItemCallback: (double itemId) {
//                         setState(() {
//                           // Remove the item from selectedItemsListee
//                           selectedItemsListee
//                               .removeWhere((item) => item.itemId == itemId);
//                           // Decrement SINO counter
//                           _sinoCounter--;
//                           // Update SINO for all items in selectedItemsListee
//                           updateSinoNumbers();
//                         });
//                       },
//                     ),
//                   ),
//                   Center(
//                     child: RunningTab(
//                       orderList: orderlist,
//                       tabIndex: 3,
//                       voucher: voucher,
//                       tabController: tabController,
//                       onOrderSelected: _updateSelectedOrder,
//                     ),
//                   )
//                 ],
//               );
//             }
//           },
//         ),
//         bottomNavigationBar: SingleChildScrollView(
//           child: Container(
//             child: Card(
//               color: Colors.white70,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     Row(
//                       children: [
//                         const Text(
//                           "KOT:",
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         const Spacer(),
//                         SizedBox(
//                           width: 400,
//                           child:
//                           Center(
//                             child: Consumer<SelectedItemsProvider>(
//                               builder: (context, provider, _) {
//                                 return Text(provider.DisplayTbSc,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),);
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Divider(thickness: 2, color: Colors.black87),
//                     SizedBox(
//                       width: double.infinity,
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Row(
//                                   children: [
//                                     SizedBox(
//                                       width: 20,
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.all(15.0),
//                                       child: Text(
//                                         "Item",
//                                         style: TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                     Spacer(),
//                                     Padding(
//                                       padding: EdgeInsets.all(5.0),
//                                       child: Text(
//                                         "Quadity",
//                                         style: TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.all(15.0),
//                                       child: Text(
//                                         "Rate",
//                                         style: TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 20,
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.all(15.0),
//                                       child: Text(
//                                         "Total",
//                                         style: TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(width: 50),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 280,
//                                   child: ListView.builder(
//                                     itemCount: selectedItemsProvider.selectedItemsList.length,
//                                     itemBuilder: (context, index) {
//                                       SelectedItems selectedItem = selectedItemsProvider.selectedItemsList[index];
//                                       return ListTile(
//                                         title: Row(
//                                           children: [
//                                             InkWell(
//                                               onTap: () {
//                                                 if (selectedItemsListee.isNotEmpty && index < selectedItemsListee.length) {
//                                                   SelectedItems selectedItem = selectedItemsListee[index];
//                                                   if (extraddon != null && extraddon!.isNotEmpty) {
//                                                     showExtraAddonDialog(
//                                                       context,
//                                                       extraddon!,
//                                                       selectedItem,
//                                                     );
//                                                   }
//                                                 }
//                                               },
//                                               child: SizedBox(
//                                                 width: 200,
//                                                 child: Text(
//                                                   selectedItem.name,
//                                                   overflow:
//                                                   TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             ),
//                                             const Spacer(),
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   right: 50),
//                                               child: SizedBox(
//                                                 width: 50,
//                                                 child: Center(
//                                                   child: DropdownButton<int>(
//                                                     value: selectedItem
//                                                         .quantity,
//                                                     // Use the selected quantity from the item
//                                                     onChanged:
//                                                         (int? newQuantity) {
//                                                       // Update the selected quantity if it is not null
//                                                       if (newQuantity != null) {
//                                                         setState(() {
//                                                           selectedItem
//                                                               .quantity =
//                                                               newQuantity;
//                                                           // Update the itemtotal based on the new quantity
//                                                           selectedItem
//                                                               .itemtotal =
//                                                               selectedItem
//                                                                   .sRate *
//                                                                   newQuantity;
//                                                         });
//                                                       }
//                                                     },
//                                                     items: List.generate(10,
//                                                             (index) {
//                                                           // Generate dropdown menu items for quantities 1 to 10
//                                                           return DropdownMenuItem<
//                                                               int>(
//                                                             value: index + 1,
//                                                             child: Text((index + 1)
//                                                                 .toString()),
//                                                           );
//                                                         }),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   right: 60),
//                                               child: Text(
//                                                   selectedItem.sRate.toString()),
//                                             ),
//                                             Text(
//                                                 selectedItem.itemtotal.toString(),
//                                                 style: const TextStyle(
//                                                     fontWeight:
//                                                     FontWeight.w700)),
//                                             const SizedBox(width: 10),
//                                             IconButton(
//                                               icon: const Icon(Icons.delete),
//                                               onPressed: () {
//                                                 setState(() {
//                                                   selectedExtraAddons
//                                                       .removeWhere(
//                                                         (selected) =>
//                                                     selected.itemName ==
//                                                         selectedItem
//                                                             .name,
//                                                   );
//                                                   selectedItem
//                                                       .selectextra =
//                                                       selectedExtraAddons
//                                                           .toList();
//                                                 });
//                                                 removeItemFromItemsTab(
//                                                     selectedItem
//                                                         .itemId
//                                                         .toDouble());
//                                               },
//                                             ),
//                                           ],
//                                         ),
//                                         subtitle: buildSelectExtras(
//                                             selectedItem
//                                                 .selectextra),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 40,
//                                   child: Row(
//                                     children: [
//                                       const Spacer(),
//                                       const Text("Total : ",
//                                           style: TextStyle(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold,
//                                           )),
//                                       const SizedBox(width: 5),
//                                       Text("${OverallTotal()}",
//                                           style: const TextStyle(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold,
//                                           )),
//                                       const SizedBox(
//                                         width: 80,
//                                       )
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       child: Row(
//                         children: [
//                           Card(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(17.0),
//                             ),
//                             elevation: 5,
//                             child: IconButton(
//                               iconSize: 30,
//                               icon: const Icon(
//                                 Icons.add,
//                               ),
//                               onPressed: () {},
//                             ),
//                           ),
//                           Card(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(17.0),
//                             ),
//                             elevation: 5,
//                             child: IconButton(
//                               iconSize: 30,
//                               icon: const Icon(
//                                 Icons.remove,
//                               ),
//                               onPressed: () {},
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 100,
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   return AlertDialog(
//                                     title: const Text("Enter Note"),
//                                     content: TextField(
//                                       controller: noteController,
//                                       decoration: const InputDecoration(
//                                           hintText: "Type your note here"),
//                                     ),
//                                     actions: <Widget>[
//                                       TextButton(
//                                         child: const Text("OK"),
//                                         onPressed: () {
//                                           Navigator.of(context)
//                                               .pop(); // Dismiss the dialog
//                                         },
//                                       ),
//                                     ],
//                                   );
//                                 },
//                               );
//                             },
//                             child: const Card(
//                               color: Colors.black87,
//                               child: Padding(
//                                 padding: EdgeInsets.all(15.0),
//                                 child: Text(
//                                   "NOTE",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const Spacer(),
//                           GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 final selectedItemsProvider =
//                                 Provider.of<SelectedItemsProvider>(context, listen: false);
//                                 selectedItemsProvider.clearSelectedItemsclear();
//                                 noteController.clear();
//                                 selectedSeats.clear();
//                                 selectedItemsListee.clear(); // Pass the index as a parameter
//                               });
//                             },
//                             child: const Card(
//                               color: Colors.black87,
//                               child: Padding(
//                                 padding: EdgeInsets.all(15.0),
//                                 child: Text(
//                                   "CLEAR",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 30,
//                           ),
//                           const Icon(Icons.print, size: 35),
//                           const SizedBox(
//                             width: 20,
//                           ),
//                           GestureDetector(
//                             onTap: () async {
//                               // Update SINO numbers after deletion
//                               setState(() {
//                                 _sinoCounter = 0;
//                                 selectedItemsListee.removeWhere(
//                                         (item) => item.itemId == items);
//                                 updateSinoNumbers();
//
//                                 for (var item in selectedItemsListee) {
//                                   item.SINO = '${++_sinoCounter}';
//                                 }
//                               });
//
//                               // Calculate total amount
//                               double totalAmount = OverallTotal();
//
//                               // Retrieve the ledId
//                               int? ledId = voucher?.first.ledId;
//
//                               // Convert employeeId to String
//                               String employeeIdString =
//                                   widget.employeeId?.toString() ?? '';
//
//                               // Retrieve tableIds and seats
//                               String seats = selectedSeats.values
//                                   .where((seats) => seats.isNotEmpty)
//                                   .map((seats) => seats.join(","))
//                                   .join(', ');
//                               String tableIds = selectedSeats.keys
//                                   .skip(1)
//                                   .where((key) => key.startsWith(RegExp(r'\d')))
//                                   .map((key) => key.replaceAll(
//                                   RegExp(r'[^a-zA-Z0-9]'), ''))
//                                   .join(', ');
//
//                               // Create KOT object
//                               KOT kotData = KOT(
//                                 Mode: 'I',
//                                 IssueCode: '345',
//                                 LedCode: '123',
//                                 Vtype: 'KOT',
//                                 EmployeeId: employeeIdString,
//                                 ExtraNote: noteController.text,
//                                 TableId: tableIds,
//                                 TableSeat: seats,
//                                 TotalAmount: totalAmount,
//                                 deviceId: DeviceId!,
//                                 Vno: '666',
//                                 Kotitems: selectedItemsListee,
//                               );
//
//                               try {
//                                 // Convert KOT data to JSON format
//                                 String kotJson = jsonEncode(kotData.toJson());
//                                 print("kkkkkkk$kotJson");
//                                 // Construct the API URL
//                                 String? baseUrl = await fnGetBaseUrl();
//                                 String apiUrl =
//                                     '$baseUrl/api/Dinein/saveKOT?DeviceId=$DeviceId';
//
//                                 // Make the POST request to the API
//                                 final response = await http.post(
//                                   Uri.parse(apiUrl),
//                                   headers: {'Content-Type': 'application/json'},
//                                   body: kotJson,
//                                 );
//
//                                 if (response.statusCode == 200) {
//                                   var jsonResponse = json.decode(response.body);
//                                   print(jsonResponse);
//                                 } else {
//                                   print(
//                                       'Failed to save KOT. Status code: ${response.statusCode}');
//                                 }
//                               } catch (e) {
//                                 print('Error: $e');
//                               }
//                             },
//                             child: const Card(
//                               color: Colors.black87,
//                               child: Padding(
//                                 padding: EdgeInsets.all(10.0),
//                                 child: Text(
//                                   "   KOT  ",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 20,
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ));
//   }
//
//   Widget buildLandscapeLayout() {
//     return Row(
//       children: [
//         Expanded(
//           child: Card(
//             color: Colors.white70,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   const Row(
//                     children: [
//                       Text(
//                         "KOT:",
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                   const Divider(thickness: 2, color: Colors.black87),
//                   SizedBox(
//                     width: double.infinity,
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Row(
//                                 children: [
//                                   Padding(
//                                     padding: EdgeInsets.only(
//                                         left: 20, right: 10, bottom: 0, top: 0),
//                                     child: Text(
//                                       "Item",
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                   Spacer(),
//                                   Padding(
//                                     padding: EdgeInsets.only(
//                                         left: 20, right: 20, bottom: 0, top: 0),
//                                     child: Text(
//                                       "Qty",
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.only(
//                                         left: 5, right: 10),
//                                     child: Text(
//                                       "Rate",
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.only(
//                                         left: 0, right: 0),
//                                     child: Text(
//                                       "Total",
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: 60),
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: 300,
//                                 child: ListView.builder(
//                                   itemCount: selectedItemsListee.length,
//                                   itemBuilder: (context, index) {
//                                     return ListTile(
//                                       title: Row(
//                                         children: [
//                                           InkWell(
//                                             onTap: () {
//                                               if (extraddon != null &&
//                                                   extraddon!.isNotEmpty) {
//                                                 SelectedItems selectedItem =
//                                                 selectedItemsListee[index];
//                                                 showExtraAddonDialog(
//                                                   context,
//                                                   extraddon!,
//                                                   selectedItem,
//                                                 );
//                                               }
//                                             },
//                                             child: SizedBox(
//                                               width: 130,
//                                               child: Text(
//                                                 selectedItemsListee[index].name,
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                             ),
//                                           ),
//                                           const Spacer(),
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 right: 10),
//                                             child: SizedBox(
//                                               width: 50,
//                                               child: Center(
//                                                 child: DropdownButton<int>(
//                                                   value:
//                                                   selectedItemsListee[index]
//                                                       .quantity,
//                                                   // Use the selected quantity from the item
//                                                   onChanged:
//                                                       (int? newQuantity) {
//                                                     // Update the selected quantity if it is not null
//                                                     if (newQuantity != null) {
//                                                       setState(() {
//                                                         selectedItemsListee[
//                                                         index]
//                                                             .quantity =
//                                                             newQuantity;
//
//                                                         // Update the itemtotal based on the new quantity
//                                                         selectedItemsListee[
//                                                         index]
//                                                             .itemtotal =
//                                                             selectedItemsListee[
//                                                             index]
//                                                                 .sRate *
//                                                                 newQuantity;
//                                                       });
//                                                     }
//                                                   },
//                                                   items: List.generate(10,
//                                                           (index) {
//                                                         // Generate dropdown menu items for quantities 1 to 10
//                                                         return DropdownMenuItem<
//                                                             int>(
//                                                           value: index + 1,
//                                                           child: Text((index + 1)
//                                                               .toString()),
//                                                         );
//                                                       }),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(
//                                             width: 10,
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 right: 10),
//                                             child: Text(
//                                                 selectedItemsListee[index].sRate.toString()),
//                                           ),
//                                           const SizedBox(
//                                             width: 5,
//                                           ),
//                                           Text(
//                                               selectedItemsListee[index].itemtotal.toString(),
//                                               style: const TextStyle(
//                                                   fontWeight: FontWeight.w700)),
//                                           IconButton(
//                                             icon: const Icon(Icons.delete),
//                                             iconSize: 23,
//                                             onPressed: () {
//                                               setState(() {
//                                                 selectedExtraAddons.removeWhere(
//                                                       (selected) =>
//                                                   selected.itemName ==
//                                                       selectedItemsListee[index]
//                                                           .name,
//                                                 );
//                                                 selectedItemsListee[index]
//                                                     .selectextra =
//                                                     selectedExtraAddons
//                                                         .toList();
//                                               });
//                                               removeItemFromItemsTab(
//                                                   selectedItemsListee[index]
//                                                       .itemId
//                                                       .toDouble());
//                                             },
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                               const Divider(),
//                               SizedBox(
//                                 height: 30,
//                                 child: Row(
//                                   children: [
//                                     const Spacer(),
//                                     const Text(
//                                       "Total : ",
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     Text(
//                                       "${OverallTotal()}",
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       width: 70,
//                                     )
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             SizedBox(
//                               height: 50,
//                               width: 50,
//                               child: Card(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(17.0),
//                                 ),
//                                 elevation: 5,
//                                 child: IconButton(
//                                   iconSize: 25,
//                                   icon: const Center(
//                                     child: Icon(
//                                       Icons.add,
//                                     ),
//                                   ),
//                                   onPressed: () {
//                                     // Implement your logic
//                                   },
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 50,
//                               width: 50,
//                               child: Card(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(17.0),
//                                 ),
//                                 elevation: 5,
//                                 child: IconButton(
//                                   iconSize: 25,
//                                   icon: const Center(
//                                     child: Icon(
//                                       Icons.remove,
//                                     ),
//                                   ),
//                                   onPressed: () {
//                                     // Implement your logic
//                                   },
//                                 ),
//                               ),
//                             ),
//                             const Spacer(),
//                             GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   selectedItemsListee.clear();
//                                 });
//                               },
//                               child: const Card(
//                                 color: Colors.black87,
//                                 child: Padding(
//                                   padding: EdgeInsets.all(12.0),
//                                   child: Text(
//                                     "CLEAR",
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             const Card(
//                               color: Colors.black87,
//                               child: Padding(
//                                 padding: EdgeInsets.all(10.0),
//                                 child: Text("NOTE",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white)),
//                               ),
//                             ),
//                             const Icon(Icons.print, size: 35),
//                             const SizedBox(
//                               width: 20,
//                             ),
//                             GestureDetector(
//                               onTap: () {},
//                               child: const Card(
//                                 color: Colors.black87,
//                                 child: Padding(
//                                   padding: EdgeInsets.all(10.0),
//                                   child: Text(
//                                     "   KOT  ",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 20,
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         SizedBox(
//           height: double.infinity,
//           width: 600,
//           child: Scaffold(
//             appBar: AppBar(
//               backgroundColor: Colors.blueGrey,
//               leading: IconButton(
//                 icon: const Icon(Icons.arrow_back),
//                 onPressed: () {
//                   int currentIndex = tabController.index;
//                   if (currentIndex == 0) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const Dashboardpage(),
//                       ),
//                     );
//                   }
//                 },
//               ),
//               title: Text(widget.employeeName ?? 'Homepage'),
//               centerTitle: true,
//               bottom: TabBar(
//                 controller: tabController,
//                 indicatorColor: Colors.white,
//                 unselectedLabelColor: Colors.black87,
//                 labelColor: Colors.white,
//                 tabs: const [
//                   Tab(text: "Tables"),
//                   Tab(text: "CATEGORY"),
//                   Tab(text: "ITEMS"),
//                 ],
//               ),
//             ),
//             body: Expanded(
//               child: FutureBuilder<Dinning>(
//                 future: dinningData,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (snapshot.data == null ||
//                       snapshot.data!.data == null) {
//                     return const Center(child: Text('No data available'));
//                   } else {
//                     Dinning dinning = snapshot.data!;
//                     List<Tables>? tables = dinning.data?.tables;
//
//                     return TabBarView(
//                       controller: tabController,
//                       children: [
//                         Center(
//                           child: TablesTab(
//                             tabIndex: 0,
//                             tables: tables,
//                             tabController: tabController,
//                             orderList: orderlist,
//                           ),
//                         ),
//                         Center(
//                           child: CategoryTab(
//                             category: category,
//                             tabIndex: 1,
//                             tabController: tabController,
//                             onCategorySelected: (categoryId) {
//                               setState(() {
//                                 selectedCategoryId = categoryId;
//                               });
//                             },
//                           ),
//                         ),
//                         Center(
//                           child: ItemsTab(
//                             tabIndex: 2,
//                             // key: itemsTabKey,
//                             items: items,
//                             selectedCategoryId: selectedCategoryId,
//                             onItemAdded: (SelectedItems newItem) {
//                               setState(() {
//                                 // Check if the item already exists in selectedItemsListee
//                                 // int existingIndex = selectedItemsListee.indexWhere(
//                                 //       (item) => item.itemId == newItem.itemId,
//                                 // );
//                                 // if (existingIndex != -1) {
//                                 //   // If the item exists, increase its quantity
//                                 //   selectedItemsListee[existingIndex].quantity += 1;
//                                 //   selectedItemsListee[existingIndex].itemtotal +=
//                                 //       selectedItemsListee[existingIndex].sRate;
//                                 //   selectedItemsListee[existingIndex].itemId;
//                                 //   selectedExtraAddons[existingIndex];
//                                 // } else {
//                                 // If the item doesn't exist, add a new item
//                                 selectedItemsListee.add(newItem);
//                                 print("sssssssssssssss$selectedItemsListee");
//                                 for (var selectedItem in selectedItemsListee) {
//                                   // print("Item ID: ${selectedItem.itemId}");
//                                 }
//                               });
//                             },
//                             removeItemCallback: (double itemId) {
//                               removeItemFromItemsTab(itemId);
//                             },
//                           ),
//                         ),
//                       ],
//                     );
//                   }
//                 },
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
