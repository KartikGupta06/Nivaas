from datetime import datetime, timezone
from typing import Optional
from uuid import UUID, uuid4
from sqlalchemy import String, Integer, Boolean, DateTime, ForeignKey, Enum as SQLEnum
from sqlalchemy.orm import Mapped, mapped_column
import enum

class TenancyRoleEnum(str, enum.Enum):
    OWNER = "OWNER"
    FAMILY_MEMBER = "FAMILY_MEMBER"
    TENANT = "TENANT"

class VehicleTypeEnum(str, enum.Enum):
    TWO_WHEELER = "TWO_WHEELER"
    FOUR_WHEELER = "FOUR_WHEELER"
    ELECTRIC = "ELECTRIC"

class Resident:
    """
    SQLAlchemy 2.0 Model representing Resident Mapping.
    Conforms strictly to DATABASE_ARCHITECTURE.md (section 7.2).
    """
    __tablename__ = "residents"

    id: Mapped[UUID] = mapped_column(primary_key=True, default=uuid4)
    society_id: Mapped[UUID] = mapped_column(ForeignKey("societies.id", ondelete="CASCADE"), nullable=False, index=True)
    house_id: Mapped[UUID] = mapped_column(ForeignKey("houses.id", ondelete="CASCADE"), nullable=False, index=True)
    user_id: Mapped[UUID] = mapped_column(String(50), nullable=False, index=True)

    full_name: Mapped[str] = mapped_column(String(100), nullable=False)
    phone: Mapped[str] = mapped_column(String(20), nullable=False)
    email: Mapped[Optional[str]] = mapped_column(String(100), nullable=True)
    role: Mapped[TenancyRoleEnum] = mapped_column(SQLEnum(TenancyRoleEnum), nullable=False, default=TenancyRoleEnum.OWNER)
    emergency_contact: Mapped[Optional[str]] = mapped_column(String(20), nullable=True)
    avatar_url: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)

    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))

class FamilyMemberModel:
    """
    SQLAlchemy 2.0 Model representing Family Member.
    Conforms strictly to DATABASE_ARCHITECTURE.md (section 7.2).
    """
    __tablename__ = "family_members"

    id: Mapped[UUID] = mapped_column(primary_key=True, default=uuid4)
    resident_id: Mapped[UUID] = mapped_column(ForeignKey("residents.id", ondelete="CASCADE"), nullable=False, index=True)
    house_id: Mapped[UUID] = mapped_column(ForeignKey("houses.id", ondelete="CASCADE"), nullable=False, index=True)

    name: Mapped[str] = mapped_column(String(100), nullable=False)
    relationship: Mapped[str] = mapped_column(String(50), nullable=False)
    contact_number: Mapped[Optional[str]] = mapped_column(String(20), nullable=True)
    is_child: Mapped[bool] = mapped_column(Boolean, default=False)
    is_senior_citizen: Mapped[bool] = mapped_column(Boolean, default=False)

    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))

class VehicleModel:
    """
    SQLAlchemy 2.0 Model representing Resident Vehicle.
    Conforms strictly to DATABASE_ARCHITECTURE.md (section 7.4).
    """
    __tablename__ = "vehicles"

    id: Mapped[UUID] = mapped_column(primary_key=True, default=uuid4)
    society_id: Mapped[UUID] = mapped_column(ForeignKey("societies.id", ondelete="CASCADE"), nullable=False, index=True)
    house_id: Mapped[UUID] = mapped_column(ForeignKey("houses.id", ondelete="CASCADE"), nullable=False, index=True)
    resident_id: Mapped[UUID] = mapped_column(ForeignKey("residents.id", ondelete="CASCADE"), nullable=False, index=True)

    vehicle_number: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    vehicle_type: Mapped[VehicleTypeEnum] = mapped_column(SQLEnum(VehicleTypeEnum), nullable=False, default=VehicleTypeEnum.FOUR_WHEELER)
    parking_slot: Mapped[Optional[str]] = mapped_column(String(50), nullable=True)
    sticker_number: Mapped[Optional[str]] = mapped_column(String(50), nullable=True)
    status: Mapped[str] = mapped_column(String(20), nullable=False, default="ACTIVE")

    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))

class EmergencyContactModel:
    """
    SQLAlchemy 2.0 Model representing Society Emergency Directory item.
    Conforms strictly to DATABASE_ARCHITECTURE.md (section 7.6).
    """
    __tablename__ = "emergency_contacts"

    id: Mapped[UUID] = mapped_column(primary_key=True, default=uuid4)
    society_id: Mapped[UUID] = mapped_column(ForeignKey("societies.id", ondelete="CASCADE"), nullable=False, index=True)

    designation: Mapped[str] = mapped_column(String(100), nullable=False)
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    phone: Mapped[str] = mapped_column(String(20), nullable=False)
    category: Mapped[str] = mapped_column(String(50), nullable=False)
    icon_name: Mapped[Optional[str]] = mapped_column(String(50), nullable=True)

    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
