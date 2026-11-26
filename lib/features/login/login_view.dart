// GetX 4 uses Flutter's legacy Material types.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  static const logoAsset = 'assets/logo/login-img.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, bounds) {
            final spacingScale = (bounds.maxHeight / 755).clamp(0.5, 1.0);
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: bounds.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            24,
                            54 * spacingScale,
                            24,
                            28 * spacingScale,
                          ),
                          child: Column(
                            children: [
                              Image.asset(logoAsset, width: 68, height: 54),
                              const SizedBox(height: 7),
                              const Text(
                                'Mayavaram Financial Chit',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _gray,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Trust  •  Tradition  •  Growth',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: _gray, fontSize: 12),
                              ),
                              SizedBox(height: 68 * spacingScale),
                              _LoginForm(
                                controller: controller,
                                spacingScale: spacingScale,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 64,
                      child: CustomPaint(painter: _LoginFooter()),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

const _gray = Color(0xFF9E9E9E);
const _border = OutlineInputBorder(
  borderRadius: BorderRadius.zero,
  borderSide: BorderSide(color: Color(0xFFE5E5E5)),
);

InputDecoration _fieldDecoration(
  String label,
  String hint,
  IconData icon, {
  Widget? suffix,
}) => InputDecoration(
  label: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: _gray,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        hint,
        style: const TextStyle(color: Color(0xFFB8B8B8), fontSize: 12),
      ),
    ],
  ),
  floatingLabelBehavior: FloatingLabelBehavior.never,
  prefixIcon: Icon(icon, size: 18, color: _gray),
  prefixIconConstraints: const BoxConstraints(minWidth: 49),
  suffixIcon: suffix,
  enabledBorder: _border,
  focusedBorder: _border,
  border: _border,
  contentPadding: const EdgeInsets.fromLTRB(0, 12, 10, 12),
  constraints: const BoxConstraints(minHeight: 62),
);

class _LoginForm extends StatefulWidget {
  const _LoginForm({required this.controller, required this.spacingScale});

  final LoginController controller;
  final double spacingScale;

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sign-in is currently unavailable.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome !',
              style: TextStyle(
                color: _gray,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Text(
              'Login to continue to your chit account.',
              style: TextStyle(color: _gray, fontSize: 12),
            ),
            SizedBox(height: 48 * widget.spacingScale),
            TextFormField(
              style: const TextStyle(color: Color(0xFF555555), fontSize: 13),
              decoration: _fieldDecoration(
                'Aadhaar Card Number',
                'Enter your 12-digit Aadhaar number',
                Icons.badge_outlined,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(12),
              ],
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.username],
              validator: (value) {
                final length = value?.length ?? 0;
                if (length == 0) return 'Enter your Aadhaar number';
                if (length != 12) return 'Enter a 12-digit Aadhaar number';
                return null;
              },
            ),
            const SizedBox(height: 14),
            ListenableBuilder(
              listenable: _passwordFocus,
              builder: (context, child) => Obx(() {
                final visible = widget.controller.passwordVisible;

                return TextFormField(
                  focusNode: _passwordFocus,
                  style: const TextStyle(
                    color: Color(0xFF555555),
                    fontSize: 13,
                  ),
                  decoration: _fieldDecoration(
                    'Password',
                    'Enter your password',
                    Icons.lock_outline,
                    suffix: _passwordFocus.hasFocus || visible
                        ? IconButton(
                            onPressed:
                                widget.controller.togglePasswordVisibility,
                            tooltip: visible
                                ? 'Hide password'
                                : 'Show password',
                            color: _gray,
                            icon: Icon(
                              visible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          )
                        : null,
                  ),
                  obscureText: !visible,
                  autocorrect: false,
                  enableSuggestions: false,
                  autofillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: (value) =>
                      (value?.isEmpty ?? true) ? 'Password is required' : null,
                );
              }),
            ),
            SizedBox(height: 50 * widget.spacingScale),
            FilledButton(
              onPressed: _submit,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(34),
                backgroundColor: const Color(0xFFDBDBDB),
                foregroundColor: const Color(0xFF616161),
                shape: const RoundedRectangleBorder(),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Login'),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginFooter extends CustomPainter {
  const _LoginFooter();

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final wave = Path()
      ..moveTo(0, 27)
      ..cubicTo(width * .17, 3, width * .21, 12, width * .35, 44)
      ..cubicTo(width * .46, 62, width * .54, 62, width * .65, 44)
      ..cubicTo(width * .79, 12, width * .83, 3, width, 27)
      ..lineTo(width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(wave, Paint()..color = const Color(0xFFB5B5B5));

    final petalPaint = Paint()..color = _gray;
    final center = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(20, 18, 0, 37)
      ..quadraticBezierTo(-20, 18, 0, 0)
      ..close();
    final side = Path()
      ..moveTo(5, 38)
      ..quadraticBezierTo(16, 22, 10, 12)
      ..lineTo(20, 7)
      ..quadraticBezierTo(26, 29, 5, 38)
      ..close();
    final outer = Path()
      ..moveTo(10, 40)
      ..quadraticBezierTo(22, 34, 23, 20)
      ..lineTo(30, 20)
      ..quadraticBezierTo(31, 42, 10, 40)
      ..close();
    canvas.save();
    canvas.translate(width / 2, 2);
    canvas.drawPath(center, petalPaint);
    canvas.drawPath(side, petalPaint);
    canvas.drawPath(outer, petalPaint);
    canvas.scale(-1, 1);
    canvas.drawPath(side, petalPaint);
    canvas.drawPath(outer, petalPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_LoginFooter oldDelegate) => false;
}
