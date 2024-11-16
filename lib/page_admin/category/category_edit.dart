import 'package:flutter/material.dart';

Future<void> showCategoryDetailDialog(
    BuildContext context, String name, int images) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button to close dialog
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Chi tiết danh mục'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Tên Danh Mục: $name'),
              Text('Số Lượng Hình Ảnh: $images'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Đóng'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showEditCategoryDialog(
  BuildContext context,
  TextEditingController nameController,
  TextEditingController imagesController,
  Function(String name, int images) onSaveCategory,
) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button to close dialog
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Chỉnh sửa danh mục'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Tên Danh Mục',
                ),
              ),
              TextField(
                controller: imagesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Số Lượng Hình Ảnh',
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Hủy'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Lưu'),
            onPressed: () {
              String name = nameController.text.trim();
              int images = int.tryParse(imagesController.text.trim()) ?? 0;
              if (name.isNotEmpty && images > 0) {
                onSaveCategory(name, images);
                // Clear the input fields
                nameController.clear();
                imagesController.clear();
                Navigator.of(context).pop();
              } else {
                // Show error message if inputs are invalid
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Vui lòng điền đầy đủ thông tin!'),
                ));
              }
            },
          ),
        ],
      );
    },
  );
}
