import 'package:json_annotation/json_annotation.dart';
import 'package:simple_moment/simple_moment.dart';

part 'coupon.g.dart';

@JsonSerializable()
class Coupon {
  final int id;
  final String title;
  final String detail;
  final String code;
  final String type;
  final String expires_at;
  final double reward;
  final dynamic meta;

  String expiresAtFormatted;

  Coupon(this.id, this.title, this.detail, this.code, this.type,
      this.expires_at, this.reward, this.meta);

  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);

  Map<String, dynamic> toJson() => _$CouponToJson(this);

  void setup() {
    try {
      Moment expiresAt = Moment.parse(expires_at);
      if (isValid()) {
        expiresAtFormatted = expiresAt.format("dd MMM yyyy");
      } else {
        expiresAtFormatted = "expired";
      }
    } catch (e) {
      print("CouponSetup: $e");
      expiresAtFormatted = "expired";
    }
  }

  bool isValid() {
    try {
      Moment expiresAt = Moment.parse(expires_at);
      return expiresAt.date.millisecondsSinceEpoch >
          DateTime.now().millisecondsSinceEpoch;
    } catch (e) {
      print("isValid: $e");
      return false;
    }
  }
}
