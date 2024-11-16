import 'package:flutter/material.dart';

Future<void> addProductDialog(
    BuildContext context,
    TextEditingController nameCtrl,
    TextEditingController imagesCtrl,
    TextEditingController descriptionCtrl,
    TextEditingController discountCtrl,
    Function(String name, String image, String description, int discount)
        onAddProduct) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          'Thêm sản phẩm',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.95,
          child: SingleChildScrollView(
            child: ListBody(
              children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: 'Tên sản phẩm',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: imagesCtrl,
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                    labelText: 'Ảnh sản phẩm (URL)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: descriptionCtrl,
                  decoration: InputDecoration(
                    labelText: 'Mô tả sản phẩm',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: discountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Giảm giá (%)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Hủy', style: TextStyle(color: Colors.black38)),
          ),
          TextButton(
            onPressed: () {
              String name = nameCtrl.text.trim();
              String image = imagesCtrl.text.trim();
              String description = descriptionCtrl.text.trim();
              int? discount = int.tryParse(discountCtrl.text.trim());

              // Kiểm tra đầu vào
              if (name.isEmpty) {
                _showErrorMessage(context, 'Tên sản phẩm không được để trống!');
                return;
              }
              if (image.isEmpty ) {
                _showErrorMessage(context, 'URL ảnh không hợp lệ!');
                return;
              }
              if (description.isEmpty) {
                _showErrorMessage(context, 'Mô tả không được để trống!');
                return;
              }
              if (discount == null || discount < 0 || discount > 100) {
                _showErrorMessage(context, 'Giảm giá phải là số từ 0 đến 100!');
                return;
              }

              // Gọi hàm thêm sản phẩm
              onAddProduct(name, image, description, discount);

              // Xóa dữ liệu form
              nameCtrl.clear();
              imagesCtrl.clear();
              descriptionCtrl.clear();
              discountCtrl.clear();

              // Hiển thị thông báo thành công
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Thêm sản phẩm thành công!')),
              );

              Navigator.pop(context);
            },
            child: Text('Thêm', style: TextStyle(color: Colors.black)),
          ),
        ],
      );
    },
  );
}

void _showErrorMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message, style: TextStyle(color: Colors.red))),
  );
}
