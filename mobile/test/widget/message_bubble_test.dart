import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitalia_mobile/features/chat/domain/entities/message.dart';
import 'package:vitalia_mobile/shared/widgets/message_bubble.dart';

void main() {
  Future<void> pumpBubble(WidgetTester tester, Message message) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: MessageBubble(message: message)),
      ),
    );
  }

  testWidgets('renders the message content', (tester) async {
    await pumpBubble(
      tester,
      Message(
        id: '1',
        senderType: MessageSenderType.assistant,
        content: 'Bonjour, comment puis-je t\'aider ?',
        createdAt: DateTime(2026, 1, 1),
      ),
    );

    expect(find.textContaining('Bonjour, comment puis-je'), findsOneWidget);
  });

  testWidgets(
    'aligns user messages to the right and agent messages to the left',
    (tester) async {
      await pumpBubble(
        tester,
        Message(
          id: '1',
          senderType: MessageSenderType.user,
          content: 'Salut',
          createdAt: DateTime(2026, 1, 1),
        ),
      );

      final userAlign = tester.widget<Align>(find.byType(Align));
      expect(userAlign.alignment, Alignment.centerRight);

      await pumpBubble(
        tester,
        Message(
          id: '2',
          senderType: MessageSenderType.assistant,
          content: 'Salut',
          createdAt: DateTime(2026, 1, 1),
        ),
      );

      final agentAlign = tester.widget<Align>(find.byType(Align));
      expect(agentAlign.alignment, Alignment.centerLeft);
    },
  );
}
