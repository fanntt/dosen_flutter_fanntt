class Dosen {
  int? id;
  String nama;
  String nidn;

  Dosen({this.id, required this.nama, required this.nidn});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nama': nama, 'nidn': nidn};
  }

  factory Dosen.fromMap(Map<String, dynamic> map) {
    return Dosen(id: map['id'], nama: map['nama'], nidn: map['nidn']);
  }
}
