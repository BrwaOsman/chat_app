class MSG {
  String? messnger;
  String? name;
  String? date_time;

  MSG({this.messnger, this.name, this.date_time});

  factory MSG.fromMap(map) {
    return MSG(
      messnger: map['messnger'],
      name: map['name'],
      date_time: map['date_time'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messnger': messnger,
      'name': name,
      'date_time': date_time,
    };
  }
}
