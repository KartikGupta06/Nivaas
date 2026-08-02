from datetime import datetime, timezone
from typing import Optional
from uuid import UUID, uuid4
from sqlalchemy import String, Integer, DateTime, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column

class Wing:
    """
    SQLAlchemy 2.0 Model representing Wing / Block within a Society.
    Conforms strictly to DATABASE_ARCHITECTURE.md
    """
    __tablename__ = "wings"

    id: Mapped[UUID] = mapped_column(primary_key=True, default=uuid4)
    society_id: Mapped[UUID] = mapped_column(ForeignKey("societies.id", ondelete="CASCADE"), nullable=False, index=True)
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    total_floors: Mapped[int] = mapped_column(Integer, nullable=False, default=4)
    flats_per_floor: Mapped[int] = mapped_column(Integer, nullable=False, default=4)
    basement_floors: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    has_terrace: Mapped[bool] = mapped_column(nullable=False, default=False)
    floor_numbering_strategy: Mapped[str] = mapped_column(String(50), nullable=False, default="FLOOR_HUNDREDS")
    display_order: Mapped[int] = mapped_column(Integer, nullable=False, default=0)

    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
