import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/session_provider.dart';

/// Settings screen where the user can edit session information.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _usernameController;
  late TextEditingController _serverUrlController;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    final session = context.read<SessionProvider>();
    _usernameController = TextEditingController(text: session.username ?? '');
    _serverUrlController = TextEditingController(text: session.serverUrl ?? '');
    _rememberMe = session.rememberMe;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _serverUrlController.dispose();
    super.dispose();
  }

  void _save() {
    final session = context.read<SessionProvider>();
    session.setUsername(_usernameController.text.trim());
    session.setServerUrl(_serverUrlController.text.trim());
    session.setRememberMe(_rememberMe);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF008069),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _serverUrlController,
              decoration: const InputDecoration(labelText: 'Server URL'),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Remember me'),
              value: _rememberMe,
              onChanged: (v) => setState(() => _rememberMe = v),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008069),
                ),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
