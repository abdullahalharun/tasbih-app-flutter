import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';

import '../models/tasbih_model.dart';
import '../services/storage_service.dart';
import '../widgets/counter_display.dart';
import '../widgets/dhikr_selector.dart';
import '../widgets/settings_drawer.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen>
    with TickerProviderStateMixin {
  late TasbihCounter _currentCounter;
  late TasbihSettings _settings;
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _scaleController;

  bool _isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadData();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  Future<void> _loadData() async {
    try {
      _settings = await TasbihStorageService.instance.loadSettings();

      final savedCounter = await TasbihStorageService.instance
          .loadCurrentCounter();
      if (savedCounter != null) {
        _currentCounter = savedCounter;
      } else {
        // Default to first dhikr
        _currentCounter = TasbihCounter(item: TasbihData.commonDhikr.first);
      }
    } catch (e) {
      // Fallback to default values
      _settings = const TasbihSettings();
      _currentCounter = TasbihCounter(item: TasbihData.commonDhikr.first);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveData() async {
    await TasbihStorageService.instance.saveCurrentCounter(_currentCounter);
    await TasbihStorageService.instance.saveSettings(_settings);
  }

  void _incrementCounter() async {
    if (_settings.enableVibration) {
      await _provideFeedback();
    }

    setState(() {
      _currentCounter.increment();
    });

    // Trigger animations
    _pulseController.forward().then((_) => _pulseController.reverse());
    _scaleController.forward().then((_) => _scaleController.reverse());

    // Check if target reached
    if (_currentCounter.isTargetReached &&
        _currentCounter.currentCount == _currentCounter.item.targetCount) {
      _onTargetReached();
    }

    await _saveData();
  }

  Future<void> _provideFeedback() async {
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        switch (_settings.vibrationIntensity) {
          case 1:
            await Vibration.vibrate(duration: 50);
            break;
          case 2:
            await Vibration.vibrate(duration: 100);
            break;
          case 3:
            await Vibration.vibrate(duration: 150);
            break;
        }
      }
    } catch (e) {
      // Vibration not supported, continue silently
    }

    // Haptic feedback as fallback
    await HapticFeedback.lightImpact();
  }

  void _onTargetReached() {
    _rotateController.forward().then((_) => _rotateController.reset());

    // Show congratulatory message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Subhan Allah! Target of ${_currentCounter.item.targetCount} reached!',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    if (_settings.autoReset) {
      Future.delayed(const Duration(seconds: 2), () {
        _resetCounter();
      });
    }
  }

  void _resetCounter() {
    setState(() {
      _currentCounter.reset();
    });
    _saveData();
  }

  void _resetTotalCounter() {
    setState(() {
      _currentCounter.resetTotal();
    });
    _saveData();
  }

  void _selectDhikr(TasbihItem item) {
    setState(() {
      _currentCounter = TasbihCounter(item: item);
    });
    _saveData();
  }

  void _updateSettings(TasbihSettings newSettings) {
    setState(() {
      _settings = newSettings;
    });
    TasbihStorageService.instance.saveSettings(_settings);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Tasbih',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
        ],
      ),
      endDrawer: SettingsDrawer(
        settings: _settings,
        onSettingsChanged: _updateSettings,
      ),
      body: Container(
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                // Dhikr Selector
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DhikrSelector(
                    currentItem: _currentCounter.item,
                    onDhikrSelected: _selectDhikr,
                  ),
                ),

                // Counter Display
                CounterDisplay(
                  counter: _currentCounter,
                  settings: _settings,
                  pulseController: _pulseController,
                  rotateController: _rotateController,
                  scaleController: _scaleController,
                  onTap: _incrementCounter,
                ),

                // Action Buttons
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: Icons.refresh,
                        label: 'Reset',
                        onPressed: _resetCounter,
                        color: Colors.orange,
                      ),
                      _buildActionButton(
                        icon: Icons.restart_alt,
                        label: 'Reset All',
                        onPressed: () => _showResetDialog(),
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 8,
        shadowColor: color.withOpacity(0.3),
      ),
    ).animate().scale(delay: 200.ms, duration: 300.ms);
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Total Count'),
          content: const Text(
            'Are you sure you want to reset the total count? This action cannot be undone.',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetTotalCounter();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}
