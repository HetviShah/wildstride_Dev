import 'package:flutter/material.dart';

const int mobileBreakpoint = 768;

class MobileUtils {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }
}

// Hook-style approach using a StatefulWidget
class UseIsMobile extends StatefulWidget {
  final Widget Function(bool isMobile) builder;

  const UseIsMobile({Key? key, required this.builder}) : super(key: key);

  @override
  State<UseIsMobile> createState() => _UseIsMobileState();
}

class _UseIsMobileState extends State<UseIsMobile> {
  bool? _isMobile;

  @override
  void initState() {
    super.initState();
    _updateIsMobile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateIsMobile();
  }

  void _updateIsMobile() {
    final newValue = MediaQuery.of(context).size.width < mobileBreakpoint;
    if (_isMobile != newValue) {
      setState(() {
        _isMobile = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_isMobile ?? false);
  }
}

// Simple function approach
bool useIsMobile(BuildContext context) {
  return MediaQuery.of(context).size.width < mobileBreakpoint;
}

// Reactive approach using MediaQuery
class IsMobileBuilder extends StatelessWidget {
  final Widget Function(bool isMobile) builder;

  const IsMobileBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < mobileBreakpoint;
    return builder(isMobile);
  }
}

// Example usage:
class ResponsiveExample extends StatelessWidget {
  const ResponsiveExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Method 1: Using the simple function
    final isMobile = useIsMobile(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Method 2: Using the builder widget
            IsMobileBuilder(
              builder: (isMobile) {
                return Text(
                  isMobile ? 'Mobile Layout' : 'Desktop Layout',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            
            const SizedBox(height: 20),
            
            // Method 3: Using the hook-style widget
            UseIsMobile(
              builder: (isMobile) {
                return Container(
                  width: isMobile ? 200 : 400,
                  height: isMobile ? 100 : 200,
                  color: isMobile ? Colors.blue : Colors.green,
                  child: Center(
                    child: Text(
                      isMobile ? 'Mobile Size' : 'Desktop Size',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 20),
            
            // Method 1 usage demonstration
            Text(
              'Using function: ${isMobile ? 'Mobile' : 'Desktop'}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}