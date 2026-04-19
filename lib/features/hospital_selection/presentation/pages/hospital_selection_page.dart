import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../ai_chat/presentation/cubit/ai_chat_cubit.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../hospital_ops/presentation/cubit/hospital_ops_cubit.dart';
import '../../../notifications/domain/models/notification_item.dart';
import '../../../notifications/presentation/cubit/notifications_cubit.dart';
import '../../../tracking/presentation/pages/patient_tracking_page.dart';
import '../../../trip/presentation/cubit/trip_cubit.dart';

class HospitalSelectionPage extends StatelessWidget {
  const HospitalSelectionPage({super.key});

  String _lastUserSummary(AiChatState chat) {
    for (final m in chat.messages.reversed) {
      if (m.isMine) return m.text;
    }
    return 'Emergency referral';
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<AiChatCubit>().state;
    final auth = context.watch<AuthCubit>().state.user;
    final items = chat.recommendations;

    return Scaffold(
      appBar: AppBar(title: const Text('Select hospital')),
      body: items.isEmpty
          ? const Center(
              child: Text('No recommendations yet. Chat with AI first.'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final h = items[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          h.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(h.address),
                        const SizedBox(height: 4),
                        Text(
                          '${h.distanceKm?.toStringAsFixed(1) ?? '--'} km • '
                          '${h.rating?.toStringAsFixed(1) ?? '--'} ★',
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () async {
                              final patientId = auth?.id ?? 'guest';
                              final ai = context.read<AiChatCubit>();
                              final tripCubit = context.read<TripCubit>();
                              final hospitalOps = context.read<HospitalOpsCubit>();
                              final notifications =
                                  context.read<NotificationsCubit>();
                              final messenger = ScaffoldMessenger.of(context);
                              final nav = Navigator.of(context);

                              await ai.selectHospital(
                                h,
                                patientId: patientId,
                              );
                              if (!context.mounted) return;
                              final fresh = context.read<AiChatCubit>().state;
                              final summary = _lastUserSummary(fresh);
                              final reqId = tripCubit.createOpenRequest(
                                patientName: auth?.name ?? 'Patient',
                                patientId: patientId,
                                summary: summary,
                                hospital: h,
                                conversationId: fresh.conversationId.isEmpty
                                    ? null
                                    : fresh.conversationId,
                              );
                              hospitalOps.registerIncoming(
                                hospitalId: h.id,
                                patientName: auth?.name ?? 'Patient',
                                summary: summary,
                                tripPhase: TripPhase.awaitingDriverAcceptance,
                                requestId: reqId,
                              );
                              hospitalOps.reserveBed();
                              notifications.pushLocal(
                                NotificationItem(
                                  id:
                                      'sel-${DateTime.now().millisecondsSinceEpoch}',
                                  title: 'Hospital notified',
                                  body:
                                      '${h.name} is preparing for your arrival.',
                                  createdAt: DateTime.now(),
                                  channel: NotificationChannel.emergency,
                                ),
                              );
                              notifications.pushLocal(
                                NotificationItem(
                                  id:
                                      'hos-${DateTime.now().millisecondsSinceEpoch}',
                                  title: 'Incoming patient',
                                  body:
                                      '${auth?.name ?? 'Patient'} selected your facility.',
                                  createdAt: DateTime.now(),
                                  channel: NotificationChannel.request,
                                ),
                              );
                              notifications.pushLocal(
                                NotificationItem(
                                  id: 'drv-$reqId',
                                  title: 'Incoming ambulance request',
                                  body:
                                      'New referral to ${h.name}. Open Requests to accept.',
                                  createdAt: DateTime.now(),
                                  channel: NotificationChannel.request,
                                ),
                              );
                              if (!context.mounted) return;
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${h.name} reserved a bed. Track ambulance live.',
                                  ),
                                ),
                              );
                              nav.pushReplacement(
                                MaterialPageRoute<void>(
                                  builder: (_) => const PatientTrackingPage(),
                                ),
                              );
                            },
                            child: const Text('Select'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
