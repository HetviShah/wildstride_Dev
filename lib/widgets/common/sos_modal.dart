import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

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
  String _step = 'check-in'; // 'check-in', 'pin-entry', 'escalation', 'alert-sent'
  String _pin = '';
  int _escalationCountdown = 60; // 1 minute for final response

  @override
  void initState() {
    super.initState();
    _resetState();
  }

  @override
  void didUpdateWidget(SOSModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen && !oldWidget.isOpen) {
      _resetState();
    }
  }

  void _resetState() {
    _step = 'check-in';
    _pin = '';
    _escalationCountdown = 60;
  }

  void _handlePinSubmit() {
    if (_pin == '1234') { // Mock PIN validation
      widget.onClose();
      setState(() {
        _step = 'check-in';
        _pin = '';
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
        setState(() {
          _escalationCountdown--;
        });
        _startEscalationTimer();
      } else if (mounted && _step == 'escalation' && _escalationCountdown == 0) {
        setState(() {
          _step = 'alert-sent';
        });
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

  Widget _buildCheckInStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: _getColor('#87CEEB'), // sky-blue
            shape: BoxShape.circle,
          ),
          child: Icon(
            LucideIcons.shield,
            size: 32,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Safety Check-In',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: _getColor('#2D5A3D'), // forest-green
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Time for your scheduled safety check-in. Please confirm you\'re safe by entering your PIN.',
          style: TextStyle(
            fontSize: 14,
            color: _getColor('#6B7280'), // mountain-gray
            fontFamily: 'Inter',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => setState(() => _step = 'pin-entry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _getColor('#2D5A3D'), // forest-green
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'Enter Safety PIN',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _handleEscalation,
            style: OutlinedButton.styleFrom(
              foregroundColor: _getColor('#DC2626'), // lucky-red
              side: BorderSide(color: _getColor('#DC2626')),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'I Need Help',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPinEntryStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: _getColor('#2D5A3D'), // forest-green
            shape: BoxShape.circle,
          ),
          child: Icon(
            LucideIcons.shield,
            size: 32,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Enter Your Safety PIN',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: _getColor('#2D5A3D'), // forest-green
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Confirm your safety by entering your 4-digit PIN',
          style: TextStyle(
            fontSize: 14,
            color: _getColor('#6B7280'), // mountain-gray
            fontFamily: 'Inter',
          ),
          textAlign: TextAlign.center,
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
          style: const TextStyle(fontSize: 18),
          onChanged: (value) => setState(() => _pin = value),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _pin.length == 4 ? _handlePinSubmit : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _getColor('#2D5A3D'), // forest-green
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'Confirm Safety',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Forgot your PIN? Contact support immediately.',
          style: TextStyle(
            fontSize: 12,
            color: _getColor('#6B7280'), // mountain-gray
            fontFamily: 'Inter',
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
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: _getColor('#DC2626'), // lucky-red
            shape: BoxShape.circle,
          ),
          child: Icon(
            LucideIcons.alertTriangle,
            size: 32,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'EMERGENCY ALERT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: _getColor('#DC2626'), // lucky-red
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'No response received. Emergency contacts will be notified if you don\'t respond.',
          style: TextStyle(
            fontSize: 14,
            color: _getColor('#6B7280'), // mountain-gray
            fontFamily: 'Inter',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _getColor('#FEF2F2'), // red-50
            border: Border.all(color: _getColor('#DC2626').withOpacity(0.2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                'Time remaining: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  color: _getColor('#DC2626'), // lucky-red
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (60 - _escalationCountdown) / 60,
                backgroundColor: _getColor('#FECACA'), // red-200
                color: _getColor('#DC2626'), // lucky-red
                minHeight: 4,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => setState(() => _step = 'pin-entry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _getColor('#2D5A3D'), // forest-green
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'I\'m Safe - Enter PIN',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertSentStep() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: _getColor('#DC2626'), // lucky-red
            shape: BoxShape.circle,
          ),
          child: Icon(
            LucideIcons.phone,
            size: 32,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Emergency Contacts Notified',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: _getColor('#DC2626'), // lucky-red
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your emergency contacts have been alerted and your last known location has been shared.',
          style: TextStyle(
            fontSize: 14,
            color: _getColor('#6B7280'), // mountain-gray
            fontFamily: 'Inter',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _getColor('#FEF2F2'), // red-50
            border: Border.all(color: _getColor('#DC2626').withOpacity(0.2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.mapPin,
                    size: 16,
                    color: _getColor('#DC2626'), // lucky-red
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Last Location:',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Banff National Park, Canada',
                style: TextStyle(
                  fontSize: 14,
                  color: _getColor('#6B7280'), // mountain-gray
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Shared at 2:30 PM',
                style: TextStyle(
                  fontSize: 12,
                  color: _getColor('#6B7280'), // mountain-gray
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contacts Notified:',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                color: _getColor('#2D5A3D'), // forest-green
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '• Emergency Services: 911\n• Mom: +1 (555) 123-4567\n• Best Friend: +1 (555) 987-6543',
              style: TextStyle(
                fontSize: 14,
                color: _getColor('#6B7280'), // mountain-gray
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: widget.onClose,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              'Close',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    switch (_step) {
      case 'check-in':
        return _buildCheckInStep();
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
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: _buildContent(),
      ),
    );
  }

  // Helper method to convert hex color to Color
  Color _getColor(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}