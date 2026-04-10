import 'package:chat_app_bloc/app_widget/app_snackbar.dart';
import 'package:chat_app_bloc/functionality/settings/help_and_support/models/app_version_model.dart';
import 'package:chat_app_bloc/service/app_version_service.dart';
import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  PackageInfo? _packageInfo;
  DeviceInfo? _deviceInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    setState(() => _isLoading = true);

    try {
      _packageInfo = await AppVersionService.getCurrentAppVersion();
      _deviceInfo = await AppVersionService.getDeviceInfo();
    } catch (e) {
      debugPrint('Error loading app info: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: _shareApp,
            icon: const Icon(Icons.share),
            tooltip: 'Share App',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildAppLogo(),
                  const SizedBox(height: 20),
                  _buildAppInfo(),
                  const SizedBox(height: 12),
                  _buildDeveloperInfo(),
                  const SizedBox(height: 12),
                  _buildSocialLinks(),
                  const SizedBox(height: 12),
                  // _buildLegalInfo(),
                  // const SizedBox(height: 24),
                  _buildVersionInfo(),
                  const SizedBox(height: 12),
                  _buildCopyright(),
                ],
              ),
            ),
    );
  }

  Widget _buildAppLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.chat_bubble_outline,
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAppInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              _packageInfo?.appName ?? 'Chat App',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Version ${_packageInfo?.version} (Build ${_packageInfo?.buildNumber})',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'A modern, secure, and feature-rich messaging application that keeps you connected with your loved ones. Experience seamless communication with real-time messaging, voice calls, video calls, and much more.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeveloperInfo() {
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
            Row(
              children: [
                Icon(
                  Icons.code,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Developer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildDeveloperRow('Company', 'Simple Chat Solutions'),
            _buildDeveloperRow('Developer', 'John Doe'),
            _buildDeveloperRow('Email', 'developer@simplechat.com'),
            _buildDeveloperRow('Website', 'www.simplechat.com'),
          ],
        ),
      ),
    );
  }

  Widget _buildDeveloperRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinks() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialButton(
                  icon: Icons.web,
                  label: 'Website',
                  onTap: () => _launchUrl('https://www.simplechat.com'),
                  color: Colors.blue,
                ),
                _buildSocialButton(
                  icon: Icons.email,
                  label: 'Email',
                  onTap: () => _launchEmail('support@simplechat.com'),
                  color: Colors.red,
                ),
                _buildSocialButton(
                  icon: Icons.facebook,
                  label: 'Facebook',
                  onTap: () => _launchUrl('https://facebook.com/simplechat'),
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialButton(
                  icon: Icons.telegram,
                  label: 'Telegram',
                  onTap: () => _launchUrl('https://t.me/simplechat'),
                  color: Colors.blue,
                ),
                _buildSocialButton(
                  icon: Icons.message,
                  label: 'Discord',
                  onTap: () => _launchUrl('https://discord.gg/simplechat'),
                  color: Colors.purple,
                ),
                _buildSocialButton(
                  icon: Icons.link,
                  label: 'GitHub',
                  onTap: () => _launchUrl('https://github.com/simplechat'),
                  color: Colors.grey[800]!,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildLegalButton(
              icon: Icons.description,
              title: 'Terms of Service',
              onTap: () => _showTermsDialog(),
            ),
            const Divider(),
            _buildLegalButton(
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              onTap: () => _showPrivacyDialog(),
            ),
            const Divider(),
            _buildLegalButton(
              icon: Icons.security,
              title: 'Security Policy',
              onTap: () => _showSecurityDialog(),
            ),
            const Divider(),
            _buildLegalButton(
              icon: Icons.copyright,
              title: 'Open Source Licenses',
              onTap: () => _showLicensesDialog(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildVersionInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                'SDK Version: ${_deviceInfo?.osVersion ?? 'Unknown'}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.devices,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                'Device: ${_deviceInfo?.deviceName ?? 'Unknown'}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCopyright() {
    return Text(
      '© ${DateTime.now().year} Simple Chat Solutions. All rights reserved.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey[500],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cannot open link: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Support Request',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _shareApp() async {
    await Share.share(
      'Check out this app: https://play.google.com/store/apps/details?id=com.example.chat_app_bloc',
    );
    // AppSnackbar.success(context, "Share feature coming soon!");
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogSection(
                title: '1. Acceptance of Terms',
                content:
                    'By using this application, you agree to be bound by these Terms of Service.',
              ),
              const SizedBox(height: 16),
              _buildDialogSection(
                title: '2. User Responsibilities',
                content:
                    'You are responsible for maintaining the confidentiality of your account and for all activities that occur under your account.',
              ),
              const SizedBox(height: 16),
              _buildDialogSection(
                title: '3. Prohibited Activities',
                content:
                    'You may not use the app for any illegal or unauthorized purpose. You must not violate any laws in your jurisdiction.',
              ),
              const SizedBox(height: 16),
              _buildDialogSection(
                title: '4. Termination',
                content:
                    'We may terminate or suspend your account immediately, without prior notice, for any reason.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogSection(
                title: 'Information We Collect',
                content:
                    'We collect account information, messages, contacts, and device information to provide and improve our services.',
              ),
              const SizedBox(height: 16),
              _buildDialogSection(
                title: 'How We Use Information',
                content:
                    'We use your information to deliver messages, improve app functionality, and ensure security.',
              ),
              const SizedBox(height: 16),
              _buildDialogSection(
                title: 'Data Security',
                content:
                    'We implement industry-standard security measures to protect your data from unauthorized access.',
              ),
              const SizedBox(height: 16),
              _buildDialogSection(
                title: 'Your Rights',
                content:
                    'You have the right to access, modify, or delete your personal information at any time.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSecurityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Security Policy'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogSection(
                title: 'End-to-End Encryption',
                content:
                    'All messages are encrypted end-to-end, ensuring only you and the recipient can read them.',
              ),
              const SizedBox(height: 16),
              _buildDialogSection(
                title: 'Data Protection',
                content:
                    'Your data is stored securely with industry-standard encryption protocols.',
              ),
              const SizedBox(height: 16),
              _buildDialogSection(
                title: 'Security Updates',
                content:
                    'We regularly update our security measures to protect against emerging threats.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLicensesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Open Source Licenses'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLicenseItem(
                name: 'Flutter',
                license: 'BSD 3-Clause License',
                url: 'https://flutter.dev',
              ),
              const Divider(),
              _buildLicenseItem(
                name: 'Firebase',
                license: 'Apache License 2.0',
                url: 'https://firebase.google.com',
              ),
              const Divider(),
              _buildLicenseItem(
                name: 'Provider',
                license: 'MIT License',
                url: 'https://pub.dev/packages/provider',
              ),
              const Divider(),
              _buildLicenseItem(
                name: 'Bloc',
                license: 'MIT License',
                url: 'https://pub.dev/packages/bloc',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogSection({
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildLicenseItem({
    required String name,
    required String license,
    required String url,
  }) {
    return ListTile(
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        license,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: const Icon(Icons.open_in_new, size: 18),
      onTap: () => _launchUrl(url),
      contentPadding: EdgeInsets.zero,
    );
  }
}
