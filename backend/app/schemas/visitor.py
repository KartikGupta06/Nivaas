from typing import List, Optional
from pydantic import BaseModel, Field

class VisitorRegistrationSchema(BaseModel):
    visitor_name: str = Field(..., min_length=2, max_length=100)
    phone: str = Field(..., regex=r"^[6-9]\d{9}$")
    purpose: str = "Guest"
    wing_name: str
    flat_number: str
    vehicle_number: Optional[str] = None
    visitor_count: int = Field(1, ge=1, le=50)
    photo_url: Optional[str] = None
    id_proof_url: Optional[str] = None
    expected_duration: Optional[str] = None
    notes: Optional[str] = None

class DeliveryEntrySchema(BaseModel):
    vendor: str # SWIGGY, ZOMATO, AMAZON, BLINKIT, etc.
    flat_number: str
    wing_name: str = "Wing A"
    delivery_person_name: str = "Delivery Partner"
    phone: Optional[str] = None

class EmergencyEntrySchema(BaseModel):
    emergency_type: str # AMBULANCE, POLICE, FIRE, SOS
    flat_number: Optional[str] = "All Flats"
    notes: Optional[str] = None

class VisitorApprovalSchema(BaseModel):
    log_id: str
    approved: bool
    notes: Optional[str] = None

class VisitorLogResponseSchema(BaseModel):
    id: str
    visitor_name: str
    visitor_phone: str
    flat_number: str
    wing_name: str
    purpose: str
    entry_type: str
    status: str
    pass_code: Optional[str] = None
    vehicle_number: Optional[str] = None
    visitor_count: int = 1
    photo_url: Optional[str] = None
    check_in_time: str
    check_out_time: Optional[str] = None
    duration_minutes: Optional[int] = None
    gate_name: str = "Main Gate"
    guard_name: str = "Security Guard"

class GateSummarySchema(BaseModel):
    today_total: int
    visitors_inside: int
    visitors_exited: int
    pending_approvals: int
    gate_name: str = "Main Gate"
