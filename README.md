<h1 align="center" style="font-size: 70px; font-weight:bold; color:#E53935;">
AI Emergency Referral and Transport System
</h1>

<h3 align="center">
AI-powered real-time emergency coordination between patients, ambulances, and hospitals
</h3>

<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Arial+Black&size=30&duration=3500&pause=800&color=E53935&center=true&vCenter=true&width=1200&lines=AI+Emergency+System;Real-Time+Ambulance+Dispatch;Smart+Hospital+Recommendation;Life-Saving+Coordination+Platform" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Backend-Django-blue.svg">
  <img src="https://img.shields.io/badge/Frontend-Flutter-green.svg">
  <img src="https://img.shields.io/badge/Realtime-WebSocket-orange.svg">
  <img src="https://img.shields.io/badge/AI-Integrated-red.svg">
  <img src="https://img.shields.io/badge/License-MIT-lightgrey.svg">
</p>

---

<h2 align="center">System Overview</h2>

<p align="center">
A real-time AI-powered emergency medical system that connects patients, ambulances, and hospitals to minimize response time and optimize life-saving decisions.
</p>

---

<h2 align="center">User Roles</h2>

<table align="center">
<tr>
<th>Role</th>
<th>Description</th>
<th>Responsibilities</th>
</tr>

<tr>
<td>Patient</td>
<td>Emergency requester</td>
<td>Request help, track ambulance, select hospital</td>
</tr>

<tr>
<td>Ambulance Driver</td>
<td>Transport provider</td>
<td>Accept requests, navigate, update status</td>
</tr>

<tr>
<td>Hospital</td>
<td>Medical facility</td>
<td>Manage resources, prepare for incoming patients</td>
</tr>
</table>

---

<h2 align="center">System Architecture</h2>

```
Mobile App (Flutter)
   ├── Patient Dashboard
   ├── Ambulance Dashboard
   ├── Hospital Dashboard
   └── AI Assistant
           ↓
Django REST API
   ├── Users
   ├── Emergencies
   ├── Hospitals
   ├── Ambulances
   ├── AI Engine
           ↓
Database + Redis + WebSocket
```

---

<h2 align="center">Authentication Flow</h2>

<p align="center">
<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&size=24&duration=3000&pause=800&color=4CAF50&center=true&vCenter=true&width=900&lines=Phone+Number+%E2%86%92+OTP+Verification+%E2%86%92+Role+Selection+%E2%86%92+Dashboard" />
</p>

---

<h2 align="center">Core Features</h2>

| Feature | Description |
|--------|------------|
| Emergency Request | One-click emergency activation |
| AI Analysis | Detects emergency type and severity |
| Hospital Recommendation | Smart ranking system |
| Ambulance Dispatch | Finds nearest available unit |
| Real-Time Tracking | Live location updates |
| Resource Management | ICU beds, oxygen, ER status |
| Multi-role System | Patient, Driver, Hospital |

---

<h2 align="center">Emergency Flow</h2>

```
1. Patient submits emergency request
2. AI analyzes symptoms
3. System finds nearest ambulance
4. AI ranks hospitals
5. Hospital receives alert
6. Ambulance dispatched
7. Live tracking begins
8. Patient picked up
9. Hospital receives patient
10. Emergency completed
```

---

<h2 align="center">AI Intelligence Engine</h2>

### Emergency Classification
Input:
> Chest pain and difficulty breathing

Output:
- Type: Cardiac emergency
- Priority: High
- Action: Immediate dispatch

---

### Hospital Ranking Logic
```
Score =
  + Specialty match
  + Resource availability
  - Distance
  - Waiting time
```

---

<h2 align="center">Real-Time Tracking</h2>

```
Driver Location → WebSocket Server → Patient + Hospital Updates
```

---

<h2 align="center">API Structure</h2>

### Authentication
- /api/users/register/
- /api/users/verify-otp/
- /api/users/refresh-token/

### Emergency
- /api/emergencies/
- /api/emergencies/{id}/status/

### Ambulance
- /api/ambulances/find-nearest/
- /api/ambulances/{id}/location/

### Hospital
- /api/hospitals/suggest/
- /api/hospitals/{id}/resources/

### AI
- /api/ai/process-emergency/
- /api/ai/chat/

---

<h2 align="center">Data Models</h2>

### User
- Phone
- Role
- Medical history

### Emergency
- Type
- Priority
- Status lifecycle

### Hospital
- Beds
- ICU availability
- Oxygen level

### Ambulance
- Location
- Status
- Driver

---

<h2 align="center">Resource Management</h2>

```
Request → Lock Resource → Reserve → Assign → Release after completion
```

Prevents:
- Double booking ICU beds
- Resource conflicts
- Over-allocation

---

<h2 align="center">Installation</h2>

### Backend
```
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

### Mobile
```
cd mobile
flutter pub get
flutter run
```

---

<h2 align="center">Testing Flow</h2>

```
Register → Verify OTP → Create Emergency → AI Processing → Dispatch → Tracking → Completion
```

---

<h2 align="center">Future Enhancements</h2>

| Feature | Description |
|--------|------------|
| Voice AI Assistant | Voice-based emergency reporting |
| Predictive AI | Forecast emergency demand |
| Wearable Integration | Smartwatch emergency trigger |
| Offline Mode | Rural area support |
| Map Integration | Full GPS routing system |

---

<h2 align="center">Project Goal</h2>

To reduce emergency response time using AI-driven decision making, real-time tracking, and optimized hospital coordination.

---

<h2 align="center">License</h2>

MIT License

---

<h2 align="center">Acknowledgements</h2>

- Django REST Framework  
- Flutter SDK  
- WebSocket Technology  
- AI APIs (OpenAI, Gemini, HuggingFace)  

---
