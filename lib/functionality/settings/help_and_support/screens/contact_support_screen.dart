// ignore_for_file: prefer_final_fields, deprecated_member_use, use_build_context_synchronously

import 'package:chat_app_bloc/app_widget/app_snackbar.dart';
import 'package:chat_app_bloc/functionality/settings/help_and_support/models/contact_support_model.dart';
import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  InquiryType _selectedType = InquiryType.general;
  ContactMethod _selectedContactMethod = ContactMethod.email;
  bool _isSubmitting = false;
  List<String> _attachments = [];

  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Support"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildContactInfoCard(context),
              const SizedBox(height: 24),
              _buildInquiryForm(context),
              const SizedBox(height: 24),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "How can we help you?",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Fill out the form below and our support team will get back to you within 24 hours.",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfoCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.support_agent,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Support Hours",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Monday - Friday: 9:00 AM - 6:00 PM",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        "Saturday: 10:00 AM - 4:00 PM",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildContactMethod(
              context,
              icon: Icons.email,
              title: "Email Support",
              description: "simple.chat@support.com",
              onTap: () => _launchEmail("simple.chat@support.com"),
            ),
            const SizedBox(height: 12),
            _buildContactMethod(
              context,
              icon: Icons.phone,
              title: "Phone Support",
              description: "+91 9157084570",
              onTap: () => _launchPhone("+919157084570"),
            ),
            const SizedBox(height: 12),
            _buildContactMethod(
              context,
              icon: Icons.chat,
              title: "Live Chat",
              description: "Available during business hours",
              onTap: () => _startLiveChat(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactMethod(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: Colors.grey[700]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInquiryForm(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Send us a message",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Inquiry Type Dropdown
            DropdownButtonFormField<InquiryType>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: "Inquiry Type",
                prefixIcon: const Icon(Icons.category),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
              ),
              items: InquiryType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_getInquiryTypeName(type)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            // Subject Field
            TextFormField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: "Subject",
                hintText: "Brief summary of your issue",
                prefixIcon: const Icon(Icons.subject),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? "Please enter a subject" : null,
            ),
            const SizedBox(height: 16),
            // Message Field
            TextFormField(
              controller: _messageController,
              maxLines: 6,
              minLines: 4,
              decoration: InputDecoration(
                labelText: "Message",
                hintText: "Please describe your issue in detail...",
                prefixIcon: const Icon(Icons.message),
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? "Please enter your message" : null,
            ),
            const SizedBox(height: 16),
            // Preferred Contact Method
            const Text(
              "Preferred Contact Method",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: ContactMethod.values.map((method) {
                final isSelected = _selectedContactMethod == method;
                return ChoiceChip(
                  label: Text(_getContactMethodName(method)),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedContactMethod = method;
                    });
                  },
                  selectedColor: Theme.of(context).primaryColor,
                  backgroundColor: Colors.grey[100],
                  labelStyle: TextStyle(
                    color: isSelected
                        ? isColorValidation(context)
                        : Colors.grey[700],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // Attachments
            _buildAttachmentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Attachments (Optional)",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            AppSnackbar.info(context, "This feature will be available soon.");
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.attach_file,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "Add Attachment",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_attachments.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _attachments.map((attachment) {
              return Chip(
                label: Text(
                  attachment.split('/').last,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onDeleted: () {
                  setState(() {
                    _attachments.remove(attachment);
                  });
                },
                deleteIcon: const Icon(Icons.close, size: 16),
                backgroundColor: Colors.grey[100],
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitInquiry,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                "Submit Inquiry",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Future<void> _submitInquiry() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final now = DateTime.now();

      final inquiry = ContactInquiry(
        id: '',
        userId: _currentUser?.uid ?? '',
        userName: _currentUser?.displayName ??
            (_currentUser?.email?.split('@').first ?? 'User'),
        userEmail: _currentUser?.email ?? '',
        subject: _subjectController.text.trim(),
        message: _messageController.text.trim(),
        type: _selectedType,
        preferredContact: _selectedContactMethod,
        attachments: _attachments,
        createdAt: now,
        status: ContactStatus.pending,
        updatedAt: now,
      );

      // Save to Firebase with complete data
      final docRef = await FirebaseFirestore.instance
          .collection('contact_inquiries')
          .add(inquiry.toFirestore());

      // Update the document with its ID
      await docRef.update({
        'id': docRef.id,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Inquiry submitted successfully! We'll contact you soon.",
            style: TextStyle(fontSize: 14),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );

      // Clear form and go back
      _subjectController.clear();
      _messageController.clear();
      setState(() => _attachments.clear());

      // Wait a moment before popping
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> addAttachment() async {
    // Implement file picker here
    setState(() {
      _attachments
          .add('screenshot_${DateTime.now().millisecondsSinceEpoch}.png');
    });
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Support Request&body=Hello Support Team,',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _startLiveChat(BuildContext context) async {
    AppSnackbar.success(context,
        "Live Chat is available under Profile > Help Center > Technical Support. Please navigate there to continue.");
  }

  String _getInquiryTypeName(InquiryType type) {
    switch (type) {
      case InquiryType.general:
        return "General Inquiry";
      case InquiryType.technical:
        return "Technical Support";
      case InquiryType.feature:
        return "Feature Request";
      case InquiryType.complaint:
        return "Complaint";
      case InquiryType.other:
        return "Other";
    }
  }

  String _getContactMethodName(ContactMethod method) {
    switch (method) {
      case ContactMethod.email:
        return "Email";
      case ContactMethod.phone:
        return "Phone";
      case ContactMethod.chat:
        return "Live Chat";
      case ContactMethod.whatsapp:
        return "WhatsApp";
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
