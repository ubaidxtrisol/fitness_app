# Authentication Process — Pilates Exercises API

Guide for iOS/Android developers integrating API key + app signature auth.

**Production base URL:** `http://56.228.38.227:8128`  
**Repository:** https://github.com/sohailtahir5858/pilates-exercises-app  
**OpenAPI/Swagger:** disabled (`/docs`, `/redoc`, `/openapi.json` → 404)

## 1. Current enforcement status

| Layer | Header(s) | Default |
|-------|-----------|---------|
| API Key | `X-API-KEY` | **Enforced** |
| App Signature | `X-App-Timestamp`, `X-App-Nonce`, `X-App-Signature` | **Not enforced** (`ENFORCE_APP_SIGNATURE=false`) |

Implement signature signing in the app now. When the backend sets `ENFORCE_APP_SIGNATURE=true`, unsigned requests will receive `401`.

## 2. Two auth layers

1. **API Key** — static shared secret from `.env` (`API_KEY`). Required on every route except `GET /health`.
2. **App Signature** — per-request HMAC-SHA256 proof that the call came from your app binary / secure store, with replay protection.

## 3. Required headers (when signature enforcement is on)

```http
X-API-KEY: <API_KEY>
X-App-Timestamp: <unix_seconds>
X-App-Nonce: <unique_random_string>
X-App-Signature: <hmac_sha256_hex>
```

## 4. Signature algorithm (step-by-step)

1. Build **canonical string**:

   ```
   {METHOD}|{PATH}|{TIMESTAMP}|{NONCE}|{BODY_JSON}
   ```

   - `METHOD` — uppercase (`POST`, `GET`, …)
   - `PATH` — URL path only (e.g. `/api/v1/exercises/recommend`), no query string
   - `TIMESTAMP` — Unix epoch seconds as string (same value as `X-App-Timestamp`)
   - `NONCE` — unique string per request (UUID recommended)
   - `BODY_JSON` — see multipart vs JSON rules below

2. Compute:

   ```
   HMAC-SHA256(key = APP_SIGNATURE_SECRET, message = canonical) → hex digest
   ```

3. Send the hex digest as `X-App-Signature`.

### Server checks

- Timestamp not more than **10 seconds** in the future
- Timestamp within **120 second** replay window
- Nonce not reused within the window
- Signature must match exactly (`hmac.compare_digest`)

## 5. Multipart vs JSON signing rules

| Content type | What to sign as `BODY_JSON` |
|--------------|----------------------------|
| `application/json` | Always `{}` (empty object) — do **not** sign the raw JSON body |
| `multipart/form-data` | JSON object of **non-file** fields only, keys **sorted** alphabetically; **file fields excluded** |
| No body / other | `{}` |

Example multipart fields `goal=core&level=beginner` → sign `{"goal":"core","level":"beginner"}` (sorted keys, compact JSON, no spaces).

## 6. Worked examples

### JSON — `POST /api/v1/exercises/recommend`

```
METHOD = POST
PATH   = /api/v1/exercises/recommend
TS     = 1710000000
NONCE  = 9f3c2a1b-xxxx
BODY   = {}
```

Canonical:

```
POST|/api/v1/exercises/recommend|1710000000|9f3c2a1b-xxxx|{}
```

### Multipart — `POST /api/v1/scan/pose`

Form fields: file `image` + optional text field `note=form-check`

Sign only non-file fields:

```
{"note":"form-check"}
```

Canonical:

```
POST|/api/v1/scan/pose|1710000000|9f3c2a1b-xxxx|{"note":"form-check"}
```

If there are no non-file fields, use `{}`.

## 7. Swift implementation + Alamofire

