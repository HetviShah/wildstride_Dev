import 'package:flutter/material.dart';
import 'login_page.dart';
import 'landinghomepage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  // ✅ Prevent mouse_tracker crash in debug mode
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exceptionAsString().contains('_debugDuringDeviceUpdate')) {
      // Ignore this harmless mouse update error
      debugPrint('⚠️ Ignored Flutter mouse tracker error');
      return;
    }
    FlutterError.presentError(details);
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // iPhone 12 reference size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Wildstride',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF003B2E),
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          initialRoute: '/login',
          routes: {
            '/login': (context) => LoginPage(),
            '/landing' : (context) => LandingHomePage(),
          },
        );
      },
    );
  }
}




