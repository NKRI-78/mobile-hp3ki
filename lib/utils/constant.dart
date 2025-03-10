import 'package:timeago/timeago.dart';

import 'package:hp3ki/data/models/language/language.dart';

class AppConstants {
  static const String baseUrl = 'https://api-hp3ki.inovatiftujuh8.com';
  static const String baseUrlFeed = switchToBaseUrlFeed;
  static const String baseUrlFeedV2 = 'https://api-forum-general.inovatiftujuh8.com';
  //static const String baseUrl = 'http://192.168.1.5:3007';
  static const String baseUrlDisbursementDenom = 'https://pg-$switchTo.connexist.id/disbursement/pub/v1/disbursement/denom';
  static const String baseUrlEcommerceDeliveryTimeslots = '$switchToBaseUrl/commerce-hp3ki/pub/v1/ninja/deliveryTimeSlots';
  static const String baseUrlDisbursementBank = 'https://pg-$switchTo.connexist.id/disbursement/pub/v1/disbursement/bank';
  static const String baseUrlDisbursementEmoney = 'https://pg-$switchTo.connexist.id/disbursement/pub/v1/disbursement/emoney';
  static const String baseUrlDisbursement = 'https://pg-$switchTo.connexist.id/disbursement/api/v1';
  static const String baseUrlImg = 'http://feedapi.connexist.id/d/f';
  static const String baseUrlChat = 'https://feedapi.connexist.id/api/v1/chat';
  static const String baseUrlFeedMedia = 'https://api-media-general.inovasi78.com/media-service/v1/upload';
  static const String baseUrlFeedImg = 'https://feedapi.connexist.id:7443/d/f';
  static const String baseUrlEcommerce = '$switchToBaseUrl/commerce-hp3ki/api/v1';
  static const String baseUrlPpob = 'https://api-pg.inovasi78.com';
  // static const String baseUrlPaymentGroupChannels = 'https://pg-$switchTo.connexist.id/payment/pub/v2/payment/groupedChannels';
  static const String baseUrlVa = 'https://pg-$switchTo.connexist.id/payment_v2/pub/v1/payment/channels';
  static const String baseUrlVaV1 = 'https://pg-$switchTo.connexist.id/payment/pub/v1/payment/channels';
  static const String baseUrlVaV2 = 'https://pg-$switchTo.connexist.id/payment/pub/v2/payment/channels';
  static const String baseUrlPaymentBilling = 'https://pg-$switchTo.connexist.id/payment/page/guidance';
  static const String baseUrlHelpPayment = 'https://web.inovasi78.com/payment/howTo';

  static const String baseUrlHelpInboxPayment = 'https://pg-$switchTo.connexist.id/payment/help/howto/trx';
  static const String baseUrlEcommercePickupTimeslots = '$switchToBaseUrl/commerce-hp3ki/pub/v1/ninja/pickupTimeSlots';
  static const String baseUrlEcommerceDimensionSize = '$switchToBaseUrl/commerce-hp3ki/pub/v1/ninja/dimensionSizes';
  static const String baseUrlEcommerceApproximatelyVolumes = '$switchToBaseUrl/commerce-hp3ki/pub/v1/ninja/pickupApproxVolumes';

  static const String switchTo = 'prod';
  static const String switchToBaseUrl = "https://smsapi.connexist.com:8443";
  static const String switchToBaseUrlFeed = "https://api-hp3ki.inovatiftujuh8.com";
  static const String switchToChatBaseUrl = "https://feedapi.connexist.id:5091";
  static const String xContextId = '898106017820';
  static const String mobileUa = 'Mozilla/5.0 (Linux; Android 7.0; SM-G930V Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.125 Mobile Safari/537.36';
  static const String productId = 'dfadf7e6-6a8d-4704-a082-9025289cb37e';

  // va prod https://pg-prod.sandbox.connexist.id/payment/pub/v1/payment/channels
  // va dev https://pg-sandbox.connexist.id/payment/pub/v1/payment/channels
  // feed prod https://feedapi.connexist.id/api/v1
  // feed dev https://apidev.cxid.xyz:7443/api/v1
  // e-commerce dev https://apidev.cxid.xyz:8443/commerce-mercyw204/api/v1
  // e-commerce prod https://smsapi.connexist.com:8443/commerce-mercyw204/api/v1

  // SharedPreferences
  static const String apiKeyGmaps = "AIzaSyCJD7w_-wHs4Pe5rWMf0ubYQFpAt2QF2RA";

  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String theme = 'theme';

  static const String avatarDebug = 'https://static.wikia.nocookie.net/jamescameronsavatar/images/e/e5/Avatar_TWoW_Neytiri_Textless_Poster.jpg/revision/latest?cb=20221125232909';
  static const String avatarError = 'https://icon-library.com/images/avatar-icon-png/avatar-icon-png-26.jpg';
  static const String tokenDebug = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1aWQiOiIyZjRmNTA4OC05NjFlLTRiNjItOWQ2MC0wODc3ZWQxZDI3YTMiLCJhdXRob3JpemVkIjp0cnVlLCJpYXQiOjE2ODUyNjU5MjN9.22shJq5CFh4jTBBDL84AAWurqkGoLmeBnVJCylTuKIk';

  static List<LanguageModel> languages = [
    LanguageModel(
        imageUrl: 'assets/icons/indonesia.png',
        languageName: 'Indonesia',
        countryCode: 'ID',
        languageCode: 'id'),
    LanguageModel(
        imageUrl: 'assets/icons/us.png',
        languageName: 'English',
        countryCode: 'US',
        languageCode: 'en'),
  ];
}

// Indonesian messages
class CustomLocalDate implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => 'yang lalu';
  @override
  String suffixFromNow() => 'dari sekarang';
  @override
  String lessThanOneMinute(int seconds) => '1 detik';
  @override
  String aboutAMinute(int minutes) => '1 menit';
  @override
  String minutes(int minutes) => '$minutes menit';
  @override
  String aboutAnHour(int minutes) => '1 jam';
  @override
  String hours(int hours) => '$hours jam';
  @override
  String aDay(int hours) => 'sehari';
  @override
  String days(int days) => '$days hari';
  @override
  String aboutAMonth(int days) => 'sekitar sebulan';
  @override
  String months(int months) => '$months bulan';
  @override
  String aboutAYear(int year) => 'sekitar setahun';
  @override
  String years(int years) => '$years tahun';
  @override
  String wordSeparator() => ' ';
}
