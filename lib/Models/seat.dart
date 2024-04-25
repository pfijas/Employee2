class SelectedSeatsModel {
  final String tableId;
  final String tableName;
  final Set<String> selectedSeats;

  SelectedSeatsModel({
    required this.tableId,
    required this.tableName,
    required this.selectedSeats,
  });
}