/// Backend integration map (wire your Django/API to these paths and classes):
///
/// 1. **Base URL** — [AppConfig.baseUrl] (or `--dart-define=API_BASE_URL=...`).
///
/// 2. **Auth / OTP** — not HTTP yet: [OtpPage] uses a local placeholder until you
///    call your send-OTP and verify-OTP endpoints from `LoginPage` / signup flows.
///
/// 3. **AI chat** — [AppConfig.aiChatPath], POST body: `message`, `patient_id`,
///    `conversation_id`. Response: `reply`, `conversation_id`, `recommended_hospitals`
///    (see [HospitalRecommendation.fromJson]), optional `is_emergency`.
///    Implementation: [AiChatRepository.sendMessage].
///
/// 4. **Hospital selection** — [AppConfig.hospitalSelectionPath], POST:
///    `hospital_id`, `patient_id`, `conversation_id`.
///    Implementation: [AiChatRepository.selectHospital].
///
/// 5. **Notifications** — [AppConfig.notificationsPath], GET list for inbox.
///    Implementation: [NotificationRepository.fetchRemote].
///
/// 6. **Nearby hospitals** — add an endpoint and call it from
///    [NearbyHospitalsRepository] (currently local + GPS only; no `AppConfig` path yet).
///
/// 7. **Trips / live location / hospital capacity** — today: [TripCubit],
///    [HospitalOpsCubit] are in-memory. Replace with your WebSocket/realtime + REST
///    when the backend exists.
///
/// 8. **Dio client** — [ApiClient] in `lib/core/network/api_client.dart` (headers,
///    interceptors for JWT: add there).
///
/// 9. **Maps on Web** — `google_maps_flutter` needs the JS API in `web/index.html`
///    (`YOUR_WEB_MAPS_KEY`). Android uses `AndroidManifest.xml`; iOS uses `AppDelegate` + key.
class AppConfig {
  AppConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );

  static const String notificationsPath = '/api/notifications/';
  static const String aiChatPath = '/api/ai/chat/';
  static const String hospitalSelectionPath = '/api/hospitals/select/';
}
