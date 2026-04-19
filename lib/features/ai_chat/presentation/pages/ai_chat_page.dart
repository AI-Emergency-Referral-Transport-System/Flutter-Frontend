import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../hospital_selection/presentation/pages/hospital_selection_page.dart';
import '../cubit/ai_chat_cubit.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key, this.showBackButton = false});

  final bool showBackButton;

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authId = context.watch<AuthCubit>().state.user?.id;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final chatCanvas = theme.brightness == Brightness.dark
        ? const Color(0xFF1A1F26)
        : const Color(0xFFEEF2F6);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('AI assistant'),
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    chatCanvas,
                    scheme.surface,
                  ],
                ),
              ),
              child: BlocBuilder<AiChatCubit, AiChatState>(
                builder: (context, state) {
                  if (state.messages.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 24,
                        ),
                        child: Text(
                          'Describe symptoms or tap Emergency on your home '
                          'screen. I can recommend hospitals plus nearby '
                          'ambulances and drivers when appropriate.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.45,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final m = state.messages[index];
                      return _ChatBubble(
                        text: m.text,
                        time: DateFormat('h:mm a').format(m.timestamp),
                        isMine: m.isMine,
                      );
                    },
                  );
                },
              ),
            ),
          ),
          BlocBuilder<AiChatCubit, AiChatState>(
            builder: (context, state) {
              if (!state.showHospitalCta) return const SizedBox.shrink();
              final hasH = state.recommendations.isNotEmpty;
              final hasT = state.transportRecommendations.isNotEmpty;
              final ctaLabel = hasH && hasT
                  ? 'View hospitals & ambulances'
                  : hasH
                      ? 'View recommended hospitals'
                      : 'View ambulances & drivers';
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const HospitalSelectionPage(),
                        ),
                      );
                    },
                    child: Text(ctaLabel),
                  ),
                ),
              );
            },
          ),
          if (context.watch<AiChatCubit>().state.errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                context.watch<AiChatCubit>().state.errorMessage!,
                style: TextStyle(color: scheme.error),
              ),
            ),
          Material(
            elevation: 8,
            shadowColor: Colors.black26,
            color: scheme.surface,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 4,
                        style: theme.textTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText: 'Type symptoms…',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    BlocBuilder<AiChatCubit, AiChatState>(
                      builder: (context, state) {
                        return IconButton.filled(
                          style: IconButton.styleFrom(
                            fixedSize: const Size(48, 48),
                          ),
                          onPressed: state.isSending
                              ? null
                              : () {
                                  final text = _controller.text;
                                  _controller.clear();
                                  context.read<AiChatCubit>().sendMessage(
                                    text,
                                    patientId: authId,
                                  );
                                },
                          icon: state.isSending
                              ? SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: scheme.onPrimary,
                                  ),
                                )
                              : Icon(Icons.send_rounded, color: scheme.onPrimary),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.text,
    required this.time,
    required this.isMine,
  });

  final String text;
  final String time;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final maxW = MediaQuery.sizeOf(context).width * 0.82;

    final bubbleColor = isMine
        ? scheme.primaryContainer
        : scheme.surfaceContainerHighest;
    final onBubble = isMine
        ? scheme.onPrimaryContainer
        : scheme.onSurface;

    final radius = BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomLeft: Radius.circular(isMine ? 20 : 6),
      bottomRight: Radius.circular(isMine ? 6 : 20),
    );

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: maxW),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: theme.brightness == Brightness.dark ? 0.35 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: onBubble,
                height: 1.4,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              time,
              style: theme.textTheme.labelSmall?.copyWith(
                color: onBubble.withValues(alpha: 0.55),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
