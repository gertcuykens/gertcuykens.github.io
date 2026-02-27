from fastapi import FastAPI, Request, Response, Header, Cookie, HTTPException
from webauthn import verify_authentication_response, verify_registration_response, options_to_json, generate_authentication_options, generate_registration_options
from webauthn.helpers.structs import RegistrationCredential, AuthenticationCredential, AuthenticatorSelectionCriteria, UserVerificationRequirement
from webauthn.helpers import parse_authentication_credential_json, parse_registration_credential_json
from blake3 import blake3
from hmac import compare_digest
from starlette.middleware.sessions import SessionMiddleware
from base64 import b64encode, b64decode
import asyncpg

# openssl rand -base64 32 | tr -dc 'A-Za-z0-9' | head -c 32; echo
BLAKE3_KEY = b"................................" # 32 byte
user_db = {}
origin="https://signin...cloud"
rp_id="...cloud"
rp_name="..."

app = FastAPI()
app.add_middleware(
    SessionMiddleware,
    secret_key="...",
    session_cookie="webauthn",
    max_age=300
)

@app.on_event("startup")
async def startup():
    app.state.pool = await asyncpg.create_pool(
        user='root',
        database='webauthn',
        host='/run/postgresql',
        min_size=1,
        max_size=10
    )

@app.on_event("shutdown")
async def shutdown():
    await app.state.pool.close()

@app.get("/webauthn/registration-options")
async def registration_options(request: Request, remote_user: str | None = None, remote_username: str | None = None):
    options = generate_registration_options(
        rp_id=rp_id,
        rp_name=rp_name,
        user_id=remote_user.encode(),
        user_name=remote_username,
        authenticator_selection=AuthenticatorSelectionCriteria(
            user_verification=UserVerificationRequirement.PREFERRED,
            # Optional: restrict to platform authenticators (FaceID/TouchID)
            # authenticator_attachment=AuthenticatorAttachment.PLATFORM,
        )
    )

    user_db[remote_user] = {
        "username": remote_username,
        "credentials": []
    }

    request.session["registration"] = b64encode(options.challenge).decode('utf-8')

    return Response(
        content=options_to_json(options),
        media_type="application/json"
    )

@app.post("/webauthn/registration-verify")
async def registration_verify(request: Request, remote_user: str | None = None):
    body = await request.json()
    encoded_challenge = request.session.pop("registration", None)

    if not encoded_challenge:
        return {"error": "Challenge not found"}

    expected_challenge = b64decode(encoded_challenge)

    try:
        verification = verify_registration_response(
            credential=body,
            expected_challenge=expected_challenge,
            expected_origin=origin,
            expected_rp_id=rp_id,
            require_user_verification=True
        )

        new_credential = {
            "credential_id": verification.credential_id,
            "public_key": verification.credential_public_key,
            "sign_count": verification.sign_count,
            "aaguid": str(verification.aaguid),
            "transports": body.get("response", {}).get("transports", [])
        }

        user_db[remote_user]["credentials"].append(new_credential)

        return {"status": "success", "message": "Passkey registered!"}

    except Exception as e:
        print(f"Registration Error: {e}")
        raise HTTPException(status_code=400, detail=str(e))

@app.get("/webauthn/signin-options")
async def signin_options(request: Request, remote_user: str | None = None):
    options = generate_authentication_options(
        rp_id = rp_id,
        user_verification = UserVerificationRequirement.PREFERRED,
    )

    request.session["signin"] = b64encode(options.challenge).decode('utf-8')
    return Response(content = options_to_json(options), media_type = "application/json")

@app.post("/webauthn/signin-verify")
async def signin_verify(request: Request, response: Response, remote_user: str | None = None):
    encoded_challenge = request.session.pop("signin", None)

    if not encoded_challenge:
        return {"error": "Challenge not found"}

    expected_challenge = b64decode(encoded_challenge)

    credential = parse_authentication_credential_json(await request.json())
    remote_credential = None

    user_info = user_db.get(remote_user)
    for cred in user_info.get("credentials", []):
        if cred["credential_id"] == credential.raw_id:
            remote_credential = cred
            break

    if not remote_credential:
        raise HTTPException(status_code=404, detail="No Credential.")

    try:
        verification = verify_authentication_response(
            credential=credential,
            expected_challenge=expected_challenge,
            expected_origin=origin,
            expected_rp_id=rp_id,
            credential_public_key=remote_credential["public_key"],
            credential_current_sign_count=remote_credential["sign_count"]
        )
        remote_credential["sign_count"] = verification.new_sign_count

    except Exception as e:
        print(f"WebAuthn Error: {e}")
        raise HTTPException(status_code=400, detail=f"SignIn Failed: {e}")

    signature = blake3(remote_user.encode(), key=BLAKE3_KEY).hexdigest()
    response.set_cookie(
        key="remote_user",
        value=f"{remote_user}.{signature}",
        httponly=True,
        secure=True,
        samesite="lax"
    )
    return {"status": "authenticated"}

###############################################################################

@app.get("/user")
async def user(remote_user: str | None = Cookie(None)):
    if not remote_user or "." not in remote_user:
        raise HTTPException(status_code=401, detail="Remote User")

    u, s = remote_user.rsplit(".", 1)
    b = blake3(u.encode(), key=BLAKE3_KEY).hexdigest()

    if not compare_digest(s, b):
        raise HTTPException(status_code=401, detail="Signature")

    return Response(
        status_code=200,
        headers={"Remote-User": u}
    )

@app.get("/")
async def uid(remote_user: str | None = Header(None)):
    return {"user": remote_user}

# https://webauthn.io

