from datetime import datetime, timezone
from typing import Optional
from uuid import UUID, uuid4
from sqlalchemy import String, DateTime, ForeignKey, Enum as SQLEnum
from sqlalchemy.orm import Mapped, mapped_column
import enum

class OccupancyStatusEnum(str, enum.Enum):
    OWNER_OCCUPIED = "ownerOccupied"
    TENANT_OCCUPIED = "tenantOccupied"
    VACANT = "vacant"
    UNOCCUPIED = "unoccupied"

class OwnerAssignment:
    """
    SQLAlchemy 2.0 Model representing Initial Owner Assignment.
    Conforms strictly to DATABASE_ARCHITECTURE.md
    """
    __tablename__ = "owner_assignments"

    id: Mapped[UUID] = mapped_column(primary_key=True, default=uuid4)
    society_id: Mapped[UUID] = mapped_column(ForeignKey("societies.id", ondelete="CASCADE"), nullable=False, index=True)
    house_id: Mapped[UUID] = mapped_column(ForeignKey("houses.id", ondelete="CASCADE"), nullable=False, index=True)
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    phone: Mapped[str] = mapped_column(String(15), nullable=False, index=True)
    email: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)
    emergency_contact: Mapped[Optional[str]] = mapped_column(String(15), nullable=True)
    occupancy_status: Mapped[OccupancyStatusEnum] = mapped_column(SQLEnum(OccupancyStatusEnum), nullable=False, default=OccupancyStatusEnum.OWNER_OCCUPIED)
    assigned_by_admin_id: Mapped[UUID] = mapped_column(nullable=False)

    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
