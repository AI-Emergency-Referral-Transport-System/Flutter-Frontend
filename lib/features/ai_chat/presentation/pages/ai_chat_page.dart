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
            child: BlocBuilder<AiChatCubit, AiChatState>(
              builder: (context, state) {
                if (state.messages.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Describe symptoms or tap Emergency on your home '
                        'screen. I will analyze and recommend hospitals when '
                        'needed.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final m = state.messages[index];
                    final time = DateFormat('h:mm a').format(m.timestamp);
                    return Align(
                      alignment: m.isMine
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.sizeOf(context).width * 0.8,
                        ),
                        decoration: BoxDecoration(
                          color: m.isMine
                              ? const Color(0xFFEAF8FF)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFD7EAF5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m.text),
                            const SizedBox(height: 6),
                            Text(
                              time,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          BlocBuilder<AiChatCubit, AiChatState>(
            builder: (context, state) {
              if (!state.showHospitalCta) return const SizedBox.shrink();
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
                    child: const Text('View recommended hospitals'),
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
                style: const TextStyle(color: Colors.red),
              ),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Type symptoms…',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  BlocBuilder<AiChatCubit, AiChatState>(
                    builder: (context, state) {
                      return IconButton.filled(
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
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.send),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
