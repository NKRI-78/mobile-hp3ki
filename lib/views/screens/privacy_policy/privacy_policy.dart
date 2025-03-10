import 'package:flutter/material.dart';

import 'package:hp3ki/utils/color_resources.dart';
import 'package:hp3ki/utils/custom_themes.dart';
import 'package:hp3ki/utils/dimensions.dart';
import 'package:hp3ki/views/basewidgets/appbar/custom.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorResources.backgroundColor,
        appBar: buildAppBar(context),
        body: buildBodyContent());
  }

  AppBar buildAppBar(BuildContext context) {
    return const CustomAppBar(title: 'Kebijakan').buildAppBar(context);
  }

  SafeArea buildBodyContent() {
    return SafeArea(child: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          margin: const EdgeInsets.only(
              top: Dimensions.marginSizeDefault,
              left: Dimensions.marginSizeDefault,
              right: Dimensions.marginSizeDefault),
          child: Card(
            color: ColorResources.white,
            elevation: 2.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "PT Langit Digital 78 built the ASPRO app as a Free app. This SERVICE is provided by PT Langit Digital 78  at no cost and is intended for use as is.",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "This page is used to inform visitors regarding our policies regarding the collection, use, and disclosure of Personal Information if anyone decided to use our Service.",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy.",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which are accessible at ASPRO unless otherwise defined in this Privacy Policy.",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "Collection of your information",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "We may collect information you in a variety of ways. The information we may collect via the App depends on the content and materials you use, and includes :",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "Personal Data",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "We collect and store all personal information related to your App Profile, which you voluntarily give us either upon sign-up or through continued use of the App : ",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(
                            top: Dimensions.marginSizeSmall,
                            bottom: Dimensions.marginSizeSmall),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "• Profile Picture",
                              textAlign: TextAlign.justify,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                            Text(
                              "• E-mail Address",
                              textAlign: TextAlign.justify,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                            Text(
                              "• Company Name",
                              textAlign: TextAlign.justify,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                            Text(
                              "• No Member",
                              textAlign: TextAlign.justify,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                            Text(
                              "• Location",
                              textAlign: TextAlign.justify,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ],
                        )),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "Contact Information",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "We collect contact information, which you voluntarily give us to broadcast alert content",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "The app does use third-party services that may collect information used to identify you.",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "Link to the privacy policy of third-party service providers used by the app",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(
                            top: Dimensions.marginSizeSmall,
                            bottom: Dimensions.marginSizeSmall),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "• Google Play Services",
                              textAlign: TextAlign.justify,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ],
                        )),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "Log Data",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "We want to inform you that whenever you use our Service, in case of an error in the app we collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics.",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "This Service does not use these “cookies” explicitly. However, the app may use third-party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "Service Providers",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "We may employ third-party companies and individuals due to the following reasons:",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(
                            top: Dimensions.marginSizeSmall,
                            bottom: Dimensions.marginSizeSmall),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "• To facilitate our Service",
                              textAlign: TextAlign.justify,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                            Text(
                              "• To provide the Service on our behalf",
                              textAlign: TextAlign.justify,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                            Text(
                              "• To perform Service-related services; or",
                              textAlign: TextAlign.justify,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                            Text(
                              "• To assist us in analyzing how our Service is used.",
                              textAlign: TextAlign.justify,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: ColorResources.black,
                              ),
                            ),
                          ],
                        )),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "We want to inform users of this Service that these third parties have access to their Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "Security",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "Children’s Privacy",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "These Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13 years of age. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do the necessary actions.",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "Changes to This Privacy Policy",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page.",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "This policy is effective as of 2022-09-15",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "Contact Us",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: Dimensions.marginSizeSmall,
                          bottom: Dimensions.marginSizeSmall),
                      child: Text(
                        "If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at digital.78langit@gmail.com",
                        textAlign: TextAlign.justify,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: ColorResources.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ));
  }
}
