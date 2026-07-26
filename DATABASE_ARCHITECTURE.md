# DATABASE ARCHITECTURE SPECIFICATION
## Nivaas — Scalable Multi-Tenant Database Architecture for Indian Housing Societies

**Document Version:** 1.0.0  
**Status:** Approved Technical Reference (Single Source of Truth)  
**Target Engine:** PostgreSQL 16+ (PostgreSQL with Asyncpg / SQLAlchemy 2.0)  
**Authors:** Principal Database Architect, Senior SaaS Architect, Senior PostgreSQL Engineer  
**Target Repository:** `KartikGupta06/Nivaas`

---

## Table of Contents
1. [Database Philosophy](#1-database-philosophy)
2. [Database Goals](#2-database-goals)
3. [Architectural Principles](#3-architectural-principles)
4. [PostgreSQL Justification](#4-postgresql-justification)
5. [Multi-Tenant Strategy](#5-multi-tenant-strategy)
6. [Data Isolation Strategy](#6-data-isolation-strategy)
7. [High Level Entity Overview](#7-high-level-entity-overview)
8. [Relationship Strategy](#8-relationship-strategy)
9. [Naming Convention](#9-naming-convention)
10. [Primary Key Strategy](#10-primary-key-strategy)
11. [Foreign Key Strategy](#11-foreign-key-strategy)
12. [Soft Delete Strategy](#12-soft-delete-strategy)
13. [Timestamp Strategy](#13-timestamp-strategy)
14. [Status Fields Strategy](#14-status-fields-strategy)
15. [File Storage Strategy](#15-file-storage-strategy)
16. [Image Storage Strategy](#16-image-storage-strategy)
17. [Offline-First Data Model](#17-offline-first-data-model)
18. [Synchronization Strategy](#18-synchronization-strategy)
19. [Conflict Resolution](#19-conflict-resolution)
20. [Versioning Strategy](#20-versioning-strategy)
21. [Caching Strategy](#21-caching-strategy)
22. [Indexing Strategy](#22-indexing-strategy)
23. [Search Strategy](#23-search-strategy)
24. [Pagination Strategy](#24-pagination-strategy)
25. [Archival Strategy](#25-archival-strategy)
26. [Backup Strategy](#26-backup-strategy)
27. [Disaster Recovery Considerations](#27-disaster-recovery-considerations)
28. [Security Considerations](#28-security-considerations)
29. [Audit Logging](#29-audit-logging)
30. [Performance Considerations](#30-performance-considerations)
31. [Scalability Considerations](#31-scalability-considerations)
32. [API Interaction Philosophy](#32-api-interaction-philosophy)
33. [Data Validation Strategy](#33-data-validation-strategy)
34. [Future Expansion Strategy](#34-future-expansion-strategy)
35. [AI-Ready Database Design](#35-ai-ready-database-design)
36. [Common Queries Overview](#36-common-queries-overview)
37. [Risks](#37-risks)
38. [Assumptions](#38-assumptions)
39. [Final Recommendations](#39-final-recommendations)

---

## 1. Database Philosophy

The database architecture for Nivaas is guided by a **Tenant-Enforced Relational Integrity and Offline Synchronization Philosophy**.

In Indian residential society management, data is deeply relational: a resident belongs to a specific house unit, which belongs to a wing, which belongs to a housing society. Concurrently, high-frequency operational traffic (visitor gate check-ins, maintenance bill approvals, and emergency alerts) requires extreme read/write throughput and resilience against low network connectivity at society gates.

### Core Philosophy Tenets:
- **Strict Tenant Boundary**: Every single tenant-scoped resource MUST explicitly carry a `society_id` attribute. Cross-tenant queries are disallowed at the ORM middleware and database policy layer.
- **Normalization with Pragmatic Denormalization**: Core transactional entities are kept normalized (3NF) to eliminate data anomalies. High-volume read targets (such as Gate Visitor Logs) selectively embed immutable snapshot data (e.g. resident flat number string at the exact time of entry) to eliminate costly multi-table joins during high-traffic gate lookup operations.
- **Immutability of Audit Trails**: Financial ledgers and gate visitor entries are insert-only audit trails. Modifications create new delta records rather than mutating historic state.

---

## 2. Database Goals

- **Tenancy Scale**: Support **50,000+ housing societies** on a single consolidated PostgreSQL database cluster without performance degradation or data leakage risks.
- **Volume Scale**: Efficiently handle **100+ Million Visitor Log records** per year with query response SLAs under 20ms for gate security lookups.
- **Offline Resilience**: Facilitate seamless delta synchronization between mobile SQLite stores (Drift) and central PostgreSQL without data corruption.
- **Operational Efficiency**: Maintain database CPU and IOPS utilization below 60% peak capacity under typical evening gate traffic spikes (6:00 PM – 9:00 PM IST).

---

## 3. Architectural Principles

1. **Explicit Foreign Key Enforcement**: Database-level foreign keys must strictly enforce referential integrity across all entities.
2. **Time-Ordered Primary Keys**: Primary keys use UUIDv7 to ensure random uniqueness across offline clients while maintaining index-friendly sequential insertion order in B-Tree indexes.
3. **UTC Uniformity**: All timestamps stored as `TIMESTAMPTZ` normalized to UTC at write time. Local time formatting is handled by mobile/client UI layers.
4. **Idempotent Sync Mutations**: Client synchronization payloads use client-generated UUIDv7 keys to guarantee idempotent server ingestion.

---

## 4. PostgreSQL Justification

PostgreSQL 16+ is chosen as the foundational database engine for Nivaas based on the following technical evaluations:

- **Row Level Security (RLS)**: Native database-level security policies that automatically restrict data visibility based on session context variables (`app.current_society_id`), preventing accidental multi-tenant data exposure even if ORM queries omit filters.
- **JSONB Capabilities**: Native JSONB support enables flexible storage for dynamic feature configurations, device metadata, and future AI enrichment without requiring schema alterations.
- **Partitioning Support**: Native range partitioning by `society_id` or `created_at` allows scaling historic tables (such as visitor logs) to hundreds of millions of rows while keeping active indexes compact in memory.
- **Transactional Integrity**: Full ACID compliance with robust concurrency controls (MVCC) critical for financial maintenance ledgers.

---

## 5. Multi-Tenant Strategy

Nivaas implements a **Shared Database, Discriminator Column (`society_id`) with Row Level Security (RLS)** model.

### Architecture Comparison & Selection Rationale:

1. **Database-per-Tenant**:
   - *Pros*: Complete database level separation.
   - *Cons*: Cost-prohibitive for thousands of small housing societies (10-50 flats); immense connection pooling overhead and complex schema migration management across 50,000 separate DB instances.
2. **Schema-per-Tenant**:
   - *Pros*: Logical schema separation within single database.
   - *Cons*: PostgreSQL catalog bloat when scaling past a few thousand schemas; slow DDL migration execution across thousands of schemas.
3. **Discriminator Column (`society_id`) [SELECTED]**:
   - *Pros*: Highly cost-effective; seamless cross-society analytics for super admins; single DDL schema migration path; optimal hardware resource utilization.
   - *Mitigation of Risk*: Enforced via automated PostgreSQL Row Level Security (RLS) policies and FastAPI session middleware.

---

## 6. Data Isolation Strategy

Data isolation is guaranteed through a **Dual-Layer Guard Pattern**:

```
[ HTTP Request Header: X-Society-ID ]
                │
                ▼
[ FastAPI Tenant Middleware ] ──> Validates User JWT contains matching society_id
                │
                ▼
[ DB Session Initialization ] ──> Executes: SET LOCAL app.current_society_id = 'society_uuid'
                │
                ▼
[ PostgreSQL RLS Policy ]    ──> Enforces: WHERE society_id = current_setting('app.current_society_id')
```

Even if a developer accidentally omits `.where(Model.society_id == tenant_id)` in application code, PostgreSQL RLS silently filters out records belonging to other societies at the database kernel level.

---

## 7. High Level Entity Overview

Below is the detailed specification of all core entities across the Nivaas domain:

### 7.1 Core Tenant & Structure Domain

#### Entity: `Society`
- **Purpose**: Represents an individual housing society / residential complex (Tenant).
- **Responsibility**: Root organization container holding society configuration, address, code, and global settings.
- **Relationships**: Parent to Wings, Houses, Users, Maintenance Bills, Notices.
- **Ownership**: System Super Admin / Onboarding System.
- **Lifecycle**: Created during society onboarding; updated by RWA Admin; archived via soft flag.
- **Expected Size**: 50,000 records globally.
- **Examples**: `"Green Meadows Heights RWA"`, `"Shree Ganesh Cooperative Housing Society"`.

#### Entity: `Wing`
- **Purpose**: Represents a physical block or tower within a society.
- **Responsibility**: Hierarchical group for houses (e.g. Block A, Tower 2).
- **Relationships**: Child of Society; Parent to Floors and Houses.
- **Ownership**: Society Admin.
- **Lifecycle**: Configured during initial society setup.
- **Expected Size**: 200,000 records globally (~4 wings per society).
- **Examples**: `"Block A"`, `"Tower 1"`, `"East Wing"`.

#### Entity: `Floor`
- **Purpose**: Logical floor level within a wing.
- **Responsibility**: Grouping houses by floor number to assist guard navigation.
- **Relationships**: Child of Wing; Parent to Houses.
- **Ownership**: Society Admin.
- **Lifecycle**: Configured during setup.
- **Expected Size**: 1,000,000 records globally (~5 floors per wing).
- **Examples**: `"1st Floor"`, `"Ground Floor"`.

#### Entity: `House`
- **Purpose**: An individual residential flat, apartment unit, or villa.
- **Responsibility**: Represents a physical dwelling unit to which visitors are sent and maintenance bills are issued.
- **Relationships**: Child of Wing/Floor; Parent to Resident Mappings, Vehicles, Bills, Complaints, Visitor Logs.
- **Ownership**: Society Admin / Resident.
- **Lifecycle**: Permanent physical entity.
- **Expected Size**: 2,500,000 records globally (~50 flats per society).
- **Examples**: `"Flat 402"`, `"Villa 12"`.

#### Entity: `HouseType`
- **Purpose**: Defines flat configuration categories (e.g. 2BHK, 3BHK, Penthouse).
- **Responsibility**: Used for area-based maintenance billing calculations.
- **Relationships**: Referenced by House.
- **Ownership**: Society Admin.
- **Lifecycle**: Configured during setup.
- **Expected Size**: 250,000 records globally.
- **Examples**: `"3BHK - 1450 sqft"`, `"2BHK Standard"`.

---

### 7.2 User & Identity Domain

#### Entity: `User`
- **Purpose**: Global user account identity.
- **Responsibility**: Authentication holder (phone, password hash, global profile info).
- **Relationships**: Linked to Resident/Owner/Watchman/Admin profiles across societies.
- **Ownership**: Individual User.
- **Lifecycle**: Created via OTP sign-up.
- **Expected Size**: 5,000,000 records globally.
- **Examples**: `"Rajesh Kumar (+91 9876543210)"`.

#### Entity: `Resident`
- **Purpose**: Specific mapping of a User to a House within a Society context.
- **Responsibility**: Holds tenancy role details (`OWNER` vs `TENANT`), occupancy status, move-in/out dates.
- **Relationships**: Maps User to House within a Society.
- **Ownership**: Society Admin / User.
- **Lifecycle**: Created when resident joins society; marked inactive on move-out.
- **Expected Size**: 6,000,000 records.

#### Entity: `Owner`
- **Purpose**: Legal property ownership record for a House.
- **Responsibility**: Holds owner contact and title details (used when flat is rented to a tenant).
- **Relationships**: Linked to House.
- **Ownership**: Society Admin.
- **Lifecycle**: Updated upon property sale/transfer.
- **Expected Size**: 2,500,000 records.

#### Entity: `Tenant`
- **Purpose**: Rental occupant details and agreement validity dates.
- **Responsibility**: Stores tenancy agreement start/end dates, police verification status.
- **Relationships**: Linked to Resident mapping.
- **Ownership**: House Owner / Society Admin.
- **Lifecycle**: Created upon lease agreement; expires on lease end.
- **Expected Size**: 2,000,000 records.

#### Entity: `FamilyMember`
- **Purpose**: Non-primary flat occupants (children, elderly parents).
- **Responsibility**: Allows secondary members access to visitor notifications without administrative privileges.
- **Relationships**: Linked to Resident mapping.
- **Ownership**: Primary Resident.
- **Lifecycle**: Managed by Primary Resident.
- **Expected Size**: 10,000,000 records.

#### Entity: `Watchman`
- **Purpose**: Security guard profile assigned to a society gate.
- **Responsibility**: Holds gate assignment, shift details, guard ID badge numbers.
- **Relationships**: Child of Society; linked to User.
- **Ownership**: Society Admin / Security Agency.
- **Lifecycle**: Created upon employment; deactivated upon departure.
- **Expected Size**: 200,000 records.

#### Entity: `Admin`
- **Purpose**: RWA Committee administrator privileges mapping.
- **Responsibility**: Holds committee designation (`PRESIDENT`, `TREASURER`, `SECRETARY`).
- **Relationships**: Linked to User & Society.
- **Ownership**: Society Admin / RWA Committee.
- **Lifecycle**: Assigned during annual RWA elections.
- **Expected Size**: 150,000 records.

---

### 7.3 Gate & Visitor Management Domain

#### Entity: `Visitor`
- **Purpose**: Global record of an external person entering housing societies.
- **Responsibility**: Stores visitor phone, name, photo URL, frequent delivery vendor affiliation (e.g. Amazon, Swiggy, Zomato).
- **Relationships**: Referenced by VisitorLog.
- **Ownership**: Gate System.
- **Lifecycle**: Created on first-time entry; updated over time.
- **Expected Size**: 15,000,000 records globally.

#### Entity: `VisitorLog`
- **Purpose**: Transactional record of a specific entry/exit event at a gate.
- **Responsibility**: Stores entry timestamp, exit timestamp, status (`PENDING`, `APPROVED`, `DENIED`, `INSIDE`, `EXITED`), pass code, entry type (`GUEST`, `CAB`, `DELIVERY`, `SERVICE`), snapshot of flat unit string.
- **Relationships**: Child of Society, House, Visitor; linked to approving Resident & Watchman.
- **Ownership**: Security System.
- **Lifecycle**: High volume immutable log; archived after 90 days.
- **Expected Size**: 150,000,000 records per year.

---

### 7.4 Parking & Vehicle Domain

#### Entity: `Vehicle`
- **Purpose**: Vehicle registry belonging to residents.
- **Responsibility**: Number plate search, vehicle type (2W/4W), make/model/color, RFID tag ID.
- **Relationships**: Linked to House and Resident.
- **Ownership**: Resident.
- **Lifecycle**: Registered by resident; updated on vehicle change.
- **Expected Size**: 4,000,000 records.

#### Entity: `Parking`
- **Purpose**: Designated parking slot within a society.
- **Responsibility**: Slot identifier (e.g. `P1-B2-104`), slot type (Covered/Open), allocation status.
- **Relationships**: Linked to Society and assigned House.
- **Ownership**: Society Admin.
- **Lifecycle**: Configured during setup; assigned to houses.
- **Expected Size**: 2,500,000 records.

---

### 7.5 Maintenance & Billing Domain

#### Entity: `MaintenanceBill`
- **Purpose**: Monthly/quarterly maintenance invoice issued to a House.
- **Responsibility**: Stores bill period, base charge, utility add-ons, late fees, penalty calculation, due date, status (`UNPAID`, `PARTIAL`, `PAID`, `OVERDUE`).
- **Relationships**: Child of Society & House; Parent to Payments.
- **Ownership**: Society Accountant / Admin.
- **Lifecycle**: Created periodically; updated upon payment receipt.
- **Expected Size**: 30,000,000 records per year.

#### Entity: `Payment`
- **Purpose**: Financial receipt transaction record.
- **Responsibility**: Payment gateway transaction ID, payment mode (UPI, NEFT, Cash), paid amount, payment timestamp, Gateway response payload snapshot.
- **Relationships**: Child of MaintenanceBill; linked to User.
- **Ownership**: Billing System / Resident.
- **Lifecycle**: Immutable transaction record.
- **Expected Size**: 30,000,000 records per year.

---

### 7.6 Helpdesk & Communication Domain

#### Entity: `Complaint`
- **Purpose**: Maintenance issue ticket raised by a resident.
- **Responsibility**: Ticket number, title, category (`PLUMBING`, `ELECTRICAL`, `ELEVATOR`, `SECURITY`), priority, status (`OPEN`, `IN_PROGRESS`, `RESOLVED`, `CLOSED`), resolution notes.
- **Relationships**: Child of Society, House, User; Parent to Attachments.
- **Ownership**: Resident / Helpdesk Admin.
- **Lifecycle**: Open -> In Progress -> Resolved -> Closed.
- **Expected Size**: 10,000,000 records per year.

#### Entity: `ComplaintAttachment`
- **Purpose**: Photo/video proof attached to a complaint ticket.
- **Responsibility**: Storage file key, mime type, upload timestamp.
- **Relationships**: Child of Complaint.
- **Ownership**: Resident / Maintenance Staff.
- **Expected Size**: 25,000,000 records.

#### Entity: `Notice`
- **Purpose**: Society broadcast announcement or official RWA memo.
- **Responsibility**: Title, content body, priority (`NORMAL`, `HIGH`, `EMERGENCY`), attachment URLs, target wings (all vs specific wing), published timestamp.
- **Relationships**: Child of Society; created by Admin.
- **Ownership**: Society Admin.
- **Expected Size**: 1,000,000 records per year.

#### Entity: `Notification`
- **Purpose**: Targeted user push/in-app message record.
- **Responsibility**: Message title, payload JSON, read status timestamp, FCM message ID.
- **Relationships**: Child of User & Society.
- **Ownership**: System Notification Engine.
- **Expected Size**: 100,000,000 records per year (Archived aggressively).

#### Entity: `EmergencyContact`
- **Purpose**: Quick dial directory for society SOS button.
- **Responsibility**: Designation (`LOCAL_POLICE`, `FIRE_STATION`, `AMBULANCE`, `SOCIETY_OFFICE`), contact person name, phone numbers.
- **Relationships**: Child of Society.
- **Ownership**: Society Admin.
- **Expected Size**: 500,000 records.

---

### 7.7 Staff & Vendor Domain

#### Entity: `Staff`
- **Purpose**: Daily domestic help (Maids, Drivers, Cooks, Cleaners).
- **Responsibility**: Name, phone, photo, service type, entry pass code, police verification status.
- **Relationships**: Child of Society; linked to multiple Houses worked in.
- **Ownership**: Resident / Gate Admin.
- **Expected Size**: 5,000,000 records.

#### Entity: `Vendor`
- **Purpose**: Approved external service contractors (Pest control, Elevator AMC, Electricians).
- **Responsibility**: Company name, contact person, contract validity dates, AMC details.
- **Relationships**: Child of Society.
- **Ownership**: Society Admin.
- **Expected Size**: 200,000 records.

#### Entity: `Document`
- **Purpose**: Official society repository documents (Bye-laws, AGM minutes, Occupancy Certificates).
- **Responsibility**: Document title, category, storage file URL, access scope (`ADMIN_ONLY` vs `ALL_RESIDENTS`).
- **Relationships**: Child of Society.
- **Ownership**: Society Admin.
- **Expected Size**: 1,000,000 records.

---

### 7.8 System, Audit & Sync Domain

#### Entity: `ActivityLog`
- **Purpose**: Non-critical operational user action log.
- **Responsibility**: Action name, module, timestamp, IP address, user agent.
- **Relationships**: Linked to User & Society.
- **Ownership**: System Logger.
- **Expected Size**: 500,000,000 records (Partitioned & rotated).

#### Entity: `AuditLog`
- **Purpose**: Immutable security & financial compliance audit trail.
- **Responsibility**: Pre-change JSON snapshot, Post-change JSON snapshot, Actor User ID, Target Entity Name, Operation (`INSERT`, `UPDATE`, `DELETE`).
- **Relationships**: Linked to Society & User.
- **Ownership**: Compliance Engine.
- **Expected Size**: 100,000,000 records.

#### Entity: `Device`
- **Purpose**: Registered mobile client device for FCM push notifications and hardware trust.
- **Responsibility**: FCM registration token, device model, OS version, app version, last active timestamp.
- **Relationships**: Child of User.
- **Ownership**: Auth System.
- **Expected Size**: 8,000,000 records.

#### Entity: `Session`
- **Purpose**: Active authentication token metadata and refresh token tracking.
- **Responsibility**: Refresh token hash, issued timestamp, expiration timestamp, revoked flag.
- **Relationships**: Child of User.
- **Ownership**: Security Auth Engine.
- **Expected Size**: 15,000,000 records.

#### Entity: `OfflineSyncQueue`
- **Purpose**: Server-side sync checkpoint tracking for client offline synchronization engines.
- **Responsibility**: Device ID, client last sync timestamp, pending sequence number, sync status.
- **Relationships**: Linked to Device & Society.
- **Ownership**: Synchronization Engine.
- **Expected Size**: 10,000,000 records.

#### Entity: `FutureAiInsights`
- **Purpose**: Staging area for offline ML worker outputs (e.g. Visitor pattern anomalies, maintenance expense forecasting).
- **Responsibility**: Target entity type, insight category, confidence score, recommendation payload JSONB, generation timestamp.
- **Relationships**: Child of Society.
- **Ownership**: AI Background Pipeline.
- **Expected Size**: 5,000,000 records.

#### Entity: `FutureAnalytics`
- **Purpose**: Pre-aggregated daily society metrics.
- **Responsibility**: Aggregate date, total visitor count, average gate check-in duration, collection percentage, open ticket count.
- **Relationships**: Child of Society.
- **Ownership**: Analytics ETL Worker.
- **Expected Size**: 20,000,000 records.

#### Entity: `FutureReports`
- **Purpose**: Generated PDF/Excel summary report metadata.
- **Responsibility**: Report name, filter params JSON, generated file URL, expiry timestamp.
- **Relationships**: Child of Society & User.
- **Ownership**: Reporting Engine.
- **Expected Size**: 2,000,000 records.

---

## 8. Relationship Strategy

- **Parent-Child Cascade Rules**:
  - `Society` deletion: Soft delete cascade flag; hardware hard deletes are prohibited in production.
  - `House` deletion: Reassigned or soft deleted; existing financial `MaintenanceBill` records MUST retain immutable historical FK reference.
- **Many-to-Many Mappings**: Expressed through explicit junction entities carrying auditing metadata (e.g. `ResidentHouse` mapping entity stores `is_primary`, `move_in_date`, and `approved_by_user_id` rather than raw DB arrays).

---

## 9. Naming Convention

A strict naming standard is enforced across the entire backend schema:

- **Tables**: `snake_case`, pluralized (e.g. `societies`, `visitor_logs`, `maintenance_bills`).
- **Columns**: `snake_case`, singular (e.g. `first_name`, `entry_timestamp`, `society_id`).
- **Foreign Keys**: `<singular_referenced_entity>_id` (e.g. `society_id`, `house_id`, `visitor_id`).
- **Boolean Columns**: Prefix with `is_` or `has_` (e.g. `is_active`, `is_approved`, `has_parking`).
- **Timestamp Columns**: Suffix with `_at` (e.g. `created_at`, `updated_at`, `deleted_at`, `entry_at`).
- **Date Columns**: Suffix with `_date` (e.g. `due_date`, `move_in_date`).

---

## 10. Primary Key Strategy

### Analysis: Integer Auto-Increment vs. UUIDv4 vs. UUIDv7

| Criteria | Integer Auto-Increment | Standard UUIDv4 | UUIDv7 [SELECTED] |
| :--- | :--- | :--- | :--- |
| **Global Uniqueness** | ❌ No (Collides across databases) | ✅ Yes | ✅ Yes |
| **Offline Generation** | ❌ No (Requires central DB server) | ✅ Yes | ✅ Yes |
| **B-Tree Index Locality** | ✅ High (Sequential fill) | ❌ Poor (Random index page splits) | ✅ High (Time-ordered 48-bit timestamp prefix) |
| **Enumeration Attack Risk**| ❌ High (Predictable `/users/102`) | ✅ Immune | ✅ Immune |

### Decision:
All primary keys MUST use **UUIDv7**.
UUIDv7 provides time-ordered 128-bit identifiers, enabling offline client generation while completely eliminating PostgreSQL B-Tree index fragmentation.

---

## 11. Foreign Key Strategy

- All foreign key relationships MUST explicitly specify ON DELETE actions:
  - `ON DELETE RESTRICT`: For financial and transactional references (`MaintenanceBill` -> `House`, `Payment` -> `MaintenanceBill`).
  - `ON DELETE CASCADE`: Strictly reserved for dependent child sub-resources (`ComplaintAttachment` -> `Complaint`).
- Foreign key constraints must be indexed to prevent full table scans during parent updates.

---

## 12. Soft Delete Strategy

- Core domain entities MUST NOT be physically deleted (`DELETE FROM table`).
- Entities implement a **Soft Delete Filter**:
  - Column: `deleted_at TIMESTAMPTZ NULL DEFAULT NULL`.
  - An entity is active when `deleted_at IS NULL`.
  - Application queries automatically append `WHERE deleted_at IS NULL` via ORM base models.
  - Partial Indexing: `CREATE INDEX idx_... ON table (society_id) WHERE deleted_at IS NULL;` keeps active indexes compact.

---

## 13. Timestamp Strategy

- Every table MUST include:
  - `created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP`
  - `updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP`
- Time zone handling: Stored strictly as **UTC**. Client applications convert UTC timestamps to Indian Standard Time (`IST - UTC+5:30`) for presentation.
- Automated `updated_at` mutation managed via database triggers or ORM session hooks.

---

## 14. Status Fields Strategy

- Status fields MUST be stored as string representations (or explicit PostgreSQL ENUM types where values are immutable).
- **Standardized State Machine Enums**:
  - `VisitorStatus`: `PENDING`, `APPROVED`, `DENIED`, `INSIDE`, `EXITED`, `EXPIRED`.
  - `BillStatus`: `UNPAID`, `PARTIALLY_PAID`, `PAID`, `OVERDUE`, `CANCELLED`.
  - `TicketStatus`: `OPEN`, `IN_PROGRESS`, `RESOLVED`, `CLOSED`.

---

## 15. File Storage Strategy

- Binary media files (PDF receipts, society notices, complaint attachments) MUST NEVER be stored as BLOBs inside PostgreSQL.
- Files are stored in **S3-compatible Object Storage** (Supabase Storage / AWS S3).
- PostgreSQL stores only the immutable file metadata:
  - `file_key`: Relative S3 path (`societies/<uuid>/documents/notice_102.pdf`).
  - `mime_type`: `application/pdf`.
  - `file_size_bytes`: `1048576`.
- Access is provided via short-lived (15-minute) S3 Signed URLs generated on-the-fly by FastAPI.

---

## 16. Image Storage Strategy

- Gate visitor photos and profile images undergo client-side compression to maximum `1024x1024` resolution JPEG before upload.
- Object storage path hierarchy: `societies/{society_id}/visitors/{year}/{month}/{visitor_log_id}.jpg`.
- Database stores relative storage path and image thumbnail hash for fast low-bandwidth rendering.

---

## 17. Offline-First Data Model

On the mobile client, **Drift (SQLite)** mirrors a targeted subset of the PostgreSQL schema.

### Data Mapping Strategy:
- Server UUIDv7 primary keys are preserved identically across SQLite and PostgreSQL.
- Mobile client contains an `outbox_mutations` SQLite table holding offline transactions:
  - `mutation_id` (UUIDv7)
  - `entity_type` (`VISITOR_LOG`, `COMPLAINT`)
  - `payload_json` (Serialized state)
  - `sync_status` (`PENDING`, `SYNCING`, `FAILED`, `ACKNOWLEDGED`)
  - `created_at` (Timestamp)

---

## 18. Synchronization Strategy

Nivaas uses a **Delta Sync Engine with Outbox Queueing**.

```
[ Mobile App ] ──> Local Write (Drift DB) ──> Enqueue Outbox Record
                                                        │
                                                        ▼
                                         [ Background Sync Worker ]
                                                        │
                                          POST /api/v1/sync/push
                                                        │
                                                        ▼
                                         [ FastAPI Sync Processor ]
                                                        │
                                          Process Ingestion Transaction
                                                        │
                                                        ▼
                                         Return Server Ack + Delta Pull
```

1. **Push Sync**: Client pushes pending outbox records to `/api/v1/sync/push`.
2. **Pull Sync**: Client sends its `last_synced_at` timestamp to `/api/v1/sync/pull`. Server returns all records modified (`updated_at > last_synced_at`) within the user's `society_id` scope.

---

## 19. Conflict Resolution

### Policy: Server-Wins with Client Draft Preservation

1. **Append-Only Visitor Logs**: Visitor entries are immutable timestamped log events; conflicts cannot overwrite historic entry records.
2. **User Profile Updates**: Timestamp check. If `server.updated_at > client.mutation_timestamp`, server state prevails.
3. **Unsynced Draft Complaints**: Client local edits flagged as drafts are preserved locally in SQLite under a new local draft ID if server rejects sync payload.

---

## 20. Versioning Strategy

- Critical mutable entities (`House`, `Resident`, `MaintenanceBill`) include an integer `version` field for **Optimistic Concurrency Control (OCC)**.
- Updates must match the version:
  `UPDATE maintenance_bills SET status = 'PAID', version = version + 1 WHERE id = :id AND version = :expected_version;`
- If row count updated equals zero, an `OptimisticLockException` is raised, prompting client state refresh.

---

## 21. Caching Strategy

Using **Redis 7+** as a high-performance key-value cache layer in front of PostgreSQL.

- **Cache Targets**:
  - Society Profile & Feature Flags: TTL 24 Hours (`cache:society:{society_id}:config`).
  - Active Gate Watchman Session Context: TTL 8 Hours.
  - Active Flat Directory Lookup: TTL 1 Hour (Invalidated on resident update).
- **Cache Invalidation Policy**: Explicit event-driven cache invalidation on mutation via background signals.

---

## 22. Indexing Strategy

To guarantee sub-20ms query execution across 100M+ rows:

1. **Composite Tenant Indexes**:
   - Every multi-tenant query filter uses composite indexes beginning with `society_id`:
     - `CREATE INDEX idx_visitor_logs_society_created ON visitor_logs (society_id, created_at DESC);`
     - `CREATE INDEX idx_maintenance_bills_society_house ON maintenance_bills (society_id, house_id, status);`
2. **Partial Indexes**:
   - Filter active un-deleted records:
     - `CREATE INDEX idx_active_residents ON residents (society_id, user_id) WHERE deleted_at IS NULL;`
3. **Covering Indexes**:
   - Include frequently requested lookup fields in the index payload (`INCLUDE`) to allow Index-Only Scans.

---

## 24. Pagination Strategy

- **OFFSET / LIMIT is Banned** for large transactional tables (`visitor_logs`, `notifications`) due to $O(N)$ performance degradation.
- **Keyset / Cursor-Based Pagination [MANDATORY]**:
  - Pagination cursor is encoded as a base64 string containing `(created_at, id)`.
  - Query execution uses index seeking:
    `WHERE society_id = :society_id AND (created_at, id) < (:cursor_created_at, :cursor_id) ORDER BY created_at DESC, id DESC LIMIT 20;`

---

## 25. Archival Strategy

- `visitor_logs` and `activity_logs` older than **90 days** are automatically migrated from primary hot storage to **Cold Storage Partition Archives**.
- PostgreSQL Table Partitioning by Month (`visitor_logs_2026_01`, `visitor_logs_2026_02`).
- Detached monthly partition tables are dumped to compressed Parquet format and loaded into AWS S3 Glacier / Cloud Cold Storage for historical auditing.

---

## 26. Backup Strategy

- **Continuous WAL Archiving**: Point-In-Time Recovery (PITR) enabled via Write-Ahead Logging (WAL-G / AWS RDS automated WAL stream).
- **Daily Full Snapshot**: Automated daily database snapshot at 3:00 AM IST retained for 30 days.
- **Weekly Offsite Backup**: Encrypted backup copy transferred to secondary geographically isolated cloud region.

---

## 27. Disaster Recovery Considerations

- **Recovery Point Objective (RPO)**: < 5 minutes (WAL log replication lag).
- **Recovery Time Objective (RTO)**: < 15 minutes (Automated failover to Hot Standby PostgreSQL Read Replica).
- **Multi-AZ Deployment**: Primary database deployed across Availability Zone A with synchronous standby replication to Availability Zone B.

---

## 28. Security Considerations

- **Encryption at Rest**: PostgreSQL storage volumes encrypted using AES-256 (KMS Managed Keys).
- **Encryption in Transit**: TLS 1.3 mandatory for all database connection pools.
- **Connection Privilege Isolation**: Application runtime connects via unprivileged DB user (`nivaas_app`). Schema migrations run via separate CI/CD migration runner (`nivaas_migrator`).

---

## 29. Audit Logging

- Critical administrative, financial, and security actions write to an immutable `audit_logs` table.
- **Tracked Operations**:
  - Approving new resident registrations.
  - Modifying maintenance bill amounts or issuing manual waivers.
  - Overriding gate entry security blocks.
- Audit records store immutable pre-change and post-change JSONB state snapshots.

---

## 30. Performance Considerations

- **Connection Pooling**: Managed via **PgBouncer** in Transaction Pooling mode (Max 10,000 incoming client connections mapped to 50 active PostgreSQL server connections).
- **Query Timeout Limits**: Strict statement timeout of `5000ms` enforced globally to prevent rogue un-indexed queries from consuming database worker threads.

---

## 31. Scalability Considerations

- **Read-Write Splitting**:
  - Writes & Critical Financial Reads -> Primary Database Writer Node.
  - Analytical Dashboards, Notice Searches, Historical Logs -> PostgreSQL Read Replicas.

---

## 32. API Interaction Philosophy

- Database entities are NEVER exposed directly over REST APIs.
- Mandatory separation between ORM Database Models and external API Contracts via **Pydantic v2 Schemas** (DTOs).

---

## 33. Data Validation Strategy

- **Multi-Tier Validation**:
  1. Client-side validation (Flutter Form validators).
  2. API boundary validation (Pydantic v2 strict type checks).
  3. Database-level constraints (`CHECK` constraints for numeric amounts > 0, valid phone number format patterns, non-null FK references).

---

## 34. Future Expansion Strategy

- Dynamic society custom fields handled via dedicated `settings JSONB` column on `societies` table rather than dynamic schema DDL modifications.
- Module activation flags (`has_amenity_booking`, `has_maid_attendance`) configured via feature flag JSON payload.

---

## 35. AI-Ready Database Design

- **pgvector Extension Preparedness**: Database schema ready to enable `pgvector` for embedding storage.
- **Vector Search Target**: Converting complaint ticket descriptions into vector embeddings to automatically detect duplicate complaints within a housing society.

---

## 36. Common Queries Overview

Logical access patterns optimized by database design:

1. **Gate Watchman Flat Lookup**: Instant indexed retrieval of house unit and active resident list by Flat Number string (`WHERE society_id = :id AND flat_number = :flat`).
2. **Resident Visitor History**: Cursor-paginated query of visitor logs for a specific house (`WHERE society_id = :id AND house_id = :house_id ORDER BY created_at DESC`).
3. **Monthly Maintenance Summary**: Aggregated dues summary by society (`WHERE society_id = :id AND status = 'UNPAID'`).

---

## 37. Risks

| Identified Risk | Impact | Mitigation Strategy |
| :--- | :--- | :--- |
| High-volume visitor log table growth degrading DB performance | High | PostgreSQL range partitioning by month +Keystep cursor pagination + 90-day cold archiving. |
| Accidental cross-tenant data leak due to missing code filter | Critical | Enforce PostgreSQL Row Level Security (RLS) policies + FastAPI session tenant middleware assertions. |
| Offline client clock skew causing outbox sync timestamp errors | Moderate | Rely on server-assigned ingestion timestamps + time-ordered UUIDv7 sequence generation. |

---

## 38. Assumptions

1. Primary transactional workload is read-heavy (80% Reads, 20% Writes).
2. Individual housing societies range from 10 units to 5,000 units.
3. PostgreSQL server nodes have minimum 16GB RAM and dedicated NVMe SSD storage.

---

## 39. Final Recommendations

1. **Enforce UUIDv7 System-Wide**: Use UUIDv7 as the universal primary key type for all entities across mobile and backend.
2. **Mandate PostgreSQL RLS**: Enable Row Level Security on every tenant-scoped table during initial migration setup.
3. **Strict Cursor Pagination**: Prohibit `OFFSET` in all API contracts; enforce Keyset pagination primitives across all list endpoints.
