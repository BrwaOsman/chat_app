// ignore_for_file: non_constant_identifier_names

class MSG {
  String? messnger;
  String? name;
  String? date_time;
  String? id_sender;
  String? id_user;
  String? name_sender;

  MSG({this.messnger, this.name, this.date_time,this.id_sender,this.name_sender,this.id_user});

  factory MSG.fromMap(map) {
    return MSG(
      messnger: map['messnger'],
      name: map['name'],
      date_time: map['date_time'],
      id_sender: map['id_sender'],
      name_sender: map['name_sender'],
      id_user: map['id_user'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messnger': messnger,
      'name': name,
      'date_time': date_time,
      'name_sender':name_sender,
      'id_sender':id_sender,
      'id_user':id_user
    };
  }
}
