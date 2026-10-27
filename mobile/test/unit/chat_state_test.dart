import 'package:flutter_test/flutter_test.dart';
import 'package:vitalia_mobile/features/chat/presentation/providers/chat_state.dart';

void main() {
  group('ChatState', () {
    test('has no emergency by default', () {
      const state = ChatState();

      expect(state.hasEmergency, isFalse);
    });

    test('flags an emergency once a non-null urgency level is set', () {
      const state = ChatState(urgencyLevel: 'emergency');

      expect(state.hasEmergency, isTrue);
    });

    test('copyWith preserves fields that are not overridden', () {
      const state = ChatState(isLoading: true);

      final updated = state.copyWith(isSendingMessage: true);

      expect(updated.isLoading, isTrue);
      expect(updated.isSendingMessage, isTrue);
    });
  });
}