```swift
import CryptoKit
import Foundation
import Alamofire

func appSignature(
    method: String,
    path: String,
    timestamp: String,
    nonce: String,
    bodyJSON: String,
    secret: String
) -> String {
    let canonical = "\(method.uppercased())|\(path)|\(timestamp)|\(nonce)|\(bodyJSON)"
    let key = SymmetricKey(data: Data(secret.utf8))
    let mac = HMAC<SHA256>.authenticationCode(for: Data(canonical.utf8), using: key)
    return mac.map { String(format: "%02x", $0) }.joined()
}

func signedHeaders(
    method: String,
    path: String,
    bodyJSON: String = "{}",
    apiKey: String,
    secret: String
) -> HTTPHeaders {
    let timestamp = String(Int(Date().timeIntervalSince1970))
    let nonce = UUID().uuidString
    let signature = appSignature(
        method: method,
        path: path,
        timestamp: timestamp,
        nonce: nonce,
        bodyJSON: bodyJSON,
        secret: secret
    )
    return [
        "X-API-KEY": apiKey,
        "X-App-Timestamp": timestamp,
        "X-App-Nonce": nonce,
        "X-App-Signature": signature
    ]
}

// JSON example
let path = "/api/v1/exercises/recommend"
let headers = signedHeaders(method: "POST", path: path, apiKey: apiKey, secret: appSecret)
let body: [String: Any] = ["goal": "core strength", "level": "beginner", "duration_minutes": 20]
AF.request("\(baseURL)\(path)", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
    .responseDecodable(of: RecommendResponse.self) { response in
        // handle
    }
```

## 8. Kotlin / Android implementation

```kotlin
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec
import java.util.UUID

fun hmacSha256Hex(secret: String, message: String): String {
    val mac = Mac.getInstance("HmacSHA256")
    mac.init(SecretKeySpec(secret.toByteArray(Charsets.UTF_8), "HmacSHA256"))
    return mac.doFinal(message.toByteArray(Charsets.UTF_8)).joinToString("") { "%02x".format(it) }
}

fun buildSignature(method: String, path: String, timestamp: String, nonce: String, bodyJson: String, secret: String): String {
    val canonical = "${method.uppercase()}|$path|$timestamp|$nonce|$bodyJson"
    return hmacSha256Hex(secret, canonical)
}

fun signedJsonRequest(
    client: OkHttpClient,
    baseUrl: String,
    path: String,
    jsonBody: String,
    apiKey: String,
    secret: String
) {
    val timestamp = (System.currentTimeMillis() / 1000).toString()
    val nonce = UUID.randomUUID().toString()
    // JSON routes always sign "{}"
    val signature = buildSignature("POST", path, timestamp, nonce, "{}", secret)

    val body = jsonBody.toRequestBody("application/json".toMediaType())
    val request = Request.Builder()
        .url("$baseUrl$path")
        .post(body)
        .header("X-API-KEY", apiKey)
        .header("X-App-Timestamp", timestamp)
        .header("X-App-Nonce", nonce)
        .header("X-App-Signature", signature)
        .build()

    client.newCall(request).execute().use { /* handle */ }
}
```

## 9. Error responses when enforcement is on

```json
{ "success": false, "message": "Missing app signature headers." }
```

```json
{ "success": false, "message": "Invalid app signature." }
```

```json
{ "success": false, "message": "Timestamp expired." }
```

```json
{ "success": false, "message": "Nonce already used." }
```

HTTP status: **401**.

Missing/invalid API key also returns **401**:

```json
{ "success": false, "message": "Missing or invalid API key." }
```

## 10. Testing checklist and common mistakes

- [ ] `X-API-KEY` matches server `.env`
- [ ] Path matches exactly (no trailing slash mismatch)
- [ ] Method is uppercase in the canonical string
- [ ] JSON body signed as `{}`, not the real payload
- [ ] Multipart: files excluded; non-file keys sorted
- [ ] Compact JSON (`separators=(',', ':')`) — no spaces after `:`/`,`
- [ ] Fresh nonce every request
- [ ] Device clock roughly in sync (NTP)
- [ ] Secret is `APP_SIGNATURE_SECRET`, not the API key

## 11. What changes when enforcement goes live

1. Backend sets `ENFORCE_APP_SIGNATURE=true` and restarts.
2. All protected routes reject requests without valid signature headers.
3. `GET /health` remains open (no API key, no signature).
4. Rotate `APP_SIGNATURE_SECRET` only with a coordinated mobile release.

Until then, sending signature headers is safe (server ignores them when enforcement is off) and recommended so you can flip the flag without a client hotfix.
