from fastapi import APIRouter, HTTPException, status, Header, Depends, Query
from typing import List, Optional
from uuid import uuid4
from datetime import datetime, timezone

from ...schemas.visitor import (
    VisitorRegistrationSchema,
    DeliveryEntrySchema,
    EmergencyEntrySchema,
    VisitorApprovalSchema,
    VisitorLogResponseSchema,
    GateSummarySchema,
)

router = APIRouter(prefix="/visitor", tags=["Visitor & Gate Management System"])

@router.get("/summary", response_model=GateSummarySchema, summary="Get Gate Live Summary Counters")
async def get_gate_summary(authorization: Optional[str] = Header(None)):
    return GateSummarySchema(
        today_total=24,
        visitors_inside=5,
        visitors_exited=17,
        pending_approvals=2,
        gate_name="Main Gate 01",
    )

@router.post("/register", response_model=VisitorLogResponseSchema, status_code=status.HTTP_201_CREATED)
async def register_visitor(payload: VisitorRegistrationSchema):
    log_id = f"vlog_{uuid4().hex[:12]}"
    pass_code = f"PASS-{uuid4().hex[:6].upper()}"
    now_str = datetime.now(timezone.utc).strftime("%d %b %Y, %I:%M %p")

    return VisitorLogResponseSchema(
        id=log_id,
        visitor_name=payload.visitor_name,
        visitor_phone=payload.phone,
        flat_number=payload.flat_number,
        wing_name=payload.wing_name,
        purpose=payload.purpose,
        entry_type="GUEST",
        status="WAITING_APPROVAL",
        pass_code=pass_code,
        vehicle_number=payload.vehicle_number,
        visitor_count=payload.visitor_count,
        photo_url=payload.photo_url,
        check_in_time=now_str,
        gate_name="Main Gate",
        guard_name="Guard Bahadur Singh",
    )

@router.post("/delivery", response_model=VisitorLogResponseSchema, status_code=status.HTTP_201_CREATED)
async def register_delivery(payload: DeliveryEntrySchema):
    log_id = f"del_{uuid4().hex[:12]}"
    pass_code = f"DEL-{uuid4().hex[:6].upper()}"
    now_str = datetime.now(timezone.utc).strftime("%d %b %Y, %I:%M %p")

    return VisitorLogResponseSchema(
        id=log_id,
        visitor_name=f"{payload.vendor} ({payload.delivery_person_name})",
        visitor_phone=payload.phone or "+91 9876500000",
        flat_number=payload.flat_number,
        wing_name=payload.wing_name,
        purpose=f"Delivery ({payload.vendor})",
        entry_type="DELIVERY",
        status="CHECKED_IN",
        pass_code=pass_code,
        check_in_time=now_str,
    )

@router.post("/emergency", response_model=VisitorLogResponseSchema, status_code=status.HTTP_201_CREATED)
async def register_emergency(payload: EmergencyEntrySchema):
    log_id = f"emg_{uuid4().hex[:12]}"
    pass_code = f"EMG-{uuid4().hex[:6].upper()}"
    now_str = datetime.now(timezone.utc).strftime("%d %b %Y, %I:%M %p")

    return VisitorLogResponseSchema(
        id=log_id,
        visitor_name=f"EMERGENCY ({payload.emergency_type})",
        visitor_phone="112",
        flat_number=payload.flat_number or "ALL",
        wing_name="ALL",
        purpose=f"Emergency SOS ({payload.emergency_type})",
        entry_type="EMERGENCY",
        status="CHECKED_IN",
        pass_code=pass_code,
        check_in_time=now_str,
    )

@router.post("/approve", response_model=VisitorLogResponseSchema)
async def approve_visitor(payload: VisitorApprovalSchema):
    now_str = datetime.now(timezone.utc).strftime("%d %b %Y, %I:%M %p")
    new_status = "APPROVED" if payload.approved else "REJECTED"

    return VisitorLogResponseSchema(
        id=payload.log_id,
        visitor_name="Rajesh Verma",
        visitor_phone="+91 9876543210",
        flat_number="402",
        wing_name="Wing A",
        purpose="Guest",
        entry_type="GUEST",
        status=new_status,
        pass_code="PASS-A402",
        check_in_time=now_str,
    )

@router.post("/check-out/{log_id}", response_model=VisitorLogResponseSchema)
async def check_out_visitor(log_id: str):
    now_str = datetime.now(timezone.utc).strftime("%d %b %Y, %I:%M %p")

    return VisitorLogResponseSchema(
        id=log_id,
        visitor_name="Rajesh Verma",
        visitor_phone="+91 9876543210",
        flat_number="402",
        wing_name="Wing A",
        purpose="Guest",
        entry_type="GUEST",
        status="CHECKED_OUT",
        pass_code="PASS-A402",
        check_in_time="Today, 02:15 PM",
        check_out_time=now_str,
        duration_minutes=45,
    )

@router.get("/history", response_model=List[VisitorLogResponseSchema])
async def get_visitor_history(
    search: Optional[str] = Query(None),
    status: Optional[str] = Query(None),
    entry_type: Optional[str] = Query(None),
):
    now_str = datetime.now(timezone.utc).strftime("%d %b %Y, %I:%M %p")

    return [
        VisitorLogResponseSchema(
            id="log_001",
            visitor_name="Rajesh Verma",
            visitor_phone="+91 9876543210",
            flat_number="402",
            wing_name="Wing A",
            purpose="Guest",
            entry_type="GUEST",
            status="CHECKED_IN",
            pass_code="PASS-9102",
            vehicle_number="DL 01 XY 1234",
            visitor_count=2,
            check_in_time="Today, 04:30 PM",
        ),
        VisitorLogResponseSchema(
            id="log_002",
            visitor_name="Swiggy Delivery (Ravi Kumar)",
            visitor_phone="+91 9876511111",
            flat_number="104",
            wing_name="Wing B",
            purpose="Food Delivery (Swiggy)",
            entry_type="DELIVERY",
            status="CHECKED_OUT",
            pass_code="DEL-8812",
            check_in_time="Today, 03:10 PM",
            check_out_time="Today, 03:22 PM",
            duration_minutes=12,
        ),
        VisitorLogResponseSchema(
            id="log_003",
            visitor_name="Sunita Devi (Maid)",
            visitor_phone="+91 98111 22334",
            flat_number="402",
            wing_name="Wing A",
            purpose="Daily Maid",
            entry_type="FREQUENT",
            status="CHECKED_OUT",
            pass_code="FRQ-1002",
            check_in_time="Today, 09:00 AM",
            check_out_time="Today, 11:30 AM",
            duration_minutes=150,
        ),
    ]
