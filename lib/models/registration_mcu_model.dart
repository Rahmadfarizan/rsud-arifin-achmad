class RegisterMCUModel {
  String? name;
  String? phone;
  String? type;
  String? date;
  String? status;

  RegisterMCUModel({this.name, this.phone, this.type, this.date, this.status});

  RegisterMCUModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    type = json['type'];
    date = json['date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['type'] = type;
    data['date'] = date;
    data['status'] = status;
    return data;
  }

  RegisterMCUModel copyWith({
    String? name,
    String? phone,
    String? type,
    String? date,
    String? status,
  }) {
    return RegisterMCUModel(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      type: type ?? this.type,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }
}
