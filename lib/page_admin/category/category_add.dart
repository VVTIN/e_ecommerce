import 'package:flutter/material.dart';

Future<void> showAddCategoryDialog(
  BuildContext context,
  TextEditingController nameController,
  TextEditingController imagesController,
  Function(String name, int images) onAddCategory,
) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Thêm Danh Mục Mới',
            style: Theme.of(context).textTheme.headlineMedium),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.95, 
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Tên Danh Mục',
                      border: OutlineInputBorder(),
                  ),
                  
                ),
                SizedBox(height: 10),
                TextField(
                  controller: imagesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Hình Ảnh',
                      border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Hủy', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Thêm', style: TextStyle(color: Colors.black)),
            onPressed: () {
              String name = nameController.text.trim();
              int images = int.tryParse(imagesController.text.trim()) ?? 0;
              if (name.isNotEmpty && images > 0) {
                onAddCategory(name, images);

                nameController.clear();
                imagesController.clear();
                Navigator.of(context).pop();
              } else {
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
