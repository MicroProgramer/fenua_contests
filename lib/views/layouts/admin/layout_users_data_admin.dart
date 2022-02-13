import 'package:fenua_contests/controllers/controller_admin_home_screen.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/models/user_info.dart';
import 'package:fenua_contests/views/layouts/item_layouts/item_user.dart';
import 'package:fenua_contests/widgets/not_found.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:fenua_contests/helpers/save_file_mobile.dart';

class UsersLayoutAdmin extends StatelessWidget {
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();

  @override
  Widget build(BuildContext context) {
    AdminHomeScreenController controller =
    Get.find<AdminHomeScreenController>();

    return Scaffold(
      backgroundColor: appSecondaryColor,
      body:Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        tooltip: "Export Data",
        child: Icon(Icons.save),
      ),
    );
  }

  Future<void> _exportDataGridToExcel(List<UserInfo> users) async {
    UsersDataSource usersDataSource = UsersDataSource(users: users);
    final excel.Workbook workbook =
    DataGridToExcelConverter().exportToExcelWorkbook(usersDataSource.userData, usersDataSource.rows);

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    await saveAndLaunchFile(bytes, 'DataGrid.xlsx');
  }
}

class UsersDataSource extends DataGridSource {

  List<UserInfo> users;
  var userData;

  UsersDataSource({
    required this.users,
  }) {
    userData = users.map((e) =>
        DataGridRow(cells: <DataGridCell>[
          DataGridCell<String>(columnName: 'ID', value: e.id),
          DataGridCell<String>(
              columnName: 'Full Name', value: e.first_name + " " + e.last_name),
          DataGridCell<String>(columnName: 'Nickname', value: e.nickname),
          DataGridCell<String>(columnName: 'Email', value: e.email),
          DataGridCell<String>(columnName: 'Phone Number', value: e.phone),
          DataGridCell<String>(
              columnName: 'Date of Birth', value: e.age),
          DataGridCell<String>(columnName: 'City', value: e.city),
          DataGridCell<String>(columnName: 'Term 1',
              value: e.checked_0 ? "Accepted" : "Rejected"),
          DataGridCell<String>(columnName: 'Term 2',
              value: e.checked_1 ? "Accepted" : "Rejected"),
          DataGridCell<String>(columnName: 'Term 3',
              value: e.checked_2 ? "Accepted" : "Rejected"),
          DataGridCell<String>(columnName: 'Image Url', value: e.image_url),
        ])).toList();
  }


  @override
  List<DataGridRow> get rows => userData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((DataGridCell cell) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(cell.value.toString()),
          );
        }).toList());
  }

}