# PHASE 05 VISITOR & GATE MANAGEMENT SYSTEM REPORT — NIVAAS

**Phase**: Phase 05  
**Module**: Visitor & Gate Management System  
**Stack**: Flutter (Dart), Riverpod 2.x, FastAPI (Python), SQLAlchemy 2.0, Clean Architecture  
**Primary Users**: Security Guard / Watchman (`/watchman/home`)  
**Secondary Users**: Resident (Visitor Approvals), Admin (Visitor Audit & History)  

---

## 1. Executive Summary

Phase 05 introduces the **Visitor & Gate Management System** to Nivaas, completely replacing traditional paper visitor registers used in Indian housing societies. The module is built around speed, ease of use for non-technical gate personnel, offline resilience, and immediate resident notification hooks.

### Key Achievements:
- **15–20 Second Visitor Registration**: Ultra-fast registration form with quick-chips for entry purpose, auto-timestamp generation, wing/flat selector, vehicle number field, visitor counter, and photo/ID proof hooks.
- **Dedicated Watchman Dashboard (`/watchman/home`)**: Live gate clock, current date, live status counters (*Visitors Inside, Pending Approvals, Visitors Exited, Today Total Entries*), and large touch-target buttons.
- **Rapid Delivery Portal (`/visitor/delivery`)**: 1-Tap vendor chips for Swiggy, Zomato, Amazon, Flipkart, Blinkit, BigBasket, Courier, Milk, and Gas Cylinder.
- **Daily Staff & Frequent Visitors (`/visitor/frequent`)**: Quick re-entry portal for Maids, Drivers, Electricians, Plumbers, Technicians, and Tutors.
- **Emergency Gate Override (`/visitor/emergency`)**: 1-Tap emergency pass generation and gate barrier override for Ambulance, Police, Fire Brigade, and Society SOS.
- **Resident Approval Flow (`/visitor/approval`)**: Real-time visitor approval queue with `APPROVED`, `REJECTED`, and `WAITING_APPROVAL` status transitions.
- **Offline First & Outbox Sync**: Local caching via `SharedPreferences` and outbox queue (`VisitorLocalDataSource`) allowing offline visitor entry, delivery entry, check-in, check-out, and auto-sync upon network restoration.
- **Future QR Ready Architecture**: Prepared data models and UI hooks for Visitor QR, Resident QR, and Gate Scanning.

---

## 2. System Architecture & Data Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            FLUTTER MOBILE CLIENT                            │
├───────────────────────┬─────────────────────────────┬───────────────────────┤
│  Watchman Dashboard   │  Visitor Registration Form  │     Delivery Entry    │
│   (/watchman/home)    │    (/visitor/register)      │   (/visitor/delivery) │
└───────────┬───────────┴──────────────┬──────────────┴───────────┬───────────┘
            │                          │                          │
            ▼                          ▼                          ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          PRESENTATION / RIVERPOD                            │
│ gateNotifierProvider | visitorNotifierProvider | deliveryNotifierProvider    │
│      approvalNotifierProvider      |      historyNotifierProvider           │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                           REPOSITORY IMPLEMENTATION                         │
│                          (VisitorRepositoryImpl)                             │
├──────────────────────────────────────┬──────────────────────────────────────┤
│    Online (Network Connected)        │         Offline (Outbox Queue)       │
│               │                      │                   │                  │
│               ▼                      │                   ▼                  │
│   VisitorRemoteDataSource            │        VisitorLocalDataSource        │
│          (Dio HTTP)                  │     (SharedPreferences / Outbox)     │
└───────────────┬──────────────────────┴───────────────────┬──────────────────┘
                │                                          │
                ▼                                          ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                            FASTAPI BACKEND REST API                         │
│                    /api/v1/visitor/summary, /register,                      │
│                  /delivery, /emergency, /approve, /check-out                │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Repositories & Providers Created

