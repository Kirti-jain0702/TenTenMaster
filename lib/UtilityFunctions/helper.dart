import 'dart:math' show cos, sqrt, asin;

class Helper {
  static double calculateDistanceInMeters(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 1000;
  }

  static double formatDistance(double distance, String distanceMetric) {
    double divider = (distanceMetric.toLowerCase() == "km") ? 1000 : 1609.34;
    return distance / divider;
  }

  static String formatDistanceString(double distance, String distanceMetric) {
    double formatedDistance = Helper.formatDistance(distance, distanceMetric);
    return "${formatedDistance.toStringAsFixed(2)} $distanceMetric";
  }
}
