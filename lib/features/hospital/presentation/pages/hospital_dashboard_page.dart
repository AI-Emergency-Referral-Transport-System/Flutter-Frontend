import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../hospital_ops/presentation/cubit/hospital_ops_cubit.dart';
import '../../../trip/presentation/cubit/trip_cubit.dart';
import 'hospital_patient_detail_page.dart';

class HospitalDashboardPage extends StatelessWidget {
  const HospitalDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthCubit>().state.user;
    final ops = context.watch<HospitalOpsCubit>().state;
    final linked = auth?.linkedHospitalId;

    final incoming = ops.incoming
        .where(
          (p) => linked == null || p.hospitalId == linked,
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Hospital dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Resource availability',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Adjust counts your team can assign right now.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
              child: Row(
                children: [
                  Icon(
                    Icons.local_hospital_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Beds, ICU & oxygen',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Beds ${ops.resources.bedsAvailable} · '
                          'ICU ${ops.resources.icuAvailable} · '
                          'Oxygen ${ops.resources.oxygenUnitsAvailable}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Edit beds, ICU & oxygen',
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () =>
                        _showResourceEditDialog(context, ops.resources),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _RoomsAndSlotsSection(
            rooms: ops.resources.roomsAvailable,
            slots: ops.resources.capacityTimeSlots,
            onRoomsChanged: (v) =>
                context.read<HospitalOpsCubit>().updateResources(rooms: v),
            onSlotsChanged: (list) => context
                .read<HospitalOpsCubit>()
                .updateResources(capacityTimeSlots: list),
          ),
          const SizedBox(height: 24),
          Text(
            'Incoming patients',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          if (incoming.isEmpty)
            Text(
              'No active referrals for your facility.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ...incoming.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _IncomingRequestCard(patient: p),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomsAndSlotsSection extends StatefulWidget {
  const _RoomsAndSlotsSection({
    required this.rooms,
    required this.slots,
    required this.onRoomsChanged,
    required this.onSlotsChanged,
  });

  final int rooms;
  final List<String> slots;
  final ValueChanged<int> onRoomsChanged;
  final ValueChanged<List<String>> onSlotsChanged;

  @override
  State<_RoomsAndSlotsSection> createState() => _RoomsAndSlotsSectionState();
}

class _RoomsAndSlotsSectionState extends State<_RoomsAndSlotsSection> {
  late final TextEditingController _roomsCtrl;

  @override
  void initState() {
    super.initState();
    _roomsCtrl = TextEditingController(text: '${widget.rooms}');
  }

  @override
  void didUpdateWidget(covariant _RoomsAndSlotsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rooms != widget.rooms &&
        int.tryParse(_roomsCtrl.text.trim()) != widget.rooms) {
      _roomsCtrl.text = '${widget.rooms}';
    }
  }

  @override
  void dispose() {
    _roomsCtrl.dispose();
    super.dispose();
  }

  void _commitRooms() {
    final n = int.tryParse(_roomsCtrl.text.trim());
    if (n != null && n >= 0) widget.onRoomsChanged(n);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final slots = widget.slots;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.meeting_room_outlined, color: scheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Rooms & capacity windows',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'General rooms available and ER intake time bands.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _roomsCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Available rooms',
                hintText: 'e.g. 12',
              ),
              onSubmitted: (_) => _commitRooms(),
              onEditingComplete: _commitRooms,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Time slots',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < slots.length; i++)
                  InputChip(
                    label: Text(slots[i]),
                    onDeleted: () {
                      final next = [...slots]..removeAt(i);
                      widget.onSlotsChanged(next);
                    },
                  ),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 18),
                  label: const Text('Add slot'),
                  onPressed: () async {
                    final next = await _promptNewSlot(context, slots);
                    if (next != null) widget.onSlotsChanged(next);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _showResourceEditDialog(
  BuildContext context,
  HospitalResources resources,
) async {
  final bedsCtrl = TextEditingController(text: '${resources.bedsAvailable}');
  final icuCtrl = TextEditingController(text: '${resources.icuAvailable}');
  final o2Ctrl = TextEditingController(text: '${resources.oxygenUnitsAvailable}');
  try {
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit capacity'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: bedsCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Available beds',
                    hintText: 'Previously saved value can be changed here',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: icuCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'ICU bays available',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: o2Ctrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Oxygen units available',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final b = int.tryParse(bedsCtrl.text.trim());
                final i = int.tryParse(icuCtrl.text.trim());
                final o = int.tryParse(o2Ctrl.text.trim());
                if (b == null || i == null || o == null || b < 0 || i < 0 || o < 0) {
                  return;
                }
                ctx.read<HospitalOpsCubit>().updateResources(
                  beds: b.clamp(0, 999),
                  icu: i.clamp(0, 999),
                  oxygen: o.clamp(0, 999),
                );
                Navigator.pop(ctx, true);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    if (saved == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Capacity updated')),
      );
    }
  } finally {
    bedsCtrl.dispose();
    icuCtrl.dispose();
    o2Ctrl.dispose();
  }
}

Future<List<String>?> _promptNewSlot(
  BuildContext context,
  List<String> current,
) async {
  final ctrl = TextEditingController();
  final label = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Add time window'),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'e.g. 20:00–23:00',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
          child: const Text('Add'),
        ),
      ],
    ),
  );
  if (label == null || label.isEmpty) return null;
  return [...current, label];
}

class _IncomingRequestCard extends StatelessWidget {
  const _IncomingRequestCard({required this.patient});

  final HospitalIncomingPatient patient;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.patientName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        patient.summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Status: ${patient.tripPhase.name}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Open details',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            HospitalPatientDetailPage(patient: patient),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            if (patient.reservationFinalized) ...[
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  avatar: Icon(Icons.check_circle, size: 18, color: scheme.primary),
                  label: const Text('Bed reservation finalized'),
                ),
              ),
            ] else ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<TripCubit>().driverDecline(patient.id);
                        context.read<HospitalOpsCubit>().removeIncoming(
                          patient.id,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Request declined'),
                          ),
                        );
                      },
                      child: const Text('Decline'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        final ok = context
                            .read<HospitalOpsCubit>()
                            .acceptIncomingReservation(patient.id);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              ok
                                  ? 'Request accepted — bed reserved.'
                                  : 'No available beds to accept this request.',
                            ),
                          ),
                        );
                      },
                      child: const Text('Accept Request'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

