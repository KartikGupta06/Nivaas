from datetime import datetime, timezone
from typing import Optional
from uuid import UUID, uuid4
from sqlalchemy import String, Integer, Float, DateTime, ForeignKey, Enum as SQLEnum
from sqlalchemy.orm import Mapped, mapped_column
import enum

class HouseTypeEnum(str, enum.Enum):
    RK1 = "rk1"
    BHK1 = "bhk1"
    BHK2 = "bhk2"
    BHK3 = "bhk3"
    BHK4 = "bhk4"
    PENTHOUSE = "penthouse"
    DUPLEX = "duplex"
    CUSTOM = "custom"

class House:
    """
    SQLAlchemy 2.0 Model representing House / Flat Unit.
    Conforms strictly to DATABASE_ARCHITECTURE.md
    """
    __tablename__ = "houses"

    id: Mapped[UUID] = mapped_column(primary_key=True, default=uuid4)
    society_id: Mapped[UUID] = mapped_column(ForeignKey("societies.id", ondelete="CASCADE"), nullable=False, index=True)
    wing_id: Mapped[UUID] = mapped_column(ForeignKey("wings.id", ondelete="CASCADE"), nullable=False, index=True)
    floor_id: Mapped[Optional[UUID]] = mapped_column(ForeignKey("floors.id", ondelete="SET NULL"), nullable=True)
    
    flat_number: Mapped[str] = mapped_column(String(50), nullable=False, index=True)
    floor_number: Mapped[int] = mapped_column(Integer, nullable=False)
    house_type: Mapped[HouseTypeEnum] = mapped_column(SQLEnum(HouseTypeEnum), nullable=False, default=HouseTypeEnum.BHK2)
    area_sq_ft: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    maintenance_category: Mapped[str] = mapped_column(String(50), nullable=False, default="STANDARD")
    parking_slot: Mapped[Optional[str]] = mapped_column(String(50), nullable=True)

    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
