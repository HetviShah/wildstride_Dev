import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SOSModal extends StatefulWidget {
  final bool isOpen;
  final VoidCallback onClose;

  const SOSModal({
    super.key,
    required this.isOpen,
    required this.onClose,
  });

  @override
  State<SOSModal> createState() => _SOSModalState();
}

class _SOSModalState extends State<SOSModal> {
  String _step = 'check-in'; // check-in, pin-entry, create-pin, escalation, alert-sent
  String _pin = '';
  String _newPin = '';
  String _confirmPin = '';
  String? _savedPin;
  int _escalationCountdown = 60;

  @override
  void initState() {
    super.initState();
    _loadSavedPin();
  }

  void _resetState() {
    _step = 'check-in';
    _pin = '';
    _newPin = '';
    _confirmPin = '';
  }

  Future<void> _loadSavedPin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedPin = prefs.getString('safety_pin');
    });
  }

  Future<void> _saveNewPin() async {
    if (_newPin.length != 4 || _confirmPin.length != 4) {
      _showErrorDialog("PIN must be 4 digits.");
      return;
    }
    if (_newPin != _confirmPin) {
      _showErrorDialog("PINs do not match.");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('safety_pin', _newPin);
    setState(() {
      _savedPin = _newPin;
      _resetState();
    });
    _showSuccessDialog("Safety PIN created successfully.");
  }

  void _handlePinSubmit() {
    if (_pin == _savedPin) {
      widget.onClose();
      setState(() {
        _resetState();
      });
    } else {
      _showErrorDialog('Incorrect PIN. Try again.');
    }
  }

  void _handleEscalation() {
    setState(() {
      _step = 'escalation';
      _escalationCountdown = 60;
    });
    _startEscalationTimer();
  }

  void _startEscalationTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _step == 'escalation' && _escalationCountdown > 0) {
        setState(() => _escalationCountdown--);
        _startEscalationTimer();
      } else if (mounted && _step == 'escalation' && _escalationCountdown == 0) {
        setState(() => _step = 'alert-sent');
      }
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// ✅ Safety Check-In Panel (now with both Enter + Create PIN buttons)
  Widget _buildSafetyCheckInPanel(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.shield_outlined,
                  color: Color(0xFF2D8C6A), size: 48),
              const SizedBox(height: 8),
              const Text(
                "Safety Check-In",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF003B2E),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Please confirm you're safe by entering or creating your Safety PIN.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF6B6B6B)),
              ),
              const SizedBox(height: 16),

              // ✅ Enter PIN button
              ElevatedButton(
                onPressed: () => setState(() => _step = 'pin-entry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003B2E),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Enter Safety PIN"),
              ),
              const SizedBox(height: 8),

              // ✅ Create PIN button (new addition)
              ElevatedButton(
                onPressed: () => setState(() => _step = 'create-pin'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D8C6A),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Create Safety PIN"),
              ),

              const SizedBox(height: 8),

              OutlinedButton(
                onPressed: _handleEscalation,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: Color(0xFFE53935)),
                  foregroundColor: const Color(0xFFE53935),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("I Need Help"),
              ),
            ],
          ),
        ),
        Positioned(
          right: 6,
          top: 6,
          child: IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF6B6B6B)),
            onPressed: widget.onClose,
          ),
        ),
      ],
    );
  }

  /// ✅ Create PIN Step
  Widget _buildCreatePinStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.lock_outline, size: 48, color: Color(0xFF2D8C6A)),
        const SizedBox(height: 16),
        const Text(
          "Create Your Safety PIN",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003B2E)),
        ),
        const SizedBox(height: 8),
        const Text(
          "Set a secure 4-digit PIN to confirm your safety during check-ins.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF6B6B6B)),
        ),
        const SizedBox(height: 24),
        TextField(
          obscureText: true,
          textAlign: TextAlign.center,
          maxLength: 4,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Enter new PIN',
            counterText: '',
            border: OutlineInputBorder(),
          ),
          onChanged: (v) => setState(() => _newPin = v),
        ),
        const SizedBox(height: 16),
        TextField(
          obscureText: true,
          textAlign: TextAlign.center,
          maxLength: 4,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Confirm new PIN',
            counterText: '',
            border: OutlineInputBorder(),
          ),
          onChanged: (v) => setState(() => _confirmPin = v),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveNewPin,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003B2E),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text("Save PIN"),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => setState(() => _step = 'check-in'),
            child: const Text("Cancel"),
          ),
        ),
      ],
    );
  }

  Widget _buildPinEntryStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.shield, size: 48, color: Color(0xFF2D8C6A)),
        const SizedBox(height: 16),
        const Text(
          "Enter Your Safety PIN",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003B2E)),
        ),
        const SizedBox(height: 8),
        const Text(
          "Confirm your safety by entering your 4-digit PIN.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF6B6B6B)),
        ),
        const SizedBox(height: 24),
        TextField(
          obscureText: true,
          textAlign: TextAlign.center,
          maxLength: 4,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Enter 4-digit PIN',
            counterText: '',
            border: OutlineInputBorder(),
          ),
          onChanged: (v) => setState(() => _pin = v),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _pin.length == 4 ? _handlePinSubmit : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003B2E),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text("Confirm Safety"),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => setState(() => _step = 'check-in'),
            child: const Text("Back"),
          ),
        ),
      ],
    );
  }

  Widget _buildEscalationStep() {
    final minutes = _escalationCountdown ~/ 60;
    final seconds = _escalationCountdown % 60;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.warning_amber_rounded, size: 48, color: Colors.red),
        const SizedBox(height: 16),
        const Text("Emergency Alert!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
        const SizedBox(height: 8),
        Text("Time remaining: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}"),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value: (60 - _escalationCountdown) / 60,
          color: Colors.red,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => setState(() => _step = 'pin-entry'),
          child: const Text("I'm Safe - Enter PIN"),
        ),
      ],
    );
  }

  Widget _buildAlertSentStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.phone, size: 48, color: Colors.red),
        const SizedBox(height: 16),
        const Text("Emergency Contacts Notified",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red)),
        const SizedBox(height: 8),
        const Text(
          "Your emergency contacts have been alerted and your last known location shared.",
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        OutlinedButton(onPressed: widget.onClose, child: const Text("Close")),
      ],
    );
  }

  Widget _buildContent() {
    switch (_step) {
      case 'check-in':
        return _buildSafetyCheckInPanel(context);
      case 'create-pin':
        return _buildCreatePinStep();
      case 'pin-entry':
        return _buildPinEntryStep();
      case 'escalation':
        return _buildEscalationStep();
      case 'alert-sent':
        return _buildAlertSentStep();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isOpen) return const SizedBox();

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, anim) =>
            FadeTransition(opacity: anim, child: child),
        child: Container(
          key: ValueKey(_step),
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: _buildContent(),
        ),
      ),
    );
  }
}