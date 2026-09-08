import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qampus/home.dart';
import 'package:qampus/login.dart';

void main() {
  testWidgets('Login page smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginPage(),
      ),
    );

    expect(find.text('LOGIN'), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('LoginPage - validates empty input and authenticates successfully with correct credentials', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    await tester.tap(find.widgetWithText(ElevatedButton, 'LOGIN'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter both Email and Password!'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'student@qampus.com');
    await tester.enterText(find.byType(TextField).at(1), '123456');
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'LOGIN'));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Campus Services'), findsOneWidget);
  });

  testWidgets('LibraryPage - renders properly and shows seating, status, and books', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );

    // Tap Library service card
    final libraryFinder = find.text('Library');
    await tester.scrollUntilVisible(libraryFinder, 300, scrollable: find.byType(Scrollable).first);
    await tester.tap(libraryFinder);
    await tester.pumpAndSettle();

    // Verify Library Services page opens
    expect(find.text('Library Services'), findsOneWidget);
    expect(find.text('Available Seats'), findsOneWidget);
    expect(find.text('Check Book Availability'), findsOneWidget);
    expect(find.text('Introduction to Algorithms'), findsWidgets);
  });

  testWidgets('CanteenPage - navigation, queue status, active token, cancel and get token', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );

    // Tap Canteen service card from HomePage
    await tester.tap(find.text('Canteen'));
    await tester.pumpAndSettle();

    // Verify Canteen Services page opens
    expect(find.text('Canteen Services'), findsOneWidget);
    expect(find.text('CAMPUS CANTEEN'), findsOneWidget);
    expect(find.text('Live Queue Status'), findsOneWidget);
    expect(find.text('7 in Queue'), findsOneWidget);
    expect(find.textContaining('CANTEEN C'), findsWidgets);
    expect(find.text('Menu Items & Orders'), findsOneWidget);

    // Verify active token details
    expect(find.text('TOKEN #C-042'), findsOneWidget);
    expect(find.text('Item: Chicken Biryani Platter'), findsOneWidget);
    expect(find.text('People Ahead: 7  |  Est. Wait: 14 mins'), findsOneWidget);

    // Test Cancel Token dialog
    await tester.tap(find.text('Cancel Token'));
    await tester.pumpAndSettle();

    expect(find.text('Are you sure you want to cancel your queue token?'), findsOneWidget);
    await tester.tap(find.text('Yes, Cancel'));
    await tester.pumpAndSettle();

    // Verify token is cancelled
    expect(find.text('No active token. Tap "Get Token" on any menu item below to join queue.'), findsOneWidget);

    // Test Get Token on available item
    await tester.tap(find.widgetWithText(ElevatedButton, 'Get Token').first);
    await tester.pumpAndSettle();

    // Verify new token is generated
    expect(find.text('TOKEN #C-043'), findsOneWidget);
  });

  testWidgets('ClubOfficePage - navigation, queue status, active token, cancel and register token', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );

    // Tap Club Office service card from HomePage
    final clubFinder = find.text('Club Office');
    await tester.scrollUntilVisible(clubFinder, 300, scrollable: find.byType(Scrollable).first);
    await tester.tap(clubFinder);
    await tester.pumpAndSettle();

    // Verify Club Office Services page opens
    expect(find.text('Club Office Services'), findsOneWidget);
    expect(find.text('STUDENT CLUB OFFICE'), findsOneWidget);
    expect(find.text('Live Queue Status'), findsOneWidget);
    expect(find.text('2 in Queue'), findsOneWidget);
    expect(find.textContaining('CLUB O'), findsWidgets);
    expect(find.text('Club Events & Activities'), findsOneWidget);

    // Verify active token details
    expect(find.text('TOKEN #O-012'), findsOneWidget);
    expect(find.text('Event: Robotics Workshop 2026'), findsOneWidget);
    expect(find.text('People Ahead: 2  |  Est. Wait: 8 mins'), findsOneWidget);

    // Test Cancel Token dialog
    await tester.tap(find.text('Cancel Token'));
    await tester.pumpAndSettle();

    expect(find.text('Are you sure you want to cancel your queue token?'), findsOneWidget);
    await tester.tap(find.text('Yes, Cancel'));
    await tester.pumpAndSettle();

    // Verify token is cancelled
    expect(find.text('No active token. Tap "Register" on any club event below to join queue.'), findsOneWidget);

    // Test Register on available event
    await tester.tap(find.widgetWithText(ElevatedButton, 'Register').first);
    await tester.pumpAndSettle();

    // Verify new token is generated
    expect(find.text('TOKEN #O-013'), findsOneWidget);
  });
}

