import 'package:ecommerce/data/DB_helper.dart';
import 'package:ecommerce/widget/setting/address/new_address.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/model/currentUser.dart'; // Import your CurrentUser model

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
    // Ensure the user is logged in
    if (CurrentUser().id == null) {
      // Handle user not logged in case
      print("User is not logged in.");
      return;
    }

    final addresses =
        await DatabaseHelper.dataService.getUserAddresses(CurrentUser().id!);
    setState(() {
      _addresses = addresses;
    });
  }

  void _refreshAddresses() {
    _loadAddresses();
  }

  Future<void> _deleteAddress(int id) async {
    await DatabaseHelper.dataService.deleteAddress(id);
    _refreshAddresses(); // Update the address list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh sách địa chỉ")),
      body: ListView.builder(
        itemCount: _addresses.length,
        itemBuilder: (context, index) {
          final address = _addresses[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black,width:1)
              ),
              
              child: ListTile(
                
                title: Text(address['address'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
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
                    // Confirm before deleting
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Xóa địa chỉ"),
                        content: Text("Bạn có chắc chắn muốn xóa địa chỉ này?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context), // Close dialog
                            child: Text("Hủy", style: TextStyle(color: Colors.black)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close dialog
                              _deleteAddress(address['id']); // Call delete method
                            },
                            child: Text(
                              "Xóa",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
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
