from datetime import datetime, timezone
from typing import Optional
from uuid import UUID, uuid4
from sqlalchemy import String, Integer, DateTime, ForeignKey, Enum as SQLEnum, Text, Boolean
from sqlalchemy.orm import Mapped, mapped_column
import enum

class VisitorStatusEnum(str, enum.Enum):
    WAITING_APPROVAL = "WAITING_APPROVAL"
    APPROVED = "APPROVED"
    REJECTED = "REJECTED"
    CHECKED_IN = "CHECKED_IN"
    CHECKED_OUT = "CHECKED_OUT"
    CANCELLED = "CANCELLED"
    EXPIRED = "EXPIRED"

class EntryTypeEnum(str, enum.Enum):
    GUEST = "GUEST"
    CAB = "CAB"
    DELIVERY = "DELIVERY"
    SERVICE = "SERVICE"
    FREQUENT = "FREQUENT"
    EMERGENCY = "EMERGENCY"

class DeliveryVendorEnum(str, enum.Enum):
    AMAZON = "AMAZON"
    FLIPKART = "FLIPKART"
    SWIGGY = "SWIGGY"
    ZOMATO = "ZOMATO"
    BLINKIT = "BLINKIT"
    BIGBASKET = "BIGBASKET"
    COURIER = "COURIER"
    MILK = "MILK"
    GAS_CYLINDER = "GAS_CYLINDER"
    OTHER = "OTHER"

class VisitorModel:
    """
    SQLAlchemy 2.0 Model representing a Visitor identity.
    Conforms strictly to DATABASE_ARCHITECTURE.md (section 7.3).
    """
    __tablename__ = "visitors"

    id: Mapped[UUID] = mapped_column(primary_key=True, default=uuid4)
    full_name: Mapped[str] = mapped_column(String(100), nullable=False)
    phone: Mapped[str] = mapped_column(String(20), nullable=False, index=True)
    photo_url: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)
    id_proof_url: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)
    vendor_name: Mapped[Optional[str]] = mapped_column(String(50), nullable=True)

    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))

class VisitorLogModel:
    """
    SQLAlchemy 2.0 Model representing transactional Visitor Entry Log.
    Conforms strictly to DATABASE_ARCHITECTURE.md (section 7.3).
    """
    __tablename__ = "visitor_logs"

    id: Mapped[UUID] = mapped_column(primary_key=True, default=uuid4)
    society_id: Mapped[UUID] = mapped_column(ForeignKey("societies.id", ondelete="CASCADE"), nullable=False, index=True)
    house_id: Mapped[Optional[UUID]] = mapped_column(ForeignKey("houses.id", ondelete="SET NULL"), nullable=True, index=True)
    visitor_id: Mapped[Optional[UUID]] = mapped_column(ForeignKey("visitors.id", ondelete="SET NULL"), nullable=True, index=True)

    visitor_name: Mapped[str] = mapped_column(String(100), nullable=False)
    visitor_phone: Mapped[str] = mapped_column(String(20), nullable=False, index=True)
    flat_number: Mapped[str] = mapped_column(String(50), nullable=False)
    wing_name: Mapped[str] = mapped_column(String(50), nullable=False)
    purpose: Mapped[str] = mapped_column(String(100), nullable=False)
    entry_type: Mapped[EntryTypeEnum] = mapped_column(SQLEnum(EntryTypeEnum), nullable=False, default=EntryTypeEnum.GUEST)
    status: Mapped[VisitorStatusEnum] = mapped_column(SQLEnum(VisitorStatusEnum), nullable=False, default=VisitorStatusEnum.WAITING_APPROVAL)
    
    pass_code: Mapped[Optional[str]] = mapped_column(String(20), nullable=True)
    vehicle_number: Mapped[Optional[str]] = mapped_column(String(50), nullable=True)
    visitor_count: Mapped[int] = mapped_column(Integer, nullable=False, default=1)
    expected_duration: Mapped[Optional[str]] = mapped_column(String(50), nullable=True)
    notes: Mapped[Optional[str]] = mapped_column(Text, nullable=True)

    check_in_time: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    check_out_time: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), nullable=True)
    duration_minutes: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    gate_name: Mapped[str] = mapped_column(String(50), nullable=False, default="Main Gate")
    guard_name: Mapped[str] = mapped_column(String(100), nullable=False, default="Security Officer")

    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))

class DeliveryLogModel:
    """
    SQLAlchemy 2.0 Model representing Delivery Entry Log.
    """
    __tablename__ = "delivery_logs"

    id: Mapped[UUID] = mapped_column(primary_key=True, default=uuid4)
    society_id: Mapped[UUID] = mapped_column(ForeignKey("societies.id", ondelete="CASCADE"), nullable=False, index=True)
    
    vendor: Mapped[DeliveryVendorEnum] = mapped_column(SQLEnum(DeliveryVendorEnum), nullable=False)
    flat_number: Mapped[str] = mapped_column(String(50), nullable=False)
    delivery_person_name: Mapped[str] = mapped_column(String(100), nullable=False)
    phone: Mapped[Optional[str]] = mapped_column(String(20), nullable=True)
    pass_code: Mapped[str] = mapped_column(String(20), nullable=False)
    status: Mapped[VisitorStatusEnum] = mapped_column(SQLEnum(VisitorStatusEnum), nullable=False, default=VisitorStatusEnum.CHECKED_IN)

    entry_time: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))

class FrequentVisitorModel:
    """
    SQLAlchemy 2.0 Model representing Daily Staff & Frequent Visitors.
    """
    __tablename__ = "frequent_visitors"

    id: Mapped[UUID] = mapped_column(primary_key=True, default=uuid4)
    society_id: Mapped[UUID] = mapped_column(ForeignKey("societies.id", ondelete="CASCADE"), nullable=False, index=True)
    
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    phone: Mapped[str] = mapped_column(String(20), nullable=False, index=True)
    service_type: Mapped[str] = mapped_column(String(50), nullable=False) # Maid, Driver, Electrician, Plumber, Tutor
    flats_assigned: Mapped[str] = mapped_column(String(255), nullable=False) # e.g. "A-402, B-101"
    pass_code: Mapped[str] = mapped_column(String(20), nullable=False)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)

    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
