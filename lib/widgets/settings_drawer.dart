import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class SettingsDrawer extends StatefulWidget {
  final TasbihSettings settings;
  final Function(TasbihSettings) onSettingsChanged;

  const SettingsDrawer({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
  });

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  late TasbihSettings _currentSettings;

  @override
  void initState() {
    super.initState();
    _currentSettings = widget.settings;
  }

  void _updateSetting(TasbihSettings newSettings) {
    setState(() {
      _currentSettings = newSettings;
    });
    widget.onSettingsChanged(newSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.settings, color: Colors.white, size: 40),
                    const SizedBox(height: 10),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Settings List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildSettingsCard('Feedback Settings', [
                      _buildSwitchTile(
                        'Vibration',
                        'Enable haptic feedback on tap',
                        Icons.vibration,
                        _currentSettings.enableVibration,
                        (value) => _updateSetting(
                          _currentSettings.copyWith(enableVibration: value),
                        ),
                      ),
                      if (_currentSettings.enableVibration)
                        _buildSliderTile(
                          'Vibration Intensity',
                          'Adjust vibration strength',
                          Icons.tune,
                          _currentSettings.vibrationIntensity.toDouble(),
                          1.0,
                          3.0,
                          3,
                          (value) => _updateSetting(
                            _currentSettings.copyWith(
                              vibrationIntensity: value.round(),
                            ),
                          ),
                        ),
                      _buildSwitchTile(
                        'Sound Effects',
                        'Play sound on tap (Coming Soon)',
                        Icons.volume_up,
                        _currentSettings.enableSound,
                        null, // Disabled for now
                      ),
                    ]),

                    const SizedBox(height: 16),

                    _buildSettingsCard('Display Settings', [
                      _buildSwitchTile(
                        'Show Transliteration',
                        'Display romanized Arabic text',
                        Icons.translate,
                        _currentSettings.showTransliteration,
                        (value) => _updateSetting(
                          _currentSettings.copyWith(showTransliteration: value),
                        ),
                      ),
                      _buildSwitchTile(
                        'Show Translation',
                        'Display English meaning',
                        Icons.language,
                        _currentSettings.showTranslation,
                        (value) => _updateSetting(
                          _currentSettings.copyWith(showTranslation: value),
                        ),
                      ),
                    ]),

                    const SizedBox(height: 16),

                    _buildSettingsCard('Counter Settings', [
                      _buildSwitchTile(
                        'Auto Reset',
                        'Automatically reset when target reached',
                        Icons.refresh,
                        _currentSettings.autoReset,
                        (value) => _updateSetting(
                          _currentSettings.copyWith(autoReset: value),
                        ),
                      ),
                    ]),

                    const SizedBox(height: 24),

                    // About Section
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'About',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Islamic Tasbih App\nVersion 1.0.0\n\n'
                              'A beautiful digital tasbih for counting dhikr '
                              'and remembering Allah (SWT).\n\n'
                              'May Allah accept our worship and grant us '
                              'His mercy and blessings.',
                              style: TextStyle(height: 1.5),
                            ),
                          ],
                        ),
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

  Widget _buildSettingsCard(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool)? onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderTile(
    String title,
    String subtitle,
    IconData icon,
    double value,
    double min,
    double max,
    int divisions,
    Function(double) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: _getVibrationLabel(value.round()),
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  String _getVibrationLabel(int intensity) {
    switch (intensity) {
      case 1:
        return 'Light';
      case 2:
        return 'Medium';
      case 3:
        return 'Strong';
      default:
        return 'Light';
    }
  }
}
