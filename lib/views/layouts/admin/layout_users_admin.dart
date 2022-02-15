import 'package:fenua_contests/controllers/controller_admin_home_screen.dart';
import 'package:fenua_contests/helpers/styles.dart';
import 'package:fenua_contests/views/layouts/item_layouts/item_user.dart';
import 'package:fenua_contests/widgets/not_found.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import '../../../helpers/save_file_mobile.dart';
import '../../../models/user_info.dart';

class UsersLayoutAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AdminHomeScreenController controller =
        Get.find<AdminHomeScreenController>();

    return Scaffold(
      backgroundColor: appSecondaryColor,
      body: controller.usersList.length > 0
          ? ListView.builder(
              itemCount: controller.usersList.length,
              itemBuilder: (_, index) {
                return UserItem(
                  user: controller.usersList[index],
                );
              })
          : NotFound(message: "No users found"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (controller.usersList.length > 0) {
            _exportDataGridToExcel(controller.usersList);
          }
        },
        tooltip: "Export Data",
        child: Icon(Icons.save),
      ),
    );
  }

  Future<void> _exportDataGridToExcel(List<UserInfo> users) async {
    UsersDataSource usersDataSource = UsersDataSource(users: users);
    final excel.Workbook workbook = DataGridToExcelConverter()
        .exportToExcelWorkbook(
            SfDataGrid(
                source: UsersDataSource(users: users),
                columns: usersDataSource.columns),
            usersDataSource.rows);

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    if (GetPlatform.isWeb){
      await saveAndLaunchFile(bytes, "Users Data.xlsx");
    } else {

      if (GetPlatform.isAndroid){
        var status = await Permission.storage.status;
        if (status.isDenied || status.isRestricted) {
          await Permission.storage.request();
          return;
        } else if (status.isPermanentlyDenied){
          openAppSettings();
          return;
        }
      }
      await saveAndLaunchFile(bytes, 'Users Data.xlsx');
    }
  }
}

class UsersDataSource extends DataGridSource {
  List<UserInfo> users;
  var userData;

  UsersDataSource({
    required this.users,
  }) {
    userData = users
        .map((e) => DataGridRow(cells: <DataGridCell>[
              DataGridCell<String>(columnName: 'ID', value: e.id),
              DataGridCell<String>(
                  columnName: 'Full Name',
                  value: e.first_name + " " + e.last_name),
              DataGridCell<String>(columnName: 'Nickname', value: e.nickname),
              DataGridCell<String>(columnName: 'Email', value: e.email),
              DataGridCell<String>(columnName: 'Phone Number', value: e.phone),
              DataGridCell<String>(columnName: 'Date of Birth', value: e.age),
              DataGridCell<String>(columnName: 'City', value: e.city),
              DataGridCell<String>(
                  columnName: 'Term 1',
                  value: e.checked_0 ? "Accepted" : "Rejected"),
              DataGridCell<String>(
                  columnName: 'Term 2',
                  value: e.checked_1 ? "Accepted" : "Rejected"),
              DataGridCell<String>(
                  columnName: 'Term 3',
                  value: e.checked_2 ? "Accepted" : "Rejected"),
              DataGridCell<String>(columnName: 'Image Url', value: e.image_url),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => userData;

  List<GridColumn> get columns => [
        GridColumn(
            columnName: 'ID',
            label: Text(
              'ID',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        GridColumn(
            columnName: 'Full Name',
            label: Text(
              'Full Name',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        GridColumn(
            columnName: 'Nickname',
            label: Text(
              'Nickname',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        GridColumn(
            columnName: 'Email',
            label: Text(
              'Email',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        GridColumn(
            columnName: 'Phone Number',
            label: Text(
              'Phone Number',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        GridColumn(
            columnName: 'Date of Birth',
            label: Text(
              'Date of Birth',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        GridColumn(
            columnName: 'City',
            label: Text(
              'City',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        GridColumn(
            columnName: 'Term 1',
            label: Text(
              'Term 1',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        GridColumn(
            columnName: 'Term 2',
            label: Text(
              'Term 2',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        GridColumn(
            columnName: 'Term 3',
            label: Text(
              'Term 3',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        GridColumn(
            columnWidthMode: ColumnWidthMode.fitByCellValue,
            columnName: 'Image Url',
            label: Text(
              'Image Url',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
      ];

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((DataGridCell cell) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          cell.value.toString(),
          textAlign: TextAlign.center,
        ),
      );
    }).toList());
  }
}
