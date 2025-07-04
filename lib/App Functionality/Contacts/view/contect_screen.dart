import 'package:chat_app_bloc/App%20Functionality/Contacts/bloc/contact_bloc.dart';
import 'package:chat_app_bloc/App%20Functionality/Contacts/bloc/contact_event.dart';
import 'package:chat_app_bloc/App%20Functionality/Contacts/bloc/contact_state.dart';
import 'package:chat_app_bloc/App%20Functionality/Contacts/view/contect_details.dart';
import 'package:chat_app_bloc/Constent/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: AppColor.mainColor,
        centerTitle: true,
        title: const Text(
          "Contacts",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<PermissionStatus>(
        future: Permission.contacts.request(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data?.isGranted ?? false) {
              return BlocProvider(
                create: (context) => ContactBloc()..add(LoadContacts()),
                child: const ContactList(),
              );
            } else {
              return _buildPermissionDeniedView(context);
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildPermissionDeniedView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.contacts_outlined,
            size: 60,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          Text(
            "Contacts Permission Required",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Please grant contacts permission to view your contacts",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              await openAppSettings();
            },
            child: Text(
              "Open Settings",
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContactList extends StatelessWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactBloc, ContactState>(
      builder: (context, state) {
        if (state is ContactLoading) {
          return _buildShimmerEffect();
        } else if (state is ContactLoaded) {
          if (state.contacts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/file.png",
                    height: 120,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "No Contact Found in Device",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 204, 219, 207),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Text(
                            "You can Calls, Text Messages & Share Your Favorite Contacts here..",
                            style: GoogleFonts.alegreya(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Image.asset(
                          "assets/images/calling.png",
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<ContactBloc>().add(LoadContacts());
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.contacts.length,
                      itemBuilder: (context, index) {
                        Contact contact = state.contacts[index];
                        return _buildContactItem(contact, context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is ContactError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.error),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<ContactBloc>().add(LoadContacts());
                  },
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }
        return const Center(
          child: Text("No Contact Available"),
        );
      },
    );
  }

  Widget _buildContactItem(Contact contact, BuildContext context) {
    return ListTile(
      title: Text(
        contact.displayName,
        style: GoogleFonts.poppins(
            color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: contact.phones.isNotEmpty
          ? Text(
              contact.phones.first.number,
              style: GoogleFonts.poppins(
                  color: Colors.black, fontWeight: FontWeight.w500),
            )
          : const Text("No Phone Number"),
      leading: CircleAvatar(
        backgroundColor: AppColor.mainColor,
        child: Text(
          contact.displayName.isNotEmpty == true
              ? contact.displayName[0].toUpperCase()
              : "?",
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContactDetails(
              fLatter: contact.displayName.isNotEmpty == true
                  ? contact.displayName[0].toUpperCase()
                  : "?",
              contactName: contact.displayName,
              mobilenumber: contact.phones.isNotEmpty
                  ? contact.phones.first.number
                  : "N/A",
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerEffect() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Shimmer for the header container
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Shimmer for contact list
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Number of shimmer items to show
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 100,
                                height: 12,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
