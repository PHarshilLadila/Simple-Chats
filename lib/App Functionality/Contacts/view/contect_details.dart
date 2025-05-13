import 'package:chat_app_bloc/Constent/app_color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetails extends StatefulWidget {
  final String? fLatter;
  final String? mobilenumber;
  final String? contactName;
  const ContactDetails({
    super.key,
    this.fLatter,
    this.mobilenumber,
    this.contactName,
  });

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Tween<Offset> tweenController1 =
      Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0));
  Tween<Offset> tweenController2 =
      Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0));
  Tween<Offset> tweenController3 =
      Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0));
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _callContact(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber); // Use Uri.parse

    if (await canLaunchUrl(url)) {
      // Use canLaunchUrl
      await launchUrl(url);
    } else {
      debugPrint("=> Could not launch $url");
    }
  }

  void _messageContact(String phoneNumber) async {
    final Uri url = Uri(scheme: 'sms', path: phoneNumber); // Use Uri.parse

    if (await canLaunchUrl(url)) {
      // Use canLaunchUrl
      await launchUrl(url);
    } else {
      debugPrint("=> Could not launch $url");
    }
  }

  void launchWhatsapp() async {
    var whatsapp = "${widget.mobilenumber}";
    var whatsappAndroid =
        Uri.parse("whatsapp://send?phone=$whatsapp&text=hello");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   getcallLog();
  // }

  // Future<void> getcallLog() async {
  //   var now = DateTime.now();
  //   int from = now.subtract(const Duration(days: 60)).millisecondsSinceEpoch;
  //   int to = now.subtract(const Duration(days: 30)).millisecondsSinceEpoch;
  //   if (await Permission.phone.request().isGranted) {
  //     Iterable<CallLogEntry> entries = await CallLog.query(
  //       dateFrom: from,
  //       dateTo: to,
  //       durationFrom: 0,
  //       durationTo: 60,
  //       name: widget.contactName!,
  //       number: widget.contactName,
  //       type: CallType.incoming,
  //     );
  //     debugPrint("$entries");
  //   } else {
  //     debugPrint("Call Read Permission Denied");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white)),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.arrowLeft,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: AppColor.mainColor,
        centerTitle: true,
        title: const Text(
          "Contact Details",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(5, 2),
                                color: Color.fromARGB(255, 206, 206, 206),
                                blurRadius: 10),
                          ],
                          borderRadius: BorderRadius.circular(
                            10,
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Text(
                            widget.contactName ?? "",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget.mobilenumber ?? "",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SlideTransition(
                                position: _animationController
                                    .drive(tweenController1),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColor.mainColor,
                                      shape: BoxShape.circle),
                                  child: IconButton(
                                    onPressed: () {
                                      if (widget.mobilenumber!.isNotEmpty) {
                                        _callContact(widget.mobilenumber!);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "No phone number available")),
                                        );
                                      }
                                    },
                                    icon: const FaIcon(
                                      FontAwesomeIcons.phone,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              SlideTransition(
                                position: _animationController
                                    .drive(tweenController2),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle),
                                  child: IconButton(
                                    onPressed: () {
                                      if (widget.mobilenumber!.isNotEmpty) {
                                        _messageContact(widget.mobilenumber!);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "No phone number available")),
                                        );
                                      }
                                    },
                                    icon: const FaIcon(
                                      FontAwesomeIcons.solidMessage,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              SlideTransition(
                                position: _animationController
                                    .drive(tweenController3),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.blueGrey,
                                      shape: BoxShape.circle),
                                  child: IconButton(
                                    onPressed: () {
                                      String sharedetails =
                                          "Contact Name : ${widget.contactName!} \nContact Number : ${widget.mobilenumber!}";
                                      Share.share(sharedetails,
                                          subject: "Contact Details");
                                    },
                                    icon: const FaIcon(
                                      FontAwesomeIcons.share,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (BuildContext context, Widget? child) {
                      return Positioned(
                        top: 0,
                        left: 150,
                        child: Transform.scale(
                          scale: _animationController.value,
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 213, 230, 213),
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 225, 240, 225)),
                                child: Center(
                                  child: Text(
                                    widget.fLatter ?? "?",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          launchWhatsapp();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Whatsapp",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              FaIcon(
                                FontAwesomeIcons.whatsapp,
                                color: AppColor.mainColor,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Telegram",
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const FaIcon(
                              FontAwesomeIcons.telegram,
                              color: Colors.blue,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
