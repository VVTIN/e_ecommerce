import 'package:ecommerce/data/DB_helper.dart';
import 'package:ecommerce/widget/setting/address/new_address.dart';
import 'package:flutter/material.dart';

class AddressWidget extends StatefulWidget {
  const AddressWidget({super.key});

  @override
  State<AddressWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  List<Map<String, dynamic>> _addresses = [];

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final addresses = await DatabaseHelper.dataService.getAddresses();
    setState(() {
      _addresses = addresses;
    });
  }

  void _refreshAddresses() {
    _loadAddresses();
  }

  Future<void> _deleteAddress(int id) async {
    await DatabaseHelper.dataService.deleteAddress(id);
    _refreshAddresses(); // Gọi lại để cập nhật danh sách
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh sách địa chỉ")),
      body: ListView.builder(
        itemCount: _addresses.length,
        itemBuilder: (context, index) {
          final address = _addresses[index];
          return ListTile(
            title: Text(address['address']),
            subtitle: address['isDefault'] == 1 ? Text("Mặc định") : null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewAddress(
                    address: address,
                    onAddressChanged: _refreshAddresses,
                  ),
                ),
              );
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Xác nhận trước khi xóa
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Xóa địa chỉ"),
                    content: Text("Bạn có chắc chắn muốn xóa địa chỉ này?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context), // Đóng hộp thoại
                        child: Text("Hủy",style: TextStyle(color: Colors.black),),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Đóng hộp thoại
                          _deleteAddress(address['id']); // Gọi phương thức xóa
                        },
                        child: Text("Xóa",style: TextStyle(color: Colors.red),),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewAddress(
                onAddressChanged: _refreshAddresses,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
