# CSNP Credential - Environment Setup Guide

This guide explains how to set environment variables for the CSNP Credential and Notification services using `.env` files and platform-specific scripts.

---

## 📁 Files Structure

```
_environment/
├── credential.env          # Environment variable definitions for Credential service
├── notification.env        # Environment variable definitions for Notification service
├── import-env.ps1          # PowerShell script (Windows)
├── import-env.cmd          # Batch script (Windows)
└── README.md               # This documentation
```

---

## 🔧 Step 1: Define Your Environment Variables

Create the following files inside the `_environment/` folder:

### `credential.env`
```env
LOC_CREDENTIAL_RABBITMQ__HOST=localhost
LOC_CREDENTIAL_RABBITMQ__PORT=5672
LOC_CREDENTIAL_RABBITMQ__USERNAME=guest
LOC_CREDENTIAL_RABBITMQ__PASSWORD=guest
LOC_CREDENTIAL_RABBITMQ__VIRTUALHOST=/

LOC_CREDENTIAL_CONNECTIONSTRINGS__DEFAULT=Server=localhost;Database=local_csnp;User Id=local;Password=Local+54321z@;TrustServerCertificate=True;

LOC_CREDENTIAL_JWT__ISSUER=csnp
LOC_CREDENTIAL_JWT__AUDIENCE=csnp_clients
LOC_CREDENTIAL_JWT__SECRETKEY=supersecret_csnp_token_key_123!supersecret_csnp_token_key_123!
LOC_CREDENTIAL_JWT__EXPIRATIONMINUTES=60
```

### `notification.env`
```env
LOC_NOTIFICATION_RABBITMQ__HOST=localhost
LOC_NOTIFICATION_RABBITMQ__PORT=5672
LOC_NOTIFICATION_RABBITMQ__USERNAME=guest
LOC_NOTIFICATION_RABBITMQ__PASSWORD=guest
LOC_NOTIFICATION_RABBITMQ__VIRTUALHOST=/

LOC_CREDENTIAL_CONNECTIONSTRINGS__DEFAULT=Server=localhost;Database=local_csnp;User Id=local;Password=Local+54321z@;TrustServerCertificate=True;

LOC_NOTIFICATION_MINIO__ENDPOINT=localhost:9000
LOC_NOTIFICATION_MINIO__ACCESSKEY=minioadmin
LOC_NOTIFICATION_MINIO__SECRETKEY=minioadmin
LOC_NOTIFICATION_MINIO__SECURE=false
LOC_NOTIFICATION_MINIO__BUCKET=email-templates
```

> 💡 Use double underscores `__` to represent nested JSON properties.

---

## 💻 Step 2: Import on Windows (User-level Environment Variables)

### Option 1: Using PowerShell

```powershell
powershell -ExecutionPolicy Bypass -File .\_environment\import-env.ps1
```

✅ This will permanently add all variables defined in both `.env` files to the **current user profile**.

### Option 2: Using CMD (not recommended — may fail with special characters)

```cmd
_environment\import-env.cmd
```

✅ This will also persist the variables for the user (via `setx`).

> 📝 Changes will take effect in **new terminals only**.

---

## ✅ Verification

To verify the environment variables:

```cmd
echo %LOC_CREDENTIAL_RABBITMQ__HOST%
echo %LOC_NOTIFICATION_MINIO__ENDPOINT%
```

Or in PowerShell:

```powershell
$env:LOC_CREDENTIAL_RABBITMQ__HOST
$env:LOC_NOTIFICATION_MINIO__ENDPOINT
```

---

## 🧹 Optional: Clear Environment Variables

You can manually remove variables from:

- System Properties → Environment Variables → User variables
- Or run: `[System.Environment]::SetEnvironmentVariable("VAR_NAME", $null, "User")`

---

## 🧪 Tips

- This structure supports JSON-style config binding in .NET.
- Use one `.env` file per service or per environment (e.g., `dev.env`, `prod.env`).
- For Docker, you can reuse the same `.env` file via `env_file`.

---

Feel free to adapt this script to Linux/macOS using `export` and `source` if needed.

