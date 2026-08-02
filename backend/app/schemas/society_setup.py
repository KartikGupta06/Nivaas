from typing import List, Optional
from pydantic import BaseModel, EmailStr, Field

class SocietyProfileSchema(BaseModel):
    id: Optional[str] = None
    name: str = Field(..., min_length=2, max_length=255)
    type: str = "housingSociety"
    address: str
    city: str
    state: str
    pin_code: str = Field(..., regex=r"^\d{6}$")
    country: str = "India"
    contact_number: str = Field(..., regex=r"^[6-9]\d{9}$")
    email: Optional[EmailStr] = None
    registration_number: Optional[str] = None
    logo_url: Optional[str] = None

class WingConfigSchema(BaseModel):
    id: str
    name: str
    total_floors: int = Field(4, ge=1, le=100)
    flats_per_floor: int = Field(4, ge=1, le=50)
    basement_floors: int = 0
    has_terrace: bool = False
    floor_numbering_strategy: str = "FLOOR_HUNDREDS"

class HouseUnitSchema(BaseModel):
    id: str
    wing_name: str
    floor_number: int
    flat_number: str
    type: str = "bhk2"
    area_sq_ft: Optional[float] = None
    owner_name: Optional[str] = None
    owner_phone: Optional[str] = None
    owner_email: Optional[str] = None
    emergency_contact: Optional[str] = None
    occupancy_status: str = "ownerOccupied"

class MaintenanceConfigSchema(BaseModel):
    rule_type: str = "fixed"
    default_amount: float = 2500.0
    due_date_day: int = Field(5, ge=1, le=28)
    late_fee_amount: float = 0.0
    grace_period_days: int = 0

class SocietySetupPayloadSchema(BaseModel):
    profile: SocietyProfileSchema
    wings: List[WingConfigSchema]
    houses: List[HouseUnitSchema]
    maintenance: MaintenanceConfigSchema

class SocietySetupResponseSchema(BaseModel):
    success: bool
    society_id: str
    message: str
    total_houses_created: int
    invitation_link: str
