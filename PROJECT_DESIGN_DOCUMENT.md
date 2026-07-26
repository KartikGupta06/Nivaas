# MASTER PROJECT DESIGN DOCUMENT (PDD)
## Nivaas — Modern, Accessible, Offline-First Society Management Platform

**Document Version:** 1.0.0  
**Status:** Approved Architectural Blueprint  
**Authors:** Senior Product Architect, Senior Flutter Architect, Senior FastAPI Backend Engineer, Senior UI/UX Specialist, Senior Database Architect  
**Classification:** Core System Specification (Single Source of Truth)  
**Target Repository:** `KartikGupta06/Nivaas`

---

## Table of Contents
1. [Executive Summary](#1-executive-summary)
2. [Product Vision](#2-product-vision)
3. [Goals](#3-goals)
4. [Non-Goals](#4-non-goals)
5. [Target Audience](#5-target-audience)
6. [User Personas](#6-user-personas)
7. [User Roles](#7-user-roles)
8. [Role Permissions](#8-role-permissions)
9. [Complete Feature List](#9-complete-feature-list)
10. [Functional Requirements](#10-functional-requirements)
11. [Non-Functional Requirements](#11-non-functional-requirements)
12. [Future Roadmap](#12-future-roadmap)
13. [Design Philosophy](#13-design-philosophy)
14. [UI Principles](#14-ui-principles)
15. [Navigation Architecture](#15-navigation-architecture)
16. [Screen Hierarchy](#16-screen-hierarchy)
17. [Information Architecture](#17-information-architecture)
18. [Folder Structure](#18-folder-structure)
19. [Flutter Architecture](#19-flutter-architecture)
20. [Backend Architecture](#20-backend-architecture)
21. [Database Design Strategy](#21-database-design-strategy)
22. [Entity Relationship Overview](#22-entity-relationship-overview)
23. [API Strategy](#23-api-strategy)
24. [Authentication Flow](#24-authentication-flow)
25. [Authorization Flow](#25-authorization-flow)
26. [Offline-First Strategy](#26-offline-first-strategy)
27. [Synchronization Strategy](#27-synchronization-strategy)
28. [Notification Strategy](#28-notification-strategy)
29. [Security Strategy](#29-security-strategy)
30. [Error Handling Strategy](#30-error-handling-strategy)
31. [Logging Strategy](#31-logging-strategy)
32. [Analytics Strategy](#32-analytics-strategy)
33. [Accessibility Guidelines](#33-accessibility-guidelines)
34. [Performance Strategy](#34-performance-strategy)
35. [Design System](#35-design-system)
36. [Typography](#36-typography)
37. [Colors](#37-colors)
38. [Icons](#38-icons)
39. [Components](#39-components)
40. [Spacing System](#40-spacing-system)
41. [Responsive Rules](#41-responsive-rules)
42. [Coding Standards](#42-coding-standards)
43. [Naming Conventions](#43-naming-conventions)
44. [Git Workflow](#44-git-workflow)
45. [Branch Naming](#45-branch-naming)
46. [Commit Message Convention](#46-commit-message-convention)
47. [Environment Configuration](#47-environment-configuration)
48. [Deployment Strategy](#48-deployment-strategy)
49. [Release Strategy](#49-release-strategy)
50. [Testing Strategy](#50-testing-strategy)
51. [Risk Analysis](#51-risk-analysis)
52. [Assumptions](#52-assumptions)
53. [Technical Decisions Log (ADRs)](#53-technical-decisions-log-adrs)
54. [Future AI Features](#54-future-ai-features)
55. [Future Integrations](#55-future-integrations)
56. [Project Folder Layout](#56-project-folder-layout)
57. [Development Guidelines](#57-development-guidelines)
58. [Module Dependency Rules](#58-module-dependency-rules)
59. [Glossary](#59-glossary)
60. [References](#60-references)

---

## 1. Executive Summary

**Nivaas** (Hindi: निवास, meaning *Residence*) is an enterprise-grade, mobile-first, multi-tenant Society Management System designed explicitly for Indian residential apartments, gated communities, and housing societies (RWA - Resident Welfare Associations).

Existing products in the market suffer from excessive cognitive load, cluttered advertising, complex navigation, poor performance in low-connectivity areas (gateways/basements), and steep learning curves for senior citizens and non-tech-savvy gate guards.

Nivaas solves this problem by delivering a **zero-clutter, highly accessible, offline-first application** built with **Flutter (Android/iOS)** and a high-performance **FastAPI (Python)** backend, backed by **PostgreSQL** and an on-device reactive **Drift (SQLite)** local store.

---

## 2. Product Vision

To become the most reliable, intuitive, and accessible digital infrastructure for Indian residential communities, bridging the gap between elderly residents, busy professionals, society administrators, and security personnel through friction-free mobile interaction.

---

## 3. Goals

- **Extreme Usability**: Achieve 100% task completion rate for elderly residents (60+ years) performing core actions (approving visitors, paying bills, raising complaints) within 2 taps.
- **Sub-Second Gate Entry**: Enable security guards to record guest/delivery entries in under 5 seconds with zero network dependency.
- **Offline Resilience**: Guarantee 100% offline readability and outbox-queued mutations for gate logs and emergency alerts.
- **Multi-Tenant Scalability**: Support 50,000+ distinct housing societies on a single cost-optimized cloud deployment without data leakage between tenants.
- **High Performance**: Maintain sub-100ms API response time (95th percentile) and sub-1.5s mobile app cold start time.

---

## 4. Non-Goals

- **Social Media / Advertising Feed**: No community gossiping feeds, targeted ad networks, or third-party sponsored banners.
- **Futuristic / Gimmicky UI**: No glassmorphism, 3D elements, heavy particle animations, or complex gestures.
- **Single-Society Custom Builds**: No custom codebases per society; all customization must be configuration-driven via the central admin panel.
- **Desktop-First Mobile Ports**: No responsive web screens shoehorned into mobile screens. All interfaces are mobile-native first.

---

## 5. Target Audience

1. **Senior Citizen Residents (Age 60-80)**: Require high-contrast text, large touch targets, single-tap approvals, and zero technical jargon.
2. **Busy Professional Residents (Age 22-55)**: Require quick notification actions, rapid UPI payment integration, and instant complaint status updates.
3. **Security Guards / Watchmen (Age 20-60)**: Require single-screen entry forms, voice/OTP-assisted phone lookups, high readability under sunlight, and offline capability.
4. **Society Admins / Committee Members (Age 30-70)**: Require clear financial summaries, member management, broadcast announcements, and audit trails.

---

## 6. User Personas

### Persona A: Ramesh Sharma (Age 68, Retired Resident)
- **Tech Literacy**: Low (Uses WhatsApp, YouTube, UPI payments).
- **Primary Need**: Wants to approve delivery guards without getting up or navigating complex menus; needs clear font size and large buttons.
- **Pain Point**: Finds existing society apps confusing with too many popups, banners, and tiny icons.

### Persona B: Priya Nair (Age 32, Working Professional & Flat Owner)
- **Tech Literacy**: High.
- **Primary Need**: Wants to pay maintenance bills in 10 seconds via UPI, track complaint resolution status, and pre-approve weekend guests.
- **Pain Point**: Doesn't have time to call society office for routine complaints or bill queries.

### Persona C: Bahadur Singh (Age 42, Lead Security Guard)
- **Tech Literacy**: Moderate (Uses Android phone in Hindi/Regional language).
- **Primary Need**: Rapid guest logging at the gate; needs an interface that works even when society gate WiFi/cellular signal drops.
- **Pain Point**: App crashes or stalls during peak visitor hours (6 PM - 8 PM), causing long queues at the main gate.

---

## 7. User Roles

1. **System Administrator (Super Admin)**: Manages global SaaS tenants, society onboarding, platform health.
2. **Society Administrator (RWA Admin)**: Manages society profile, flat directory, billing generation, announcements, staff roles.
3. **Resident (Owner / Tenant)**: Manages family members, vehicles, pre-approvals, complaint creation, bill payments.
4. **Security Guard (Watchman)**: Logs entry/exit of visitors, deliveries, cabs, service providers; triggers gate alerts.
5. **Staff / Accountant (Future)**: Handles ledger entries, maintenance reconciliations, vendor invoices.

---

## 8. Role Permissions

| Feature / Action | Super Admin | Society Admin | Resident | Security Guard | Accountant (Future) |
| :--- | :---: | :---: | :---: | :---: | :---: |
| Onboard New Society | ✅ | ❌ | ❌ | ❌ | ❌ |
| Manage Society Profile | ✅ | ✅ | ❌ | ❌ | ❌ |
| Approve / Reject Resident | ✅ | ✅ | ❌ | ❌ | ❌ |
| View Flat Directory | ✅ | ✅ | ✅ (Limited) | ✅ (Unit Lookup) | ❌ |
| Log Gate Visitor Entry | ✅ | ❌ | ❌ | ✅ | ❌ |
| Pre-Approve Visitor | ✅ | ❌ | ✅ | ❌ | ❌ |
| Create Complaint | ✅ | ✅ | ✅ | ❌ | ❌ |
| Resolve / Close Complaint| ✅ | ✅ | ✅ (Own) | ❌ | ❌ |
| Issue Maintenance Bill | ✅ | ✅ | ❌ | ❌ | ✅ |
| Pay Maintenance Bill | ❌ | ❌ | ✅ | ❌ | ❌ |
| Broadcast Announcement | ✅ | ✅ | ❌ | ❌ | ❌ |
| Trigger Emergency Alert | ✅ | ✅ | ✅ | ✅ | ❌ |

---

## 9. Complete Feature List

1. **Visitor Management**:
   - Pre-approved visitor entry (QR / Access Code).
   - Delivery / Cab / Guest manual entry by Guard.
   - Real-time Push Notification approval request to Resident.
   - One-tap "Approve / Deny" from phone lock screen / notification banner.
   - Entry / Exit timestamp tracking with gate log history.

2. **Resident & Flat Management**:
   - Flat unit mapping (Block, Floor, Flat Number).
   - Owner vs. Tenant access control.
   - Family member profile linking.
   - Vehicle registry (Four-Wheeler / Two-Wheeler) with slot numbers.

3. **Maintenance & Billing**:
   - Monthly / Quarterly maintenance invoice generation.
   - Digital receipts & PDF download.
   - UPI Deep-linking & Payment Gateway integration.
   - Dues ledger & overdue reminders.

4. **Helpdesk & Complaints**:
   - Categorized complaint logging (Plumbing, Electrical, Elevator, Security, Noise).
   - Photo attachment support.
   - Status timeline (`Open` -> `In Progress` -> `Resolved` -> `Closed`).
   - Admin assignment to maintenance staff.

5. **Announcements & Notice Board**:
   - Official RWA notice broadcasts.
   - High-priority emergency alerts (Water cut, Power outage, AGMs).
   - Read receipt tracking for admins.

6. **Emergency & Gate SOS**:
   - Resident-to-Gate SOS panic button.
   - Gate-to-All-Residents emergency alert (Fire, Security Breach).
   - Instant phone call trigger to emergency contacts (Local Police, Ambulance, Society Office).

7. **Parking & Vehicle Lookup**:
   - Quick search vehicle number plate -> Flat Number lookup for blocked pathways.

---

## 10. Functional Requirements

- **FR-01**: The system MUST authenticate users via Phone Number + OTP with fallback to PIN/Password.
- **FR-02**: The mobile client MUST operate completely offline for gate visitor logging and cache recent 100 entries.
- **FR-03**: All API interactions MUST include `X-Society-ID` in headers, validated against JWT claims.
- **FR-04**: Resident notifications for visitor arrival MUST deliver within 2.5 seconds on 4G networks.
- **FR-05**: The UI MUST adjust typography dynamically based on user-selected font scale factor (up to 1.5x without UI overlap).
- **FR-06**: Receipts generated MUST be immutable and stored in S3/Supabase storage with signed public URLs expiring in 15 minutes.

---

## 11. Non-Functional Requirements

- **NFR-01 (Performance)**: App cold start under 1.5s on mid-tier Android devices (e.g., Snapdragon 680, 4GB RAM).
- **NFR-02 (Availability)**: 99.9% Uptime for core gate entry API endpoints.
- **NFR-03 (Security)**: Zero plain-text storage of user PII; DB encryption at rest (AES-256); TLS 1.3 in transit.
- **NFR-04 (Accessibility)**: Compliance with WCAG 2.1 Level AAA for color contrast (minimum 7:1) and touch target size (minimum 48x48 dp).
- **NFR-05 (Data Retainability)**: Gate logs retained for 90 days locally/cloud before automated archiving to cold storage.

---

## 12. Future Roadmap

- **Phase 1 (MVP)**: Visitor Entry, Resident Directory, Emergency SOS, Notice Board, Core RBAC.
- **Phase 2**: Maintenance Billing & UPI Payment Gateways, Complaint Management, Vehicle Search.
- **Phase 3**: Automated Gate Pass (OCR Plate Reader), Vendor / Daily Help Attendance (Maids, Drivers).
- **Phase 4**: Multi-language UI (Hindi, Marathi, Tamil, Telugu, Kannada, Bengali), AI Complaint Categorization & OCR Receipt Parsing.

---

## 13. Design Philosophy

Nivaas strictly adheres to a **Utility-First Accessible Design Philosophy**.

- **Anti-Patterns Explicitly Banned**:
  - NO Glassmorphism or blurry frosted glass effects.
  - NO Neumorphism or soft extruded shadows.
  - NO Gaming / Futuristic HUD elements.
  - NO Micro-animations that delay user action completion (>200ms duration).
  - NO Dark mode defaults that lower contrast for elderly vision.

- **Inspiration Sources**:
  - **Google Pay / PhonePe**: Large clean cards, unambiguous primary buttons, green/red success/alert indicators.
  - **WhatsApp**: Familiar single-list layout, intuitive bottom sheet prompts.
  - **Google Tasks**: Functional whitespace, clear checkboxes, zero cognitive bloat.

---

## 14. UI Principles

1. **Single Focus Per Screen**: Avoid cluttering multiple primary actions on one screen.
2. **High-Contrast Text Hierarchy**: Dark gray (`#1C1B1F`) on light off-white background (`#F8F9FA`).
3. **Explicit Labeling**: Every icon must have an accompanying text label. No icon-only buttons for critical actions.
4. **Thumb-Zone Optimization**: Place primary action buttons within the natural thumb reach area (bottom 35% of screen).
5. **Instant Feedback**: Every button press must show immediate ink spark/ripple or haptic response within 16ms.

---

## 15. Navigation Architecture

```
[ App Launch ] ──> [ Auth Guard ]
                          │
         ┌────────────────┴────────────────┐
         ▼                                 ▼
  [ Guard View ]                    [ Resident / Admin View ]
         │                                 │
  (Single Stream)           ┌──────────────┼──────────────┬──────────────┐
  - Visitor Log             ▼              ▼              ▼              ▼
  - Fast Check-In        [ Home ]      [ Services ]   [ Notices ]   [ Profile ]
  - Gate Alert           - Pre-Approve - Pay Bills    - RWA Feed    - Flat Info
                         - Visitor History - Complaints - SOS Alert - Settings
```

---

## 16. Screen Hierarchy

1. **Authentication**:
   - `SplashScreen` -> `PhoneInputScreen` -> `OtpVerificationScreen` -> `RoleSelectScreen` (if multi-role).
2. **Resident Core**:
   - `HomeScreen`: Quick action buttons (Pre-Approve, Emergency), Recent Visitors status.
   - `VisitorManagementScreen`: Active pre-approvals, Visitor history list, Add Pre-Approval sheet.
   - `BillingScreen`: Current dues card, Invoice history, Payment WebView / UPI Intent bottom sheet.
   - `HelpdeskScreen`: Active tickets, "Raise Ticket" modal, Resolution timeline.
   - `NoticeBoardScreen`: Pinned notices, Archive list.
3. **Watchman Core**:
   - `GuardGateScreen`: Large tap buttons ("Guest", "Delivery", "Cab", "Service").
   - `VisitorEntryFormSheet`: Flat lookup, Name, Phone, Photo capture (optional), Submit.
   - `ApprovalPendingScreen`: Countdown timer waiting for resident response.

---

## 17. Information Architecture

```
Nivaas App
├── Authentication
│   ├── Mobile Number Entry
│   ├── OTP Verification
│   └── Tenant/Society Selection
├── Home (Resident)
│   ├── Quick Visitor Approval Status
│   ├── Quick Emergency Button (SOS)
│   ├── Active Dues Summary Card
│   └── Pinned Notice Banner
├── Gate Pass / Visitors
│   ├── Pre-Approve Guest (Generates 6-Digit Code)
│   ├── Visitor Logs (Date filtered)
│   └── Frequent Delivery Vendors
├── Billing & Payments
│   ├── Pending Maintenance Invoices
│   ├── Payment History & PDF Download
│   └── Payment Gateway Linkage
├── Helpdesk
│   ├── New Ticket (Category, Description, Photo)
│   └── Ticket Status Tracker
└── Profile & Settings
    ├── Family Member Controls
    ├── Vehicle Records
    └── Font Size & Language Controls
```

---

## 18. Folder Structure (Monorepo Standard)

```
nivaas/
├── mobile/                  # Flutter Application Workspace
├── backend/                 # FastAPI Backend Workspace
├── docs/                    # Architectural Specifications & ADRs
├── deployments/             # Docker, Helm, CI/CD Configurations
└── README.md
```

---

## 19. Flutter Architecture

Nivaas uses **Feature-First Clean Architecture** combined with **Flutter BLoC** for state management.

```
lib/
├── main.dart
├── app/
│   ├── config/              # App themes, routes, constants
│   ├── observers/           # BlocObserver, RoutingObserver
│   └── service_locator.dart # GetIt Dependency Injection
├── core/
│   ├── error/               # Failures, Exceptions
│   ├── network/             # Dio client, Interceptors, ConnectivityInfo
│   ├── database/            # Drift DB definitions, DAOs, Migrations
│   ├── sync/                # Outbox Sync Engine, Queue Manager
│   └── utils/               # Formatters, Validators
└── features/                # Feature Modules
    ├── auth/
    ├── visitor/
    │   ├── data/
    │   │   ├── datasources/ # RemoteApi & LocalDriftDao
    │   │   ├── models/      # Json serializable DTOs
    │   │   └── repositories/# Repository Implementation
    │   ├── domain/
    │   │   ├── entities/    # Pure Dart Entities
    │   │   ├── repositories/# Repository Interfaces
    │   │   └── usecases/    # Business Logic UseCases
    │   └── presentation/
    │       ├── blocs/       # VisitorBloc, VisitorEvent, VisitorState
    │       ├── screens/     # VisitorListScreen, PreApproveScreen
    │       └── widgets/     # VisitorCard, EntryChip
    ├── billing/
    └── helpdesk/
```

---

## 20. Backend Architecture

The backend utilizes an **Async Layered Architecture** with **FastAPI**, **SQLAlchemy 2.0 (AsyncIO)**, and **Pydantic v2**.

```
backend/
├── app/
│   ├── main.py              # FastAPI app initialization & CORS middleware
│   ├── core/
│   │   ├── config.py        # Pydantic BaseSettings (.env reader)
│   │   ├── security.py      # JWT encoding/decoding, password hashing
│   │   └── database.py      # Async Engine, AsyncSession factory
│   ├── middleware/
│   │   ├── tenant_id.py     # Society Tenant Context Extractor
│   │   └── logging.py       # Request correlation ID logger
│   ├── api/
│   │   └── v1/              # API Version 1 Routers
│   │       ├── router.py
│   │       ├── endpoints/
│   │       │   ├── auth.py
│   │       │   ├── visitors.py
│   │       │   ├── billing.py
│   │       │   └── notices.py
    ├── models/              # SQLAlchemy Async Models (DB Schema)
    ├── schemas/             # Pydantic Validation Schemas (DTOs)
    ├── services/            # Core Business Logic Layer
    ├── repositories/        # Database Access Layer (Async Queries)
    └── workers/             # Celery / Arq Async Background Tasks (FCM Push)
```

---

## 21. Database Design Strategy

- **DBMS**: PostgreSQL 16+.
- **Multi-Tenancy Model**: **Shared Database, Discriminator Column (`society_id`)** with PostgreSQL **Row Level Security (RLS)** policies enforced at session initialization.
- **Indexing Strategy**: Every tenant table MUST have a composite primary index starting with `(society_id, id)` and index covering for `(society_id, created_at DESC)`.
- **Primary Keys**: UUIDv7 (Time-ordered 128-bit UUIDs) to prevent DB fragmentation during high-write sync bursts.

---

## 22. Entity Relationship Overview

```mermaid
erDiagram
    SOCIETY ||--o{ FLAT : contains
    SOCIETY ||--o{ USER : employs_or_houses
    FLAT ||--o{ RESIDENT_FLAT : maps
    USER ||--o{ RESIDENT_FLAT : belongs_to
    FLAT ||--o{ VISITOR_LOG : receives
    USER ||--o{ VISITOR_LOG : approves
    SOCIETY ||--o{ VISITOR_LOG : logs
    SOCIETY ||--o{ MAINTENANCE_BILL : issues
    FLAT ||--o{ MAINTENANCE_BILL : billed_to

    SOCIETY {
        uuid id PK
        string name
        string code
        string address
    }
    USER {
        uuid id PK
        string phone UNIQUE
        string full_name
        string role
    }
    FLAT {
        uuid id PK
        uuid society_id FK
        string block
        string flat_number
    }
    VISITOR_LOG {
        uuid id PK
        uuid society_id FK
        uuid flat_id FK
        string visitor_name
        string visitor_phone
        string entry_type
        string status
        timestamp entry_time
    }
    MAINTENANCE_BILL {
        uuid id PK
        uuid society_id FK
        uuid flat_id FK
        decimal amount
        string status
        date due_date
    }
```

---

## 23. API Strategy

- **Protocol**: RESTful API over HTTPS (TLS 1.3).
- **Format**: JSON (`application/json`) strictly formatted with Pydantic v2.
- **Headers Required**:
  - `Authorization: Bearer <JWT_ACCESS_TOKEN>`
  - `X-Society-ID: <SOCIETY_UUID>`
  - `X-App-Version: 1.0.0`
  - `X-Correlation-ID: <UUID>`

### Standard API Response Envelope:
```json
{
  "success": true,
  "statusCode": 200,
  "message": "Operation completed successfully",
  "data": {},
  "error": null,
  "timestamp": "2026-07-26T12:00:00Z"
}
```

---

## 24. Authentication Flow

```mermaid
sequenceDiagram
    autonumber
    actor Resident
    participant App as Mobile App (Flutter)
    participant API as FastAPI Backend
    participant SMS as Gateway Service (SMS)
    participant Redis as Redis Cache

    Resident->>App: Enter Mobile Number
    App->>API: POST /api/v1/auth/send-otp { phone }
    API->>Redis: Store OTP with 5-min TTL
    API->>SMS: Dispatch SMS with 6-digit OTP
    SMS-->>Resident: SMS received ("Your Nivaas OTP is 482910")
    Resident->>App: Enter OTP
    App->>API: POST /api/v1/auth/verify-otp { phone, otp }
    API->>Redis: Validate OTP match
    API->>API: Generate Access Token (15m) & Refresh Token (30d)
    API-->>App: Return JWT Pair + User Profile & Tenant Societies
    App->>App: Store Tokens in Flutter Secure Storage
```

---

## 25. Authorization Flow

1. **JWT Verification**: FastAPI `HTTPBearer` dependency decodes token signature via RS256 / HS256 key.
2. **Tenant Scope Check**: Extracted `society_id` from request header must match one of the authorized societies in the user's JWT claims list.
3. **Role Enforcement (RBAC)**: Custom FastAPI decorator `@requires_roles(["SOCIETY_ADMIN", "SUPER_ADMIN"])` inspects user role before handler execution.
4. **Row Level Isolation**: Database queries automatically attach `.where(Model.society_id == tenant_context.society_id)`.

---

## 26. Offline-First Strategy

Nivaas operates under an **Offline-First Paradigm** using **Drift (SQLite)** on device.

- **Reads**: UI reads exclusively from local Drift database tables via Dart reactive streams (`watch()`).
- **Writes**: User actions write to local Drift tables immediately and append a entry to an `outbox_queue` local table with `status = PENDING`.
- **UI Responsiveness**: UI updates in 0 milliseconds without waiting for server network roundtrips.

---

## 27. Synchronization Strategy

### Outbox Pattern Sync Flow:
```
[ UI Action ] ──> [ Write to Drift DB ] ──> [ Add to Outbox Queue (PENDING) ]
                                                        │
                                                        ▼
                                           [ Sync Manager Background ]
                                                        │
                                            (Network Connected?)
                                              /           \
                                            Yes            No
                                            /                \
                               [ POST Sync Payload ]      [ Wait for Connectivity ]
                                        │
                                (Server Ack 200)
                                        │
                             [ Mark Outbox COMPLETED ]
```

- **Conflict Resolution**: *Server-Wins with Local Draft Preservation*.
  - Incoming server state overrides local state unless local item has `is_user_edited = true`.
  - For visitor gate logs: Immutable log append strategy ensures no conflict can destroy history logs.

---

## 28. Notification Strategy

- **Provider**: Firebase Cloud Messaging (FCM) + APNs.
- **Priority Classes**:
  - **High Priority (Data Notification)**: Gate visitor arrival notification. Triggers full-screen alert dialog on Android and custom sound ringtone.
  - **Normal Priority**: Notice board updates, maintenance bill generated.
- **Silent Sync Signal**: Server sends silent data push to trigger immediate background Drift database pull when bill status changes.

---

## 29. Security Strategy

1. **Storage Security**: Flutter `FlutterSecureStorage` (EncryptedSharedPreferences on Android, Keychain on iOS).
2. **Network Security**: SSL Pinning via Dio certificates; TLS 1.3 transport encryption.
3. **API Protection**:
   - Rate limiting: Redis sliding window algorithm (Max 60 requests/minute per IP; 5 OTP attempts per hour).
   - CORS restricted strictly to authorized society domains.
4. **Data Sanitization**: Pydantic v2 strict input validation against SQL Injection, XSS, and parameter pollution.

---

## 30. Error Handling Strategy

- **Mobile Client**: BLoC catches failure domain objects (`NetworkFailure`, `CacheFailure`, `AuthFailure`) and transforms them into localized user-friendly snackbars or full-screen fallback states.
- **FastAPI Exception Middleware**: Catches all unhandled exceptions, logs full stacktrace internally with Correlation ID, and returns a sanitized JSON response:

```json
{
  "success": false,
  "statusCode": 400,
  "message": "Invalid visitor approval request",
  "error": {
    "code": "ERR_VISITOR_EXPIRED",
    "details": "The pre-approval code has expired."
  },
  "timestamp": "2026-07-26T12:00:00Z"
}
```

---

## 31. Logging Strategy

- **Format**: Structured JSON Logging via Python `structlog`.
- **Required Fields**: `timestamp`, `level`, `correlation_id`, `society_id`, `user_id`, `path`, `execution_time_ms`.
- **Audit Trails**: Critical security and financial actions (approving users, issuing bills, overriding gate lock) write to an immutable `audit_logs` table.

---

## 32. Analytics Strategy

- **Privacy-First**: No collection of resident phone numbers, names, or financial balances in analytics pipelines.
- **Tracked Metrics**:
  - Task Completion Time (e.g., Time taken from visitor push notification to Tap Approve).
  - Gate Entry Latency (Time taken by guard to process entry).
  - App Offline Duration & Outbox Sync Queue Length.

---

## 33. Accessibility Guidelines

- **Senior Citizen Optimization**:
  - Target Contrast Ratio: **WCAG 2.1 AAA (7:1)**.
  - Minimum touch target area: **48x48 dp**.
  - Font scaling support: Tested up to **200% font size** without text clipping.
  - Haptic feedback on critical actions (SOS trigger, gate entry approval).
  - Zero reliance on swipe-only gestures; all actions must have explicit clickable buttons.

---

## 34. Performance Strategy

- **App Cold Start**: < 1.5 seconds by lazy-initializing non-critical dependencies after first frame render.
- **List Optimization**: `ListView.builder` with pre-computed item extent for flat listings; zero heavy widget trees inside list cells.
- **Backend Response SLA**:
  - Read APIs: < 50ms (cached in Redis).
  - Write APIs: < 150ms.
- **Database Optimization**: `EXPLAIN ANALYZE` run on all queries; mandatory index on `(society_id, created_at)`.

---

## 35. Design System

Inspiration: **Google Pay & WhatsApp**. Clean off-white canvas, sharp contrast, clear borders, functional color coding.

- **Border Radius Standard**:
  - Cards: `8dp`
  - Input Fields: `8dp`
  - Buttons: `24dp` (Pill format for actions) / `8dp` (Block primary format)
- **Elevation**: Minimal. Maximum 2dp elevation for cards; zero drop-shadows on flat input fields.

---

## 36. Typography

Font Family: **Inter** (Primary) / **Roboto** (Fallback).

| Style Name | Font Weight | Size (sp) | Line Height | Usage |
| :--- | :--- | :--- | :--- | :--- |
| `DisplayLarge` | Bold (700) | 28 | 34 | Emergency Headers, OTP Numbers |
| `HeadingLarge` | SemiBold (600) | 22 | 28 | Screen Titles, Section Headers |
| `HeadingMedium` | SemiBold (600) | 18 | 24 | Card Headers, Flat Numbers |
| `BodyLarge` | Regular (400) | 16 | 22 | Primary Body Text, Form Labels |
| `BodyMedium` | Regular (400) | 14 | 20 | Subtitles, Secondary Details |
| `Caption` | Medium (500) | 12 | 16 | Status Chips, Timestamps |

---

## 37. Colors

Accessible HSL Palette tailored for readability under harsh sunlight.

```
Primary Brand:      #1A73E8 (Google Blue / Trust & Clarity)
Success / Approve:  #188038 (Deep Accessible Green)
Alert / Deny / SOS: #D93025 (Deep Accessible Red)
Warning / Pending:  #E37400 (Warm Amber)
Background Main:    #F8F9FA (Off-White Canvas)
Surface Card:       #FFFFFF (Pure White)
Text Primary:       #1C1B1F (High-Contrast Charcoal)
Text Secondary:     #49454F (Medium Slate)
Border Outline:     #C7C5D0 (Subtle Gray Border)
```

---

## 38. Icons

- **Library**: `Material Symbols Outlined` (Consistent 2dp stroke width).
- **Rule**: Icons must always be paired with a text label unless used in a standard navigation bottom bar.

---

## 39. Components

1. **`NivaasPrimaryButton`**: Large 48dp height button, solid background, high contrast text, progress spinner on async loading.
2. **`NivaasVisitorCard`**: Bordered card with visitor photo/avatar, visitor name, vehicle number, timestamp, and clear "Approve / Deny" side-by-side action buttons.
3. **`NivaasStatusChip`**: Color-coded pill badge indicating status (`APPROVED`, `PENDING`, `OVERDUE`).
4. **`NivaasEmergencyButton`**: High-visibility full-width red button with hold-to-confirm 2-second safety ring.

---

## 40. Spacing System

Based on a strict **8pt Grid System**:

```
Spacing-XS (4dp)   : Internal badge padding
Spacing-S  (8dp)   : Distance between icon and text
Spacing-M  (16dp)  : Standard screen margins & card internal padding
Spacing-L  (24dp)  : Distance between distinct card sections
Spacing-XL (32dp)  : Top screen header padding
```

---

## 41. Responsive Rules

- **Mobile Phones (< 600dp width)**: Single column layout. Floating action buttons locked to bottom right or bottom bar.
- **Tablets / Foldables (>= 600dp width)**: Dual-pane master-detail view for visitor logs and complaint resolution lists.

---

## 42. Coding Standards

- **Dart**: Strictly follow `flutter_lints`. Maximum 80 characters per line. Mandatory `const` constructors everywhere applicable.
- **Python**: Strictly follow `PEP 8` via `ruff` and `black`. Type hints mandatory on all function definitions (`mypy --strict`).

---

## 43. Naming Conventions

- **Dart**:
  - Files: `snake_case.dart`
  - Classes: `PascalCase`
  - Variables/Methods: `camelCase`
  - Constants: `kCamelCase`
- **Python**:
  - Files: `snake_case.py`
  - Classes: `PascalCase`
  - Functions/Variables: `snake_case`
  - Constants: `UPPER_SNAKE_CASE`

---

## 44. Git Workflow

Trunk-based development with short-lived feature branches. Direct commits to `main` are strictly blocked.

```
[ main ] (Production Ready)
   ▲
   │ (Pull Request + 2 Approvals + CI Pass)
[ feature/NV-102-visitor-approval ]
```

---

## 45. Branch Naming

Format: `<type>/<ticket-id>-<short-description>`

Examples:
- `feature/NV-42-outbox-sync-engine`
- `bugfix/NV-88-otp-timer-overflow`
- `chore/NV-12-upgrade-fastapi`

---

## 46. Commit Message Convention

Format: Conventional Commits spec: `<type>(<scope>): <short summary>`

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`.

Example:
`feat(visitor): implement outbox queueing for gate entries`

---

## 47. Environment Configuration

Managed via `.env` files (never committed to repository).

- `APP_ENV`: `development` | `staging` | `production`
- `DATABASE_URL`: `postgresql+asyncpg://user:pass@localhost:5432/nivaas_db`
- `REDIS_URL`: `redis://localhost:6379/0`
- `JWT_SECRET_KEY`: High-entropy 256-bit secret string.
- `FCM_SERVER_KEY`: Firebase messaging credentials.

---

## 48. Deployment Strategy

- **Backend**: Containerized via Docker multi-stage builds, orchestrated on AWS ECS / Google Cloud Run.
- **Database**: Managed PostgreSQL (AWS RDS / Supabase Postgres) with read replicas and automated daily snapshots.
- **Caching**: AWS ElastiCache Redis cluster.

---

## 49. Release Strategy

- **Android**: Google Play Store Staged Rollout (5% -> 15% -> 50% -> 100% over 7 days).
- **iOS**: Apple TestFlight for internal RWA beta testers before App Store submission.

---

## 50. Testing Strategy

```
           / \
          /   \     E2E Tests (Patrol / IntegrationTest) - 10%
         /-----\
        /       \   Widget & API Integration Tests - 30%
       /---------\
      /           \ Unit Tests (BlocTest, Pytest Async) - 60%
     --------------
```

- **Unit Test Coverage Target**: Minimum 80% business logic coverage for BLoCs, Repositories, FastAPI Services.
- **Contract Tests**: OpenAPI schema validation against frontend API models via `schemathesis`.

---

## 51. Risk Analysis

| Risk | Impact | Likelihood | Mitigation |
| :--- | :--- | :--- | :--- |
| Poor gate network causing delayed visitor alerts | High | High | Local Drift database logging + Outbox sync + Fallback to SMS notification |
| Elderly users struggling with App navigation | High | Moderate | Single-tap lockscreen notifications + 200% dynamic font scaling support |
| Data cross-leakage between housing societies | Critical | Low | Hardened PostgreSQL RLS + FastAPI Tenant Middleware assertion tests |

---

## 52. Assumptions

1. Primary users have access to an Android device running Android 8.0 (API Level 26) or higher.
2. Society gates have basic cell connectivity or local Wi-Fi, though temporary outages are expected.
3. Every flat owner/tenant possesses a valid Indian mobile number (+91) for OTP authentication.

---

## 53. Technical Decisions Log (ADRs)

- **ADR-001**: Selected Flutter BLoC over Riverpod due to explicit stream event logging requirements for financial and security operations.
- **ADR-002**: Selected Drift (SQLite) over Hive/Isar due to robust relational SQL capabilities, reactive stream queries, and schema migration support.
- **ADR-003**: Selected Shared Database with `society_id` Discriminator over Schema-per-tenant to optimize cloud infrastructure costs for 10,000+ small housing societies.

---

## 54. Future AI Features

- **Automated Gate License Plate Recognition (ANPR)**: On-device ML Kit / YOLO-v8 light model to scan vehicle registration plates at gate.
- **OCR Utility Invoice Parsing**: Scan electricity/water bills to automatically populate society accounting ledger entries.
- **Smart Visitor Anomaly Alerting**: Flag abnormal frequency of guest entries to specific flat units.

---

## 55. Future Integrations

- **UPI AutoPay / Payment Gateways**: Razorpay, Cashfree, PhonePe Intent integrations for zero-friction maintenance payments.
- **WhatsApp Business API**: Fallback visitor approval requests sent directly to resident WhatsApp chat if app notification is unacknowledged after 30 seconds.
- **Smart Hardware Interlocking**: IoT Relay triggers to open automatic gate barriers upon approval.

---

## 56. Project Folder Layout

```
Nivaas/
├── PROJECT_DESIGN_DOCUMENT.md  # THIS MASTER DOCUMENT
├── .gitignore
├── README.md
├── mobile/                     # Flutter Mobile Project Root
│   ├── pubspec.yaml
│   ├── android/
│   ├── ios/
│   └── lib/
└── backend/                    # FastAPI Backend Project Root
    ├── pyproject.toml
    ├── Dockerfile
    ├── alembic/
    └── app/
```

---

## 57. Development Guidelines

1. **Never write business logic inside UI Widgets**. All state mutations must be dispatched as events to a BLoC.
2. **Never execute direct raw SQL strings**. Always use SQLAlchemy 2.0 ORM or type-safe Drift DAOs.
3. **Always pass tenant context**. Every repository method must require `society_id` as an explicit non-null parameter.

---

## 58. Module Dependency Rules

- `Domain` layer must NEVER import from `Data` or `Presentation` layers.
- `Presentation` layer depends only on `Domain` use cases and BLoC states.
- `Features` must never directly import another feature's data layer; cross-feature communication occurs via core event buses or shared domain entities.

---

## 59. Glossary

- **RWA**: Resident Welfare Association (Governing body of an Indian housing society).
- **Outbox Pattern**: Design pattern where database changes and sync events are saved in a single local transaction before being transmitted asynchronously.
- **Discriminator Column**: A table column (`society_id`) used to distinguish which tenant owns a given record in a shared database.
- **RLS**: Row-Level Security in PostgreSQL.

---

## 60. References

1. Flutter Clean Architecture Best Practices (ResoCoder / Official Guidelines).
2. FastAPI Async SQLAlchemy 2.0 Documentation.
3. Material Design 3 Accessibility Guidelines (Google).
4. OWASP Mobile Application Security Verification Standard (MASVS).
