import 'package:flutter/foundation.dart';
import '../KOT.dart';
import '../Reorder.dart';
import 'dart:convert';


class SelectedItemsProvider with ChangeNotifier {
  final List<SelectedItems> selectedItemsListee = [];
  List<SelectedItems> get selectedItemsList => selectedItemsListee;
  List<SelectExtra> selectedExtras = [];
  int _sinoCounter = 1;
  String? selectedTableName;
  String? selectedChairIdList;
  Map<String, Set<String>> selectedSeats = {};
  List<KotItem> kotItemList = []; // Add kotItemList

  // Getter method to expose the computed value of DisplayTbSc
  String get DisplayTbSc {
    return selectedSeats.entries
        .where((entry) => entry.value.isNotEmpty)
        .map((entry) => '${entry.key}: ${entry.value.join(", ")}')
        .join(", ");
  }

  void updateSelectExtras(List<SelectExtra> updatedExtras) {
    selectedExtras = updatedExtras;
    notifyListeners();
  }

  void RunningTabTbCh(String tableName, String chairIdList) {
    selectedTableName = tableName;
    selectedChairIdList = chairIdList;
    notifyListeners();
  }

void Runningitems(List<KotItem> items){
  kotItemList = items;
    print("gggggggg$items");
}
  void UpdateselectedSeatIntoRunningTabTbCh() {
    // Check if selectedTableName and selectedChairIdList are not null
    if (selectedTableName != null && selectedChairIdList != null) {
      // Clear existing selectedSeats and add the new entry
      selectedSeats.clear();
      selectedSeats[selectedTableName!] = {selectedChairIdList!};
      notifyListeners(); // Notify listeners to update widgets consuming this provider
    }
  }
  void UpdateselectedItemsRtoS() {
    if (kotItemList.isNotEmpty) {
      // Clear existing selected items and add items from kotItemList
      selectedItemsListee.clear();

      for (KotItem item in kotItemList) {
        // Create a list to hold mapped addon items
        List<SelectExtra> mappedAddonItems = [];

        // Map addon items from KotItem to SelectExtra
        for (AddonItem addon in item.addonItems) {
          SelectExtra mappedAddon = SelectExtra(
            parentItemId: addon.parentItemId,
            itemId: addon.itemId,
            itemName: addon.name,
            sRate: addon.sRate,
            printer: '',
            qty: addon.quantity.toInt(),
            NetAmount: addon.NetAmount ?? 0.0, // Set default NetAmount if available
          );
          mappedAddonItems.add(mappedAddon);
        }

        // Create a SelectedItems instance and include mapped addon items
        SelectedItems selectedItem = SelectedItems(
          name: item.name,
          sRate: item.sRate,
          quantity:item.quantity.toInt(), // You can set default quantity here
          extraNote: '', // Assuming extraNote is a String property
          SINO: item.slNo.toString(),
          itemId: item.itemId,
          NetAmount: item.NetAmount ?? 0.0,
          printer: '', // Assuming printer is a String property
          itemtotal: 0.0, // Assuming itemtotal is a double property, set to 0.0 initially
          selectextra: mappedAddonItems, // Include mapped addon items
          // Add other properties as needed
        );
        // Add the constructed SelectedItems object to the list
        selectedItemsListee.add(selectedItem);
      }
      notifyListeners();
    }
  }

  void updateSelectedSeatsMap(Map<String, Set<String>> newSeatsMap) {
    selectedSeats = newSeatsMap;
    notifyListeners();
  }

//normal items using provider
  void addItemIntoSListee(SelectedItems newItem) {
    newItem.SINO = (++_sinoCounter).toString(); // Assign new SINO number
    selectedItemsListee.add(newItem);
    updateSinoNumbers();
 print("kkkkkkkkkkkkkkk$selectedItemsListee");
  }
// void RunningItems(ReOrderItems Runningitems){
//   RunningItemsListee.add(Runningitems);
// }


  void removeSelectedItem(String nameToRemove) {
    selectedItemsListee.removeWhere((item) => item.name == nameToRemove);
    updateSinoNumbers(); // Update SINO numbers after removing item
    notifyListeners();
  }

  void clearSelectedItemsclear() {
    selectedItemsListee.clear();
    selectedExtras.clear();
    selectedSeats.clear();
    notifyListeners();
  }

  void addSelectExtraList(SelectExtra extra) {
    selectedExtras.add(extra);
    notifyListeners();
  }

  void removeSelectExtra(SelectExtra selectedAddon) {
    selectedExtras.remove(selectedAddon);
    notifyListeners();
  }
  void updateSinoNumbers() {
    for (int i = 0; i < selectedItemsListee.length; i++) {
      selectedItemsListee[i].SINO = (i + 1).toString();
    }
    notifyListeners(); // Notify listeners of the change
  }
//
// void addSelectExtra(SelectExtra extra) {
//   selectedExtras.add(extra);
//   print("etraaaaaaaa$selectedExtras");
//   notifyListeners();
// }
}
