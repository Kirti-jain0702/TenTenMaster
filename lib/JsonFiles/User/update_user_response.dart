import 'package:delivoo/JsonFiles/Auth/Responses/user_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_user_response.g.dart';

@JsonSerializable()
class UpdateUserResponse {
  final UserInformation data;

  UpdateUserResponse(this.data);

  factory UpdateUserResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserResponseToJson(this);
}
