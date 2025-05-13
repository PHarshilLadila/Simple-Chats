import 'package:chat_app_bloc/App%20Functionality/Contacts/bloc/contact_bloc.dart';
import 'package:chat_app_bloc/App%20Functionality/Contacts/bloc/contact_event.dart';
import 'package:chat_app_bloc/App%20Functionality/Contacts/bloc/contact_state.dart';
import 'package:chat_app_bloc/App%20Functionality/Contacts/view/contect_details.dart';
import 'package:chat_app_bloc/Constent/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:google_fonts/google_fonts.dart';

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
      body: BlocProvider(
        create: (context) => ContactBloc()..add(LoadContacts()),
        child: const ContactList(),
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
          return const Center(
            child: CircularProgressIndicator(),
          );
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
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.contacts.length,
                    itemBuilder: (context, index) {
                      Contact contact = state.contacts[index];

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
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )
                            : const Text("No Phone Number"),
                        leading: CircleAvatar(
                          backgroundColor: AppColor.mainColor,
                          child: Text(
                            contact.displayName.isNotEmpty == true
                                ? contact.displayName[0].toUpperCase()
                                : "?",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
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
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (state is ContactError) {
          return Center(
            child: Text(state.error),
          );
        }
        return const Center(
          child: Text("No Contact Available"),
        );
      },
    );
  }
}
