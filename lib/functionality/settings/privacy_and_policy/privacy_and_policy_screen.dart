// ignore_for_file: deprecated_member_use

import 'package:chat_app_bloc/app_widget/app_appbar.dart';
import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: CustomeAppBar(
        backgroundColor: AppColor.whiteColor,
        elevation: 1,
        automaticallyImplyLeadings: true,
        leading: BackButton(
          color: AppColor.blackColor,
        ),
        titleWidget: Text(
          "Privacy Policy",
          style: GoogleFonts.poppins(
            color: AppColor.blackColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Header with last updated
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.06),
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Last Updated: February 19, 2026",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Your Privacy Matters",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "This Privacy Policy describes how we collect, use, and handle your information when you use our messaging services.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Main content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mainSection(
                      context: context,
                      title: "1. Information We Collect",
                      icon: Icons.info_outline,
                      content:
                          "We collect the following types of information to provide and improve our services:",
                      points: const [
                        "Account Information: Name, email address, phone number, and profile photo",
                        "Messages & Content: Text messages, images, files, and communication metadata",
                        "Device Information: Device model, operating system version, unique device identifiers",
                        "Usage Data: App features used, crash reports, performance metrics",
                        "Call Data: Audio/video call duration, quality metrics (no recording of content)",
                      ],
                    ),

                    const SizedBox(height: 32),

                    mainSection(
                      context: context,
                      title: "2. How We Use Firebase",
                      icon: Icons.cloud_queue,
                      content:
                          "Our app utilizes Firebase by Google for real-time messaging and data storage:",
                      points: const [
                        "Firebase Authentication: Securely manage user accounts and login sessions",
                        "Cloud Firestore: Store and sync messages in real-time across devices",
                        "Firebase Cloud Storage: Store shared images and files securely",
                        "Firebase Analytics: Understand app usage patterns to improve user experience",
                      ],
                      footnote:
                          "Firebase services are GDPR-compliant and use encryption both in transit and at rest.",
                    ),

                    const SizedBox(height: 32),

                    mainSection(
                      context: context,
                      title: "3. Audio & Video Calls with ZegoCloud",
                      icon: Icons.video_call,
                      content:
                          "For high-quality audio and video calls, we integrate ZegoCloud services:",
                      points: const [
                        "End-to-end encryption for all calls",
                        "No recording or storage of call content",
                        "Temporary connection data for call quality optimization",
                        "IP addresses are used only for establishing peer-to-peer connections",
                      ],
                      footnote:
                          "ZegoCloud complies with international security standards including ISO 27001.",
                    ),

                    const SizedBox(height: 32),

                    mainSection(
                      context: context,
                      title: "4. Legal Basis for Processing",
                      icon: Icons.gavel,
                      points: const [
                        "Contract Performance: To provide our messaging services",
                        "Legitimate Interests: Improve app functionality and security",
                        "Consent: For optional features and marketing communications",
                        "Legal Compliance: When required by applicable laws",
                      ],
                    ),

                    const SizedBox(height: 32),

                    mainSection(
                      context: context,
                      title: "5. Data Security",
                      icon: Icons.security,
                      content:
                          "We implement robust security measures to protect your information:",
                      points: const [
                        "256-bit encryption for messages in transit",
                        "Secure token-based authentication",
                        "Regular security audits and penetration testing",
                        "Immediate account lockout on suspicious activities",
                        "Compliant with GDPR, CCPA, and other privacy regulations",
                      ],
                    ),

                    const SizedBox(height: 32),

                    mainSection(
                      context: context,
                      title: "6. Your Rights & Choices",
                      icon: Icons.privacy_tip,
                      points: const [
                        "Access your personal data anytime",
                        "Export your data in portable format",
                        "Delete your account and associated data",
                        "Opt-out of analytics and crash reports",
                        "Manage notification preferences",
                      ],
                      footnote:
                          "To exercise your rights, visit Settings → Privacy or contact our Data Protection Officer.",
                    ),

                    const SizedBox(height: 32),

                    contactSection(context),

                    const SizedBox(height: 32),

                    // Company information footer
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "© 2026 Simple Chat. All rights reserved.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "This Privacy Policy was last modified on February 19, 2026. We may update this policy periodically and will notify you of any material changes.",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mainSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    String? content,
    List<String>? points,
    String? footnote,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (content != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 52),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (points != null) ...[
          ...points.map((point) => Padding(
                padding: const EdgeInsets.only(left: 52, bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6, right: 8),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        point,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
        if (footnote != null) ...[
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 52),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.06),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 0.5),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      footnote,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColor.blackColor.withOpacity(0.6),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget contactSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.001),
            isColorValidation(context) == Colors.black
                ? Colors.grey.withOpacity(0.3)
                : isColorValidation(context)
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.2), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.headset_mic,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Contact Our Privacy Team",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Have questions about your privacy? Our Data Protection Officer is here to help:",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                contactRow(
                  context: context,
                  icon: Icons.email,
                  label: "Email",
                  value: "privacy@simplechat.com",
                  isHighlighted: true,
                ),
                const Divider(height: 24),
                contactRow(
                  context: context,
                  icon: Icons.location_on,
                  label: "Address",
                  value: "123 Privacy Street, San Francisco, CA 94105",
                ),
                const Divider(height: 24),
                contactRow(
                  context: context,
                  icon: Icons.access_time,
                  label: "Response Time",
                  value: "Within 24 hours",
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     _buildContactChip(Icons.privacy_tip, "GDPR Compliant"),
          //     const SizedBox(width: 8),
          //     _buildContactChip(Icons.security, "ISO 27001"),
          //     const SizedBox(width: 8),
          //     _buildContactChip(Icons.verified, "CCPA Ready"),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget contactRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    bool isHighlighted = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      isHighlighted ? FontWeight.w600 : FontWeight.normal,
                  color: isHighlighted
                      ? Theme.of(context).primaryColor
                      : Colors.black87,
                ),
              ),
            ],
          ),
        ),
        if (isHighlighted)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "Copy",
              style: TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
