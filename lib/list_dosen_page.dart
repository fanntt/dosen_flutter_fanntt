import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'tambah_dosen.dart';
import 'update_dosen.dart';

class ListDosenPage extends StatefulWidget {
  @override
  _ListDosenPageState createState() => _ListDosenPageState();
}

class _ListDosenPageState extends State<ListDosenPage> {
  List<dynamic> dosenList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => isLoading = true);
    final response = await http.get(Uri.parse('http://192.168.176.234:8000/api/dosen'));
    if (response.statusCode == 200) {
      setState(() {
        dosenList = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data')),
      );
    }
  }

  Future<void> deleteDosen(int no) async {
    final response = await http.delete(Uri.parse('http://192.168.176.234:8000/api/dosen/$no'));
    if (response.statusCode == 200) {
      fetchData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil dihapus')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Dosen'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TambahDosenPage()),
              );
              fetchData();
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: dosenList.length,
        itemBuilder: (context, index) {
          final dosen = dosenList[index];
          return ListTile(
            title: Text(dosen['nama_lengkap'] ?? ''),
            subtitle: Text('${dosen['nip'] ?? ''}\n${dosen['email'] ?? ''}'),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UpdateDosenPage(dosen: dosen),
                      ),
                    );
                    fetchData();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteDosen(dosen['no']),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
