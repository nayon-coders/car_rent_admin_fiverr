import 'dart:math';

import 'package:flutter/material.dart';

class AppDataTable extends StatelessWidget {
  final List<DataColumn>? columns;
  final DataTableSource data;

  AppDataTable({required this.columns, required this.data});



  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      source: data,
      columns: columns!,
      columnSpacing: 100,
      horizontalMargin: 10,
      rowsPerPage: 8,
      showCheckboxColumn: false,
    );
  }
}


// The "soruce" of the table
class AppDataTableSource extends DataTableSource {
  // Generate some made-up data
  final List<Map<String, dynamic>> _data = [];
  final List<DataCell> dataCells = [];
  AppDataTableSource({required List<Map<String, dynamic>> data}){
    _data.addAll(data);
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: dataCells);
  }
}