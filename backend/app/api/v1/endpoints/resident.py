from fastapi import APIRouter, HTTPException, status, Header, Depends
from typing import List, Optional
from uuid import uuid4

from ...schemas.resident import (
    ResidentProfileSchema,
    ResidentProfileUpdateSchema,
    HouseDetailSchema,
    FamilyMemberSchema,
    ResidentVehicleSchema,
    EmergencyContactSchema,
    SocietyInfoSchema,
    ResidentDashboardResponseSchema,
)

router = APIRouter(prefix="/resident", tags=["Resident Module"])

@router.get(
    "/dashboard",
    response_model=ResidentDashboardResponseSchema,
    summary="Get Resident Dashboard overview data",
)
async def get_resident_dashboard(
    authorization: Optional[str] = Header(None),
):
    """
    Returns full resident dashboard data including Profile, House details, and Counters.
    """
    profile = ResidentProfileSchema(
        id="res_101",
        phone="+91 9876543210",
        full_name="Priya Nair",
        email="priya.nair@example.com",
        role="OWNER",
        emergency_contact="+91 9876500000",
        full_address="Flat A-402, Green Park Apartments, Sector 12, Dwarka, New Delhi",
        avatar_url=None,
        house_assignment="Wing A - Flat 402",
    )

    house = HouseDetailSchema(
        house_id="house_402",
        flat_number="402",
        wing_name="Wing A",
        floor_number=4,
        house_type="3BHK",
        area_sq_ft=1450.0,
        ownership_status="OWNER",
        maintenance_category="STANDARD",
        parking_slot="P1-A402",
        society_name="Green Park Apartments RWA",
        move_in_date="15 Jan 2024",
    )

    return ResidentDashboardResponseSchema(
        profile=profile,
        house=house,
        family_members_count=2,
        vehicles_count=2,
        emergency_contacts_count=7,
        recent_activity=[],
        upcoming_dues=[],
    )

@router.get("/profile", response_model=ResidentProfileSchema)
async def get_resident_profile():
    return ResidentProfileSchema(
        id="res_101",
        phone="+91 9876543210",
        full_name="Priya Nair",
        email="priya.nair@example.com",
        role="OWNER",
        emergency_contact="+91 9876500000",
        full_address="Flat A-402, Green Park Apartments, Sector 12, Dwarka, New Delhi",
        avatar_url=None,
        house_assignment="Wing A - Flat 402",
    )

@router.put("/profile", response_model=ResidentProfileSchema)
async def update_resident_profile(payload: ResidentProfileUpdateSchema):
    return ResidentProfileSchema(
        id="res_101",
        phone="+91 9876543210",
        full_name=payload.full_name or "Priya Nair",
        email=payload.email or "priya.nair@example.com",
        role="OWNER",
        emergency_contact=payload.emergency_contact or "+91 9876500000",
        full_address="Flat A-402, Green Park Apartments, Sector 12, Dwarka, New Delhi",
        avatar_url=payload.avatar_url,
        house_assignment="Wing A - Flat 402",
    )

@router.get("/house", response_model=HouseDetailSchema)
async def get_house_details():
    return HouseDetailSchema(
        house_id="house_402",
        flat_number="402",
        wing_name="Wing A",
        floor_number=4,
        house_type="3BHK",
        area_sq_ft=1450.0,
        ownership_status="OWNER",
        maintenance_category="STANDARD",
        parking_slot="P1-A402",
        society_name="Green Park Apartments RWA",
        move_in_date="15 Jan 2024",
    )

@router.get("/family", response_model=List[FamilyMemberSchema])
async def get_family_members():
    return [
        FamilyMemberSchema(
            id="fam_1",
            name="Rohan Nair",
            relationship="Spouse",
            role="Owner",
            contact_number="+91 9876543211",
            is_child=False,
            is_senior_citizen=False,
        ),
        FamilyMemberSchema(
            id="fam_2",
            name="Aarav Nair",
            relationship="Son",
            role="Children",
            contact_number=None,
            is_child=True,
            is_senior_citizen=False,
        ),
    ]

@router.post("/family", response_model=FamilyMemberSchema, status_code=status.HTTP_201_CREATED)
async def add_family_member(payload: FamilyMemberSchema):
    return payload

@router.get("/vehicles", response_model=List[ResidentVehicleSchema])
async def get_resident_vehicles():
    return [
        ResidentVehicleSchema(
            id="veh_1",
            vehicle_number="DL 01 AB 1234",
            vehicle_type="FOUR_WHEELER",
            parking_slot="P1-A402",
            sticker_number="STK-2026-091",
            status="ACTIVE",
        ),
        ResidentVehicleSchema(
            id="veh_2",
            vehicle_number="DL 01 XY 5678",
            vehicle_type="TWO_WHEELER",
            parking_slot="P2-A402",
            sticker_number="STK-2026-092",
            status="ACTIVE",
        ),
    ]

@router.post("/vehicles", response_model=ResidentVehicleSchema, status_code=status.HTTP_201_CREATED)
async def add_resident_vehicle(payload: ResidentVehicleSchema):
    return payload

@router.get("/emergency-contacts", response_model=List[EmergencyContactSchema])
async def get_emergency_contacts():
    return [
        EmergencyContactSchema(
            id="ec_1", designation="Main Gate Security", name="Security Desk", phone="+91 11 2800 0001", category="SECURITY", icon_name="security"
        ),
        EmergencyContactSchema(
            id="ec_2", designation="Society Admin Office", name="Manager Office", phone="+91 11 2800 0002", category="OFFICE", icon_name="business"
        ),
        EmergencyContactSchema(
            id="ec_3", designation="Society Electrician", name="Ramesh Kumar", phone="+91 98111 22334", category="ELECTRICIAN", icon_name="bolt"
        ),
        EmergencyContactSchema(
            id="ec_4", designation="Society Plumber", name="Suresh Verma", phone="+91 98222 33445", category="PLUMBER", icon_name="water_drop"
        ),
        EmergencyContactSchema(
            id="ec_5", designation="Fire Control Room", name="Fire Station Dwarka", phone="101", category="FIRE", icon_name="local_fire_department"
        ),
        EmergencyContactSchema(
            id="ec_6", designation="Emergency Ambulance", name="Max Hospital Ambulance", phone="102", category="AMBULANCE", icon_name="medical_services"
        ),
        EmergencyContactSchema(
            id="ec_7", designation="Local Police Station", name="Dwarka Police Station", phone="112", category="POLICE", icon_name="local_police"
        ),
    ]

@router.get("/society", response_model=SocietyInfoSchema)
async def get_society_info():
    return SocietyInfoSchema(
        id="soc_001",
        name="Green Park Apartments RWA",
        address="Sector 12, Dwarka, New Delhi - 110075",
        office_contact="+91 11 2800 0002",
        office_timing="09:00 AM - 06:00 PM (Tue - Sun)",
        emergency_numbers=["+91 11 2800 0001", "112"],
        committee_members=["Rajesh Sharma (President)", "Sunil Gupta (Secretary)", "Anita Roy (Treasurer)"],
    )
