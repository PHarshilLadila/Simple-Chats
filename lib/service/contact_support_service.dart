import 'package:chat_app_bloc/functionality/settings/help_and_support/models/contact_support_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ContactSupportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Submit contact inquiry
  Future<ContactInquiry?> submitInquiry(ContactInquiry inquiry) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final docRef = await _firestore.collection('contact_inquiries').add({
        ...inquiry.toFirestore(),
        'userId': user.uid,
        'userEmail': user.email,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update with ID
      await docRef.update({'id': docRef.id});

      // Return the created inquiry with ID
      return inquiry.copyWith(id: docRef.id);
    } catch (e) {
      debugPrint('Error submitting inquiry: $e');
      return null;
    }
  }

  // Get user's inquiries
  Stream<List<ContactInquiry>> getUserInquiries() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('contact_inquiries')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ContactInquiry.fromFirestore(doc))
          .toList();
    });
  }

  // Get single inquiry
  Future<ContactInquiry?> getInquiry(String inquiryId) async {
    try {
      final doc =
          await _firestore.collection('contact_inquiries').doc(inquiryId).get();

      if (doc.exists) {
        return ContactInquiry.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting inquiry: $e');
      return null;
    }
  }

  // Update inquiry status
  Future<bool> updateInquiryStatus(
      String inquiryId, ContactStatus status) async {
    try {
      await _firestore.collection('contact_inquiries').doc(inquiryId).update({
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      debugPrint('Error updating status: $e');
      return false;
    }
  }

  // Add response to inquiry
  Future<bool> addResponse(String inquiryId, String response) async {
    try {
      await _firestore.collection('contact_inquiries').doc(inquiryId).update({
        'response': response,
        'respondedAt': FieldValue.serverTimestamp(),
        'status': ContactStatus.resolved.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      debugPrint('Error adding response: $e');
      return false;
    }
  }
}
