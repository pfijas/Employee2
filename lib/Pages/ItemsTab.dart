import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/Dinning.dart';
import '../Models/KOT.dart';
import '../Models/Provider/ReorderUsingProvider.dart';

class ItemsTab extends StatefulWidget {
  final int tabIndex;
  @override
  final List<Items>? items;
  final int? selectedCategoryId;
  final void Function(SelectedItems) onItemAdded;
  final void Function(double) removeItemCallback;


  const ItemsTab({super.key, 
    required this.tabIndex,
    this.items,
    this.selectedCategoryId,
    required this.onItemAdded,
    required this.removeItemCallback,
  });

  @override
  _ItemsTabState createState() => _ItemsTabState();
}

class _ItemsTabState extends State<ItemsTab> {
  int _sinoCounter = 0;
  List<SelectedItems> selectedItemsList = [];

  @override
  Widget build(BuildContext context) {
    final selectedItemsProvider = Provider.of<SelectedItemsProvider>(context,);

    if (widget.tabIndex == 2) {
      List<Items> selectedCatItems = (widget.items ?? [])
          .where((item) => item.catId == widget.selectedCategoryId)
          .toList();

      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 3.0,
          mainAxisSpacing: 3.0,
        ),
        itemCount: selectedCatItems.length,
        itemBuilder: (context, index) {
          return InkWell(
            // Inside the _ItemsTabState class
            onTap: () {
              setState(() {
                String itemName = selectedCatItems[index].name ?? '';
                double itemRate = selectedCatItems[index].sRate ?? 0.0;
                String printer = selectedCatItems[index].printer ?? '';
                int itemId = selectedCatItems[index].itemId ?? 0;
                double netAmount = itemRate * 1; // Adjust quantity calculation as needed
                SelectedItems selectedItems = SelectedItems(
                  name: itemName,
                  sRate: itemRate,
                  itemId: itemId,
                  quantity: 1,
                  itemtotal: 1 * itemRate,
                  NetAmount: netAmount, // Provide valid NetAmount here
                  extraNote: '',
                  SINO: '${++_sinoCounter}',
                  printer: printer,
                );
                selectedItemsProvider.addItemIntoSListee(selectedItems);
              });
            },
            child: Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          selectedCatItems[index].name ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Add more widgets here for additional details or actions
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      return const CircularProgressIndicator();
    }
  }
}



