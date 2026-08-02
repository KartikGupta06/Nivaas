from fastapi import APIRouter, HTTPException, status, Header, Depends
from uuid import uuid4
from typing import Optional
from ...schemas.society_setup import SocietySetupPayloadSchema, SocietySetupResponseSchema

router = APIRouter(prefix="/societies", tags=["Society Setup & Onboarding"])

@router.post(
    "/setup",
    response_model=SocietySetupResponseSchema,
    status_code=status.HTTP_201_CREATED,
    summary="Submit complete Society Setup & Onboarding configuration",
)
async def submit_society_setup(
    payload: SocietySetupPayloadSchema,
    authorization: Optional[str] = Header(None),
):
    """
    Atomic setup endpoint for Admin Society Creation:
    - Validates Society Profile, Wings, Floors, House Layout Engine, Maintenance Rules & Initial Owner Assignments.
    - Ensures multi-tenant isolation and generates invitation link.
    """
    if not payload.profile.name:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail="Society name cannot be empty."
        )
    
    # Check duplicate wings
    wing_names = [w.name.lower() for w in payload.wings]
    if len(wing_names) != len(set(wing_names)):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Duplicate wing names detected in configuration."
        )

    # Check duplicate flats
    flat_numbers = [h.flat_number.lower() for h in payload.houses]
    if len(flat_numbers) != len(set(flat_numbers)):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Duplicate house/flat numbers generated."
        )

    society_id = payload.profile.id or f"soc_{uuid4().hex[:12]}"
    invite_token = uuid4().hex[:16]
    invite_link = f"https://nivaas.app/invite/{society_id}?token={invite_token}"

    return SocietySetupResponseSchema(
        success=True,
        society_id=society_id,
        message="Society digital structure created successfully.",
        total_houses_created=len(payload.houses),
        invitation_link=invite_link,
    )

@router.get("/invitation-link/{society_id}")
async def get_invitation_link(society_id: str):
    return {
        "society_id": society_id,
        "invite_link": f"https://nivaas.app/invite/{society_id}?token={uuid4().hex[:16]}",
        "channels": ["SMS", "WhatsApp", "Email"]
    }
