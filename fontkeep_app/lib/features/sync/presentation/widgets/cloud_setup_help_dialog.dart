import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CloudSetupHelpDialog extends StatelessWidget {
  const CloudSetupHelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.help_outline, color: Colors.indigo),
          SizedBox(width: 10),
          Text("How to get API Keys"),
        ],
      ),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "To sync with your own Google Drive, you need to create a free 'Desktop App' credential in Google Cloud.",
              ),
              const SizedBox(height: 20),

              _Step(
                number: 1,
                text: "Go to Google Cloud Console.",
                linkText: "Open Console",
                url: "https://console.cloud.google.com/",
              ),
              _Step(
                number: 2,
                text: "Create a New Project (e.g., 'FontKeep Sync').",
              ),
              _Step(
                number: 3,
                text:
                    "Go to 'APIs & Services' > 'Library' and enable the 'Google Drive API'.",
              ),
              _Step(
                number: 4,
                text:
                    "Go to 'OAuth consent screen'. Select 'External', fill in required emails, and add YOUR email as a 'Test User'.",
              ),
              _Step(
                number: 5,
                text:
                    "Go to 'Credentials' > 'Create Credentials' > 'OAuth client ID'.",
              ),
              _Step(number: 6, text: "Select Application Type: 'Desktop App'."),
              _Step(
                number: 7,
                text: "Copy the Client ID and Client Secret provided.",
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  final int number;
  final String text;
  final String? linkText;
  final String? url;

  const _Step({
    required this.number,
    required this.text,
    this.linkText,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              "$number",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: const TextStyle(fontSize: 14)),
                if (linkText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: InkWell(
                      onTap: () => launchUrl(
                        Uri.parse(url!),
                        mode: LaunchMode.externalApplication,
                      ),
                      child: Text(
                        linkText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
