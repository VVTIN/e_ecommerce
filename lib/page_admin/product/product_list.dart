import 'package:ecommerce/controller/controller.dart';
import 'package:ecommerce/page_admin/product/product_add.dart';
import 'package:ecommerce/widget/products/loading/productLoadingGrid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../config/const.dart';
import '../../model/product.dart';
import '../../model/tag.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imagesController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Danh sách sản phẩm',
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (productController.isProductLoading.value) {
          return const ProductLoadingGrid();
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListView.builder(
              itemCount: productController.listProduct.length,
              itemBuilder: (context, index) {
                final product = productController.listProduct[index];
 // Kiểm tra nếu tag là null và thay thế giá trị mặc định là 0
                final productPrice = (product.tags.isNotEmpty && product.tags[0] != null)
                    ? product.tags[0].price
                    : 0;
                // Format the price
                final formattedPrice = NumberFormat.currency(
                  locale: 'vi_VN',
                  symbol: '',
                  decimalDigits: 0,
                ).format(productPrice);

                return Slidable(
                  endActionPane: ActionPane(
                    motion: BehindMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) => showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Xác nhận yêu cầu'),
                              content: Text('Bạn có chắc muốn xoá không?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Hủy',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    productController
                                        .deleteProduct(product.id!);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 70.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.red,
                                    ),
                                    child: Text(
                                      'Xóa',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        icon: Icons.delete,
                        backgroundColor: Colors.red,
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            baseUrl + product.images.first,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Giá: $formattedPrice VND',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.teal.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await addProductDialog(
            context,
            _nameController,
            _imagesController,
            _descriptionController,
            _discountController,
            (String name, String image, String description, int discount) {
              // Validate dữ liệu đầu vào
              if (name.isEmpty) {
                Get.snackbar('', "Tên sản phẩm không được để trống!");
                return;
              }
              if (image.isEmpty) {
                Get.snackbar('', "URL ảnh không hợp lệ!");
                return;
              }
              if (description.isEmpty) {
                Get.snackbar('', "Mô tả không được để trống!");
                return;
              }
              if (discount < 0 || discount > 100) {
                Get.snackbar('', "Giảm giá phải nằm trong khoảng 0-100%!");
                return;
              }
            
              // Tạo sản phẩm mới
              final newProduct = ProductModel(
                name: name,
                images: [image],
                description: description,
                discount: discount,
                tags: [],
              );

              // Gọi hàm thêm sản phẩm từ controller
              productController.createProduct(newProduct);

              // Hiển thị thông báo thành công
              Get.snackbar('', "Thêm sản phẩm thành công!");

              // Xóa dữ liệu trong các TextField
              _nameController.clear();
              _imagesController.clear();
              _descriptionController.clear();
              _discountController.clear();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
