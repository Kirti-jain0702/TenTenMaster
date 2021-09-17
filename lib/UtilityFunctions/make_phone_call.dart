import 'package:url_launcher/url_launcher.dart';

Future<void> makePhoneCall(String mobileNumber) async {
  String url = 'tel:' + mobileNumber;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
