import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateDosenPage extends StatefulWidget {
  final Map<String, dynamic> dosen;

  UpdateDosenPage({required this.dosen});

  @override
  _UpdateDosenPageState createState() => _UpdateDosenPageState();
}

class _UpdateDosenPageState extends State<UpdateDosenPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nipController;
  late TextEditingController _namaController;
  late TextEditingController _teleponController;
  late TextEditingController _emailController;
  late TextEditingController _alamatController;

  @override
  void initState() {
    super.initState();
    _nipController = TextEditingController(text: widget.dosen['nip'].toString());
    _namaController = TextEditingController(text: widget.dosen['nama_lengkap'] ?? '');
    _teleponController = TextEditingController(text: widget.dosen['no_telepon'].toString());
    _emailController = TextEditingController(text: widget.dosen['email'] ?? '');
    _alamatController = TextEditingController(text: widget.dosen['alamat'] ?? '');
  }

  Future<void> _updateData() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.put(
        Uri.parse('http://192.168.72.234:8000/api/dosen/${widget.dosen['no']}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nip': _nipController.text,
          'nama_lengkap': _namaController.text,
          'no_telepon': _teleponController.text,
          'email': _emailController.text,
          'alamat': _alamatController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data dosen berhasil diperbarui')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui data dosen')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Dosen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nipController,
                decoration: InputDecoration(labelText: 'NIP'),
                readOnly: true,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _teleponController,
                decoration: InputDecoration(labelText: 'No Telepon'),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Nomor telepon tidak boleh kosong' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? 'Email tidak boleh kosong' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(labelText: 'Alamat'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Alamat tidak boleh kosong' : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _updateData,
                child: Text('Perbarui'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
