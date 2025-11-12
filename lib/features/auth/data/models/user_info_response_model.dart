import 'user_model.dart';

class UserInfoResponseModel {
  final bool status;
  final UserModel data;

  UserInfoResponseModel({required this.status, required this.data});

  factory UserInfoResponseModel.fromJson(Map<String, dynamic> json) {
    return UserInfoResponseModel(
      status: json['status'] ?? false,
      data: UserModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'data': data.toJson()};
  }
}
