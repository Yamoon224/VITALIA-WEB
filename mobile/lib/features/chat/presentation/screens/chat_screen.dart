import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitalia_mobile/features/auth/presentation/providers/auth_controller.dart';
import 'package:vitalia_mobile/features/chat/domain/entities/conversation_topic.dart';
import 'package:vitalia_mobile/features/chat/presentation/providers/chat_controller.dart';
import 'package:vitalia_mobile/features/chat/presentation/widgets/chat_input.dart';
import 'package:vitalia_mobile/features/emergency/presentation/screens/emergency_screen.dart';
import 'package:vitalia_mobile/shared/widgets/message_bubble.dart';
import 'package:vitalia_mobile/shared/widgets/warning_box.dart';

/// Écran complet (section 12 : testé comme une fonctionnalité de bout en
/// bout). Compose uniquement des widgets du design system ; aucune logique
/// métier ici (section 11.1).
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(chatControllerProvider.notifier)
          .start(ConversationTopic.consultation),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatControllerProvider);

    if (state.hasEmergency) {
      return EmergencyScreen(
        onAcknowledge: () =>
            ref.read(chatControllerProvider.notifier).acknowledgeEmergency(),
      );
    }

    final messages = state.conversation?.messages ?? const [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('VITALIA'),
        actions: [
          IconButton(
            tooltip: 'Consultation guidée',
            icon: const Icon(Icons.fact_check_outlined),
            onPressed: () => context.push('/consultation'),
          ),
          IconButton(
            tooltip: 'Dossier santé',
            icon: const Icon(Icons.folder_shared_outlined),
            onPressed: () => context.push('/health-record'),
          ),
          IconButton(
            tooltip: 'Bien-être',
            icon: const Icon(Icons.self_improvement_outlined),
            onPressed: () => context.push('/wellness'),
          ),
          IconButton(
            tooltip: 'Ordonnances',
            icon: const Icon(Icons.description_outlined),
            onPressed: () => context.push('/prescriptions'),
          ),
          IconButton(
            tooltip: 'Examens',
            icon: const Icon(Icons.biotech_outlined),
            onPressed: () => context.push('/examination'),
          ),
          IconButton(
            tooltip: 'Déconnexion',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: Column(
        children: [
          const WarningBox(
            message:
                "VITALIA informe et oriente, mais ne remplace pas un médecin. "
                "En cas de doute, consulte un professionnel de santé.",
          ),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    reverse: false,
                    itemCount: messages.length,
                    itemBuilder: (context, index) =>
                        MessageBubble(message: messages[index]),
                  ),
          ),
          ChatInput(
            isSending: state.isSendingMessage,
            onSubmit: (text) =>
                ref.read(chatControllerProvider.notifier).sendMessage(text),
          ),
        ],
      ),
    );
  }
}
