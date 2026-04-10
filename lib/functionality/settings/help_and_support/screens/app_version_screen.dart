import 'dart:io';

import 'package:chat_app_bloc/app_widget/app_snackbar.dart';
import 'package:chat_app_bloc/functionality/settings/help_and_support/models/app_version_model.dart';
import 'package:chat_app_bloc/service/app_version_service.dart';
import 'package:chat_app_bloc/utils/constent/app_color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class AppVersionScreen extends StatefulWidget {
  const AppVersionScreen({Key? key}) : super(key: key);

  @override
  State<AppVersionScreen> createState() => _AppVersionScreenState();
}

class _AppVersionScreenState extends State<AppVersionScreen> {
  PackageInfo? _packageInfo;
  AppVersion? _latestVersion;
  DeviceInfo? _deviceInfo;
  bool _isLoading = true;
  bool _hasUpdate = false;

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

      final versionService = AppVersionService();
      final updateCheck = await versionService.checkForUpdates();

      if (updateCheck.needsUpdate && updateCheck.latestVersion != null) {
        _latestVersion = updateCheck.latestVersion;
        _hasUpdate = true;
      }
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
        title: const Text("App Version"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.arrowLeft,
                size: 18,
                color: Color(0xFF4B5563),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: double.infinity, child: _buildVersionCard()),
                  const SizedBox(height: 20),
                  if (_hasUpdate) _buildUpdateCard(),
                  if (_hasUpdate) const SizedBox(height: 20),
                  _buildDeviceInfoCard(),
                  // const SizedBox(height: 20),
                  // _buildVersionHistoryCard(),
                  const SizedBox(height: 20),
                  _buildCheckUpdateButton(),
                  const SizedBox(height: 20),
                  _buildReportIssueButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildVersionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(
              Icons.app_registration,
              size: 60,
              color: isColorValidation(context),
            ),
            const SizedBox(height: 16),
            Text(
              _packageInfo?.appName ?? 'Chat App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isColorValidation(context),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Version ${_packageInfo?.version} (Build ${_packageInfo?.buildNumber})',
                style: TextStyle(
                  fontSize: 14,
                  color: isColorValidation(context),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_hasUpdate)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.system_update,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Update Available: v${_latestVersion?.versionName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateCard() {
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
                  Icons.system_update_alt,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'What\'s New in v${_latestVersion?.versionName}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_latestVersion?.releaseNotes != null &&
                _latestVersion!.releaseNotes.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _latestVersion!.releaseNotes,
                  style: const TextStyle(height: 1.5),
                ),
              ),
            const SizedBox(height: 16),
            if (_latestVersion?.changes.isNotEmpty ?? false) ...[
              const Text(
                'Changes:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              ..._latestVersion!.changes.map((change) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          change,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _updateApp,
                icon: const Icon(Icons.download),
                label: const Text('Update Now'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
            if (_latestVersion?.isRequired ?? false)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: Colors.red[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This update is required. You won\'t be able to use the app without updating.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceInfoCard() {
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
                  Icons.devices,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Device Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow('Device', _deviceInfo?.deviceName ?? 'Unknown'),
            _buildInfoRow('Model', _deviceInfo?.deviceModel ?? 'Unknown'),
            _buildInfoRow('OS Version', _deviceInfo?.osVersion ?? 'Unknown'),
            _buildInfoRow('Platform', _deviceInfo?.platform ?? 'Unknown'),
            _buildInfoRow('Language', _deviceInfo?.language ?? 'Unknown'),
            _buildInfoRow('Timezone', _deviceInfo?.timezone ?? 'Unknown'),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionHistoryCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        leading: Icon(
          Icons.history,
          color: Theme.of(context).primaryColor,
        ),
        title: const Text(
          'Version History',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildVersionHistoryItem(
                  version: '2.0.0',
                  date: 'March 2026',
                  changes: [
                    'Dark mode support',
                    'Improved performance',
                    'Bug fixes',
                  ],
                ),
                const Divider(),
                _buildVersionHistoryItem(
                  version: '1.5.0',
                  date: 'February 2026',
                  changes: [
                    'Group chat feature',
                    'Voice messages',
                    'UI improvements',
                  ],
                ),
                const Divider(),
                _buildVersionHistoryItem(
                  version: '1.0.0',
                  date: 'January 2026',
                  changes: [
                    'Initial release',
                    'Basic messaging',
                    'Profile settings',
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionHistoryItem({
    required String version,
    required String date,
    required List<String> changes,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Version $version',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...changes.map((change) => Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 6),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        change,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
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
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckUpdateButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _checkForUpdate,
        icon: const Icon(Icons.refresh),
        label: const Text('Check for Updates'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  Widget _buildReportIssueButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: _reportVersionIssue,
        icon: const Icon(Icons.report_problem),
        label: const Text('Report a Problem with this Version'),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Future<void> _updateApp() async {
    final url = _latestVersion?.downloadUrl;
    if (url != null && url.isNotEmpty) {
      try {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot open update link'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        debugPrint('Error opening update: $e');
      }
    } else {
      // Open Play Store / App Store
      final packageInfo = await PackageInfo.fromPlatform();
      final packageName = packageInfo.packageName;

      String storeUrl = Platform.isAndroid
          ? 'https://play.google.com/store/apps/details?id=$packageName'
          : 'https://apps.apple.com/app/id${packageName}';

      if (await canLaunchUrl(Uri.parse(storeUrl))) {
        await launchUrl(Uri.parse(storeUrl));
      }
    }
  }

  Future<void> _checkForUpdate() async {
    setState(() => _isLoading = true);

    final versionService = AppVersionService();
    final updateCheck = await versionService.checkForUpdates();

    setState(() {
      _isLoading = false;
      if (updateCheck.needsUpdate && updateCheck.latestVersion != null) {
        _latestVersion = updateCheck.latestVersion;
        _hasUpdate = true;
        _showUpdateDialog(updateCheck);
      } else {
        _showNoUpdateDialog();
      }
    });
  }

  void _showUpdateDialog(VersionCheckResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Available'),
        content: Text(result.message ?? 'A new version is available.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateApp();
            },
            child: const Text('Update Now'),
          ),
        ],
      ),
    );
  }

  void _showNoUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Updates'),
        content: const Text('You are using the latest version of the app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _reportVersionIssue() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Version Issue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('What issue are you experiencing with this version?'),
            const SizedBox(height: 16),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Describe the issue...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                // Store issue text
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              AppSnackbar.success(context, "Issue reported successfully");
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
