import 'dart:convert';
import 'package:chat_app_bloc/App%20Functionality/Chat%20Screen/view/image_view.dart';
import 'package:chat_app_bloc/Constent/app_color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AllImages extends StatefulWidget {
  final String? chatId;
  const AllImages({super.key, this.chatId});

  @override
  State<AllImages> createState() => _AllImagesState();
}

class _AllImagesState extends State<AllImages> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: AppColor.mainColor,
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white),
                  ),
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
            pinned: true,
            expandedHeight: 150.0,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text(
                'All Images',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          StreamBuilder(
            stream: firestore
                .collection('chatroom')
                .doc(widget.chatId!)
                .collection("chats")
                .where('isImage', isEqualTo: true)
                .orderBy("time", descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                      child: Text("No images yet.",
                          style: TextStyle(color: Colors.black))),
                );
              }

              // Grouping images by date
              Map<String, List<Map<String, dynamic>>> groupedImages = {};

              for (var doc in snapshot.data!.docs) {
                Map<String, dynamic> messages =
                    doc.data() as Map<String, dynamic>;
                Timestamp timestamp = messages['time'] as Timestamp;
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(timestamp.toDate());

                if (!groupedImages.containsKey(formattedDate)) {
                  groupedImages[formattedDate] = [];
                }
                groupedImages[formattedDate]!.add(messages);
              }
/*
📌 First Message (Date: 2025-02-25)

formattedDate = "2025-02-25";

if (!groupedImages.containsKey("2025-02-25")) {
    groupedImages["2025-02-25"] = []; // Creates empty list
}

// Now, add the message to the list:
groupedImages["2025-02-25"]!.add({ "image": "image1.png" });

📌 Resulting Map:

{
  "2025-02-25": [{ "image": "image1.png" }]
}

 */

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    String dateKey = groupedImages.keys.elementAt(
                        index); // retrive the list of date which are storein groupedimages
                    List<Map<String, dynamic>> images = groupedImages[dateKey]!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              DateFormat('MMMM dd, yyyy')
                                  .format(DateTime.parse(dateKey)),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200.0,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                              childAspectRatio: 1.0,
                              mainAxisExtent: 250,
                            ),
                            itemCount: images.length,
                            itemBuilder: (BuildContext context, int imgIndex) {
                              String imageUrl = images[imgIndex]['message'][0]
                                  .toString(); // images[0]['message'] , images[0]['message'][0]
                              Timestamp timestamp = images[imgIndex]['time']
                                  as Timestamp; // images[0]['time']  // Timestamp(seconds=1708838400, nanoseconds=0)

                              String formattedTime = DateFormat('hh:mm a')
                                  .format(timestamp.toDate());

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ImageView(imageUrl: imageUrl),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.teal[50 * (imgIndex % 8)],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.memory(
                                          base64Decode(imageUrl),
                                          fit: BoxFit.cover,
                                          height: 200,
                                          width: double.infinity,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          formattedTime,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: groupedImages.keys.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
