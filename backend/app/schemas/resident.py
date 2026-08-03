from typing import List, Optional
from pydantic import BaseModel, EmailStr, Field

class ResidentProfileSchema(BaseModel):
    id: str
    phone: str
    full_name: str
    email: Optional[EmailStr] = None
    role: str = "OWNER"
    emergency_contact: Optional[str] = None
    full_address: Optional[str] = None
    avatar_url: Optional[str] = None
    house_assignment: Optional[str] = None

class ResidentProfileUpdateSchema(BaseModel):
    full_name: Optional[str] = None
    email: Optional[EmailStr] = None
    emergency_contact: Optional[str] = None
    avatar_url: Optional[str] = None

class HouseDetailSchema(BaseModel):
    house_id: str
    flat_number: str
    wing_name: str
    floor_number: int
    house_type: str = "bhk2"
    area_sq_ft: Optional[float] = None
    ownership_status: str = "OWNER"
    maintenance_category: str = "STANDARD"
    parking_slot: Optional[str] = None
    society_name: str
    move_in_date: Optional[str] = None

class FamilyMemberSchema(BaseModel):
    id: str
    name: str
    relationship: str
    role: str = "Family Member"
    contact_number: Optional[str] = None
    is_child: bool = False
    is_senior_citizen: bool = False

class ResidentVehicleSchema(BaseModel):
    id: str
    vehicle_number: str
    vehicle_type: str = "FOUR_WHEELER"
    parking_slot: Optional[str] = None
    sticker_number: Optional[str] = None
    status: str = "ACTIVE"

class EmergencyContactSchema(BaseModel):
    id: str
    designation: str
    name: str
    phone: str
    category: str
    icon_name: Optional[str] = None

class SocietyInfoSchema(BaseModel):
    id: str
    name: str
    address: str
    office_contact: str
    office_timing: str
    emergency_numbers: List[str] = []
    committee_members: List[str] = []

class ResidentDashboardResponseSchema(BaseModel):
    profile: ResidentProfileSchema
    house: HouseDetailSchema
    family_members_count: int
    vehicles_count: int
    emergency_contacts_count: int
    recent_activity: List[str] = []
    upcoming_dues: List[str] = []
