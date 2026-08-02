from datetime import datetime, timezone
from typing import Optional
from uuid import UUID, uuid4
from sqlalchemy import String, Integer, Float, DateTime, ForeignKey, Enum as SQLEnum
from sqlalchemy.orm import Mapped, mapped_column
import enum

class RuleTypeEnum(str, enum.Enum):
    FIXED = "fixed"
    FORMULA_BASED = "formulaBased"
    AREA_BASED = "areaBased"

class MaintenanceRule:
    """
    SQLAlchemy 2.0 Model representing Society Maintenance Rules.
    Conforms strictly to DATABASE_ARCHITECTURE.md
    """
    __tablename__ = "maintenance_rules"

    id: Mapped[UUID] = mapped_column(primary_key=True, default=uuid4)
    society_id: Mapped[UUID] = mapped_column(ForeignKey("societies.id", ondelete="CASCADE"), nullable=False, index=True)
    rule_type: Mapped[RuleTypeEnum] = mapped_column(SQLEnum(RuleTypeEnum), nullable=False, default=RuleTypeEnum.FIXED)
    default_amount: Mapped[float] = mapped_column(Float, nullable=False, default=2500.0)
    due_date_day: Mapped[int] = mapped_column(Integer, nullable=False, default=5)
    late_fee_amount: Mapped[float] = mapped_column(Float, nullable=False, default=0.0)
    grace_period_days: Mapped[int] = mapped_column(Integer, nullable=False, default=0)

    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
