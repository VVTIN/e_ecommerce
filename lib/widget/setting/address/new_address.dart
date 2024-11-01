import 'package:flutter/material.dart';
import '../../../data/DB_helper.dart';
import '../../../model/currentUser.dart'; // Import your CurrentUser model

class NewAddress extends StatefulWidget {
  final Map<String, dynamic>? address;
  final VoidCallback onAddressChanged;

  NewAddress({this.address, required this.onAddressChanged});

  @override
  _NewAddressState createState() => _NewAddressState();
}

class _NewAddressState extends State<NewAddress> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _addressController;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.address?['address']);
    _isDefault = widget.address?['isDefault'] == 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.address == null ? 'Thêm địa chỉ' : 'Chỉnh sửa địa chỉ')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Image(
                image: AssetImage('assets/images/Location search-bro.png'),
                fit: BoxFit.contain,
                height: 250),
            SizedBox(height: 20),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Địa chỉ',border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập địa chỉ' : null,
              ),
              SwitchListTile(
                title: Text("Thiết lập mặc định"),
                value: _isDefault,
                onChanged: (value) => setState(() => _isDefault = value),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newAddress = {
                      'address': _addressController.text,
                      'isDefault': _isDefault ? 1 : 0,
                    };

                    if (widget.address == null) {
                      // Adding a new address
                      await DatabaseHelper.dataService.addOrUpdateAddress(newAddress, setAsDefault: _isDefault);
                    } else {
                      // Updating an existing address
                      await DatabaseHelper.dataService.updateAddress(widget.address!['id'], newAddress);
                    }
                    
                    widget.onAddressChanged(); 
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.address == null ? 'Xác nhận' : 'Lưu thay đổi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
