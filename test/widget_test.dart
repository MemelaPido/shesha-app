import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shesha_phase1/app.dart';
import 'package:shesha_phase1/providers/auth_provider.dart';
import 'package:shesha_phase1/services/auth_service.dart';

void main() {
  testWidgets('Shesha splash renders', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(AuthService()),
        child: const SheshaApp(),
      ),
    );
    expect(find.text('SHESHA'), findsOneWidget);
  });
}