### Domain Repositories (`lib/features/visitor/domain/repositories/visitor_repository.dart`)
1. **`VisitorRepository`**: Standard & Emergency visitor registration.
2. **`GateRepository`**: Live gate summary & check-in/check-out execution.
3. **`DeliveryRepository`**: Delivery partner entry & vendor tracking.
4. **`ApprovalRepository`**: Resident visitor approval / rejection queue.
5. **`HistoryRepository`**: Filtered timeline logs & frequent staff quick check-in.

### Riverpod Providers (`lib/features/visitor/presentation/providers/visitor_providers.dart`)
- `gateNotifierProvider`: Manages `GateSummary` live counters.
- `visitorNotifierProvider`: Handles visitor registration & emergency entries.
- `deliveryNotifierProvider`: Handles delivery entries.
- `approvalNotifierProvider`: Manages pending approval list & responses.
- `historyNotifierProvider`: Search & status filtered timeline.
- `frequentVisitorsProvider`: List of daily society staff.

---

## 4. Visitor Status Lifecycle

```
[VISITOR ARRIVES AT GATE]
           │
           ├────────────► GUEST / CAB / SERVICE
           │                   │
           │                   ▼
           │           WAITING_APPROVAL
           │             /          \
           │            /            \
           │       APPROVED        REJECTED
           │          │               │
           │          ▼               ▼
           │     CHECKED_IN      ENTRY DENIED
           │          │
           │          ▼
           │     CHECKED_OUT (Auto duration logged)
           │
           ├────────────► DELIVERY / FREQUENT / EMERGENCY
           │                   │
           │                   ▼
           └─────────────► CHECKED_IN (Auto Pass Code Generated)
```

---

## 5. Summary of Created Files

### Backend (`backend/app/`)
- `backend/app/models/visitor.py`: SQLAlchemy 2.0 models for `VisitorModel`, `VisitorLogModel`, `DeliveryLogModel`, `FrequentVisitorModel`.
- `backend/app/schemas/visitor.py`: Pydantic schemas for visitor payload validation & serialization.
- `backend/app/api/v1/endpoints/visitor.py`: FastAPI endpoints for `/summary`, `/register`, `/delivery`, `/emergency`, `/approve`, `/check-out`, `/history`.

### Mobile App (`mobile/lib/features/visitor/`)
- **Domain**:
  - `domain/entities/visitor.dart`
  - `domain/entities/visitor_log.dart`
  - `domain/entities/delivery_log.dart`
  - `domain/entities/frequent_visitor.dart`
  - `domain/entities/gate_summary.dart`
  - `domain/error/visitor_failures.dart`
  - `domain/repositories/visitor_repository.dart`
- **Data**:
  - `data/datasources/visitor_remote_datasource.dart`
  - `data/datasources/visitor_local_datasource.dart`
  - `data/repositories/visitor_repository_impl.dart`
- **Presentation**:
  - `presentation/providers/visitor_providers.dart`
  - `presentation/screens/watchman_dashboard_screen.dart`
  - `presentation/screens/visitor_registration_screen.dart`
  - `presentation/screens/delivery_entry_screen.dart`
  - `presentation/screens/frequent_visitors_screen.dart`
  - `presentation/screens/emergency_entry_screen.dart`
  - `presentation/screens/visitor_history_screen.dart`
  - `presentation/screens/visitor_approval_screen.dart`
- **Navigation & Routing**:
  - `mobile/lib/app/config/routes/route_names.dart`
  - `mobile/lib/app/config/routes/app_router.dart`
- **Testing**:
  - `mobile/test/features/visitor/visitor_test.dart`

---

## 6. Testing & Verification Results

1. **Static Code Analysis (`flutter analyze`)**:
   - `No issues found!` (0 errors, 0 warnings, 0 infos).
2. **Unit & Integration Test Suite (`flutter test`)**:
   - Passed 100% (All tests passing across Auth, Society Setup, Resident, and Visitor modules).

---

## 7. Future Extension Points (Phase 06 Preparation)

1. **Gate QR Scanner Integration**: Native camera scanning of visitor pre-approved QR passes and resident digital IDs.
2. **Push Notifications**: Real-time FCM / APNS push notifications to residents when visitors arrive.
3. **Phase 06 (Complaint System)**: Ready for integration without any changes to Visitor & Gate Management architecture.
