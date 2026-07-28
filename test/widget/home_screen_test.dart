import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyp_auth/features/accounts/domain/models/account.dart';
import 'package:hyp_auth/features/accounts/presentation/account_providers.dart';
import 'package:hyp_auth/features/accounts/presentation/home_screen.dart';

void main() {
  testWidgets('HomeScreen displays Codes title and empty state when no accounts exist', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Codes'), findsOneWidget);
    expect(find.text('No accounts added yet'), findsOneWidget);
    expect(find.text('Add account'), findsOneWidget);
  });

  testWidgets('HomeScreen displays account rows when accounts are present', (WidgetTester tester) async {
    final mockAccount = Account(
      id: '1',
      issuer: 'GitHub',
      accountName: 'user@github.com',
      icon: 'github',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isFavorite: false,
    );

    final container = ProviderContainer(
      overrides: [
        accountsStreamProvider.overrideWith((ref) => Stream.value([mockAccount])),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('GitHub'), findsOneWidget);
    expect(find.text('user@github.com'), findsOneWidget);
  });
}
