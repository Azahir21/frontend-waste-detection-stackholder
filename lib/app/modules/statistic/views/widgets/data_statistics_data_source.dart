import 'package:flutter/material.dart';
import 'package:frontend_waste_management_stackholder/app/data/models/data_statistics_model.dart';

class DataStatisticDataTableSource extends DataTableSource {
  final List<DataStatistic> data;
  final int totalCount; // Must be the total number of records from the server

  DataStatisticDataTableSource({
    required this.data,
    required this.totalCount,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final row = data[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(row.id?.toString() ?? '-')),
        DataCell(Text(row.address ?? '-')),
        DataCell(Text(row.wasteCount?.toString() ?? '-')),
        DataCell(Text(row.captureTime != null
            ? row.captureTime!.toLocal().toString()
            : '-')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  /// **Important**: This must be the *total* count from the server, not just `data.length`.
  @override
  int get rowCount => totalCount;

  @override
  int get selectedRowCount => 0;
}
