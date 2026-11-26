import 'package:crm/main.dart';
// GetX 4 uses Flutter's legacy Material types.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  tearDown(() => Get.reset());

  for (final (name, size, insets) in [
    (
      'compact phone',
      const Size(320, 568),
      const FakeViewPadding(top: 24, bottom: 34),
    ),
    (
      'landscape phone',
      const Size(568, 320),
      const FakeViewPadding(left: 42, right: 24, bottom: 20),
    ),
    ('wide display', const Size(1280, 900), const FakeViewPadding(bottom: 24)),
  ]) {
    testWidgets('Login fits the safe area on a $name', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      tester.view.padding = insets;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final viewport = tester.getRect(find.byType(SingleChildScrollView));
      expect(viewport.left, insets.left);
      expect(viewport.top, insets.top);
      expect(viewport.right, size.width - insets.right);
      expect(viewport.bottom, size.height - insets.bottom);

      final login = find.widgetWithText(FilledButton, 'Login');
      expect(tester.getCenter(login).dx, viewport.center.dx);
      expect(tester.getSize(login).width, lessThanOrEqualTo(392));
      await tester.ensureVisible(login);
      await tester.pumpAndSettle();
      expect(login.hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Login displays the logo and validates required fields', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final image = tester.widget<Image>(find.byType(Image));
    expect(image.image, const AssetImage('assets/logo/login-img.png'));

    await tester.tap(find.widgetWithText(FilledButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Enter your Aadhaar number'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('Password visibility can be toggled', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(
      tester.widget<EditableText>(find.byType(EditableText).last).obscureText,
      isTrue,
    );

    await tester.tap(find.byType(TextFormField).last);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Show password'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<EditableText>(find.byType(EditableText).last).obscureText,
      isFalse,
    );
  });
}
