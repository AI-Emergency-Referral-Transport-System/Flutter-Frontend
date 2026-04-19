# Frontend

## Folder Structure
```
lib/
├── app/
│   ├── app_router.dart
│   ├── app_theme.dart
│   ├── injection_container.dart
│   └── main_app_shell.dart
│
├── core/
│   ├── di/
│   │   └── feature_injection.dart
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   |   ├── api_client.dart
│   |    └── network_info.dart
│   ├── constants/
│   │   ├── constants.dart  
│   ├── utils/
│   │   ├── app_utils.dart
│   └── widgets/
│       ├── common_widgets.dart   
│
├── features/
│   │
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_remote_ds.dart
│   │   │   │   └── auth_local_ds.dart
│   │   │   ├── models/
│   │   │   │   ├── user_model.dart
│   │   │   │   ├── patient_model.dart
│   │   │   │   ├── driver_model.dart
│   │   │   │   └── hospital_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── user_entity.dart
│   │   │   │   ├── patient_entity.dart
│   │   │   │   ├── driver_entity.dart
│   │   │   │   └── hospital_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── sign_in_with_phone.dart
│   │   │       ├── verify_otp.dart
│   │   │       ├── sign_up_patient.dart
│   │   │       ├── sign_up_driver.dart
│   │   │       ├── sign_up_hospital.dart
│   │   │       └── logout.dart
│   │   │
│   │   └── presentation/
│   │       ├── bloc/                    
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       ├── pages/
│   │       │   ├── role_selection_page.dart
│   │       │   ├── login_page.dart
│   │       │   ├── otp_verification_page.dart
│   │       │   ├── patient_signup_page.dart
│   │       │   ├── driver_signup_page.dart
│   │       │   └── hospital_signup_page.dart
│   │       └── widgets/
│   │           ├── role_card.dart
│   │           └── otp_input_field.dart
│   │
│   ├── patient/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── patient_remote_ds.dart
│   │   │   │   └── patient_local_ds.dart
│   │   │   ├── models/
│   │   │   │   ├── patient_profile_model.dart
│   │   │   │   └── medical_info_model.dart
│   │   │   └── repositories/
│   │   │       └── patient_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── patient_entity.dart
│   │   │   │   └── medical_info_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── patient_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_patient_profile.dart
│   │   │       ├── update_patient_profile.dart
│   │   │       └── get_recent_activities.dart
│   │   │
│   │   └── presentation/
│   │       ├── bloc/                    
│   │       │   ├── patient_bloc.dart
│   │       │   ├── patient_event.dart
│   │       │   └── patient_state.dart
│   │       ├── pages/
│   │       │   ├── patient_home_page.dart
│   │       │   └── patient_profile_page.dart
│   │       └── widgets/
│   │           ├── hospital_card.dart
│   │           └── activity_tile.dart
│   │
│   ├── ai_chat/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── chat_remote_ds.dart
│   │   │   ├── models/
│   │   │   │   └── chat_message_model.dart
│   │   │   └── repositories/
│   │   │       └── chat_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── chat_message_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── chat_repository.dart
│   │   │   └── usecases/
│   │   │       ├── send_message.dart
│   │   │       └── analyze_symptoms.dart
│   │   │
│   │   └── presentation/
│   │       ├── bloc/                    
│   │       │   ├── chat_bloc.dart
│   │       │   ├── chat_event.dart
│   │       │   └── chat_state.dart
│   │       ├── pages/
│   │       │   └── ai_chat_page.dart
│   │       └── widgets/
│   │           ├── chat_bubble.dart
│   │           └── typing_indicator.dart
│   │
│   ├── hospital/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── hospital_remote_ds.dart
│   │   │   ├── models/
│   │   │   │   ├── hospital_model.dart
│   │   │   │   └── hospital_resource_model.dart
│   │   │   └── repositories/
│   │   │       └── hospital_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── hospital_entity.dart
│   │   │   │   └── hospital_resource_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── hospital_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_nearby_hospitals.dart
│   │   │       ├── update_resources.dart
│   │   │       └── acknowledge_emergency.dart
│   │   │
│   │   └── presentation/
│   │       ├── bloc/                    
│   │       │   ├── hospital_bloc.dart
│   │       │   ├── hospital_event.dart
│   │       │   └── hospital_state.dart
│   │       ├── pages/
│   │       │   └── hospital_dashboard_page.dart
│   │       └── widgets/
│   │           ├── resource_card.dart
│   │           └── checklist_tile.dart
│   │
│   ├── ambulance/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── ambulance_remote_ds.dart
│   │   │   ├── models/
│   │   │   │   ├── trip_model.dart
│   │   │   │   └── emergency_request_model.dart
│   │   │   └── repositories/
│   │   │       └── ambulance_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── trip_entity.dart
│   │   │   │   └── emergency_request_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── ambulance_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_incoming_requests.dart
│   │   │       ├── accept_request.dart
│   │   │       ├── update_trip_status.dart
│   │   │       └── arrived_at_patient.dart
│   │   │
│   │   └── presentation/
│   │       ├── bloc/                   
│   │       │   ├── ambulance_bloc.dart
│   │       │   ├── ambulance_event.dart
│   │       │   └── ambulance_state.dart
│   │       ├── pages/
│   │       │   ├── driver_home_page.dart
│   │       │   └── active_trip_page.dart
│   │       └── widgets/
│   │           ├── request_card.dart
│   │           └── trip_status_stepper.dart
│   │
│   ├── tracking/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── tracking_remote_ds.dart
│   │   │   ├── models/
│   │   │   │   └── location_model.dart
│   │   │   └── repositories/
│   │   │       └── tracking_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── location_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── tracking_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_live_location.dart
│   │   │       └── get_eta.dart
│   │   │
│   │   └── presentation/
│   │       ├── bloc/                    
│   │       │   ├── tracking_bloc.dart
│   │       │   ├── tracking_event.dart
│   │       │   └── tracking_state.dart
│   │       ├── pages/
│   │       │   └── live_tracking_page.dart
│   │       └── widgets/
│   │           └── custom_map.dart
│   │
│   ├── notification/
│   │   ├── data/
│   │   │   └── datasources/
│   │   │       └── notification_remote_ds.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── notification_entity.dart
│   │   │   └── usecases/
│   │   │       └── get_notifications.dart
│   │   └── presentation/
│   │       ├── bloc/                   
│   │       │   ├── notification_bloc.dart
│   │       │   ├── notification_event.dart
│   │       │   └── notification_state.dart
│   │       └── pages/
│   │           └── notifications_page.dart
│   │
│   └── profile/
│       ├── data/
│       │   └── datasources/
│       │       └── profile_remote_ds.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── profile_entity.dart
│       │   └── usecases/
│       │       ├── get_profile.dart
│       │       └── update_profile.dart
│       └── presentation/
│           ├── bloc/                    
│           │   ├── profile_bloc.dart
│           │   ├── profile_event.dart
│           │   └── profile_state.dart
│           ├── pages/
│           │   └── profile_page.dart
│           └── widgets/
│               └── profile_menu_tile.dart
│
└── main.dart
```