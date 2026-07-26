import 'package:flutter/material.dart';

/// Reusable root scaffold enforcing background canvas, offline banner, and safe area rules.
class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool isOffline;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.isOffline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Column(
          children: [
            if (isOffline)
              Container(
                width: double.infinity,
                color: const Color(0xFFFEF7E0),
                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size: 16.0, color: Color(0xFFE37400)),
                    const SizedBox(width: 8.0),
                    Text(
                      'Offline Mode — Changes will sync when reconnected',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: const Color(0xFFE37400),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
