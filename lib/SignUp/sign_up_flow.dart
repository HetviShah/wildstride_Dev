import 'package:flutter/material.dart';
import 'sign_up_data.dart';
import 'step1_page.dart';
import 'step2_page.dart';
import 'step3_page.dart';
import 'step4_page.dart';
import 'step5_page.dart';
import 'step6_page.dart';


class SignupFlow extends StatefulWidget {
  const SignupFlow({super.key});

  @override
  State<SignupFlow> createState() => _SignupFlowState();
}

class _SignupFlowState extends State<SignupFlow> {
  final SignupData _signupData = SignupData();
  int _currentStep = 1;

  void _goToStep(int step) {
    setState(() => _currentStep = step);
  }

  void _finishSignup() {
    // Here you can send _signupData to your backend or Firebase
    debugPrint("✅ Signup Complete!");
    debugPrint("User Data: ${_signupData.firstName}, ${_signupData.email}");
    Navigator.pop(context); // go back to login/home after signup
  }

  @override
  Widget build(BuildContext context) {
    Widget stepPage;

    switch (_currentStep) {
      case 1:
        stepPage = Step1Page(
          signupData: _signupData,
          onNext: () => _goToStep(2),
          onBack: () => Navigator.pop(context), // back to login/home
        );
        break;
      case 2:
        stepPage = Step2Page(
          signupData: _signupData,
          onNext: () => _goToStep(3), // will move to Step3 later
          onBack: () => _goToStep(1),
        );
        break;
      case 3:
        stepPage = Step3Page(
          signupData: _signupData,
          onNext: () => _goToStep(4), // will move to Step3 later
          onBack: () => _goToStep(2),
        );
        break;
      case 4:
        stepPage = Step4Page(
          signupData: _signupData,
          onNext: () => _goToStep(5), // will move to Step3 later
          onBack: () => _goToStep(3),
        );
        break;
      case 5:
        stepPage = Step5Page(
          signupData: _signupData,
          onNext: () => _goToStep(6), // will move to Step3 later
          onBack: () => _goToStep(4),
        );
        break;
      case 6:
        stepPage = Step6Page(
          signupData: _signupData,
          onFinish: _finishSignup,
          onBack: () => _goToStep(5),
        );
        break;
      default:
        stepPage = const Scaffold(
          body: Center(child: Text("Step not implemented yet")),
        );
    }

    return stepPage;
  }
}