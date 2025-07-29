# Shared Database Design with Multiple Schemas

This document describes the database design decision for consolidating multiple microservices (Credential and Notification) into a single PostgreSQL database using separate schemas.

---

## 🎯 Motivation

To simplify local development, reduce infrastructure overhead, and accelerate MVP delivery, we chose to:

- Use **a single PostgreSQL instance** shared between multiple services.
- Isolate data using **PostgreSQL schemas**, one per service.
- Keep **EF Core DbContext per service**, maintaining bounded context integrity.

---

## 🏗️ Design Overview

### ✅ Schema per Service

| Service      | Schema         | DbContext Class         |
| ------------ | -------------- | ----------------------- |
| Credential   | `credential`   | `CredentialDbContext`   |
| Notification | `notification` | `NotificationDbContext` |

- Each schema acts as a namespace for tables, indexes, migrations, etc.
- Ensures **clear boundaries** without needing separate databases.

### ✅ EF Core Configuration

- Each `DbContext` is configured with:
  - `.HasDefaultSchema("credential")` or `.HasDefaultSchema("notification")`
  - Custom `MigrationsHistoryTable` to avoid conflicts:
    ```csharp
    builder.MigrationsHistoryTable("__EFMigrationsHistoryCredential", SchemaNames.Default);
    ```

### ✅ Migrations Projects

| DbContext             | Migrations Project             |
| --------------------- | ------------------------------ |
| CredentialDbContext   | `Csnp.Migrations.Credential`   |
| NotificationDbContext | `Csnp.Migrations.Notification` |

---

## 🔐 Access Control

- Services only access **their own schema** through their own `DbContext`.
- No cross-schema querying to preserve microservice boundaries.

---

## 🧪 Development Workflow

- **Connection string**: shared for both services (e.g. `Database=local_csnp;`)
- `Update-Database` will write to respective schema and maintain separate migration history.
- Migrations stay in their respective migrations projects.

---

## ✅ Benefits

- 🚀 Simplified infrastructure setup for MVP.
- 🔐 Maintains logical separation of concerns.
- 🧩 Easy to scale out to separate DBs later if needed.
- 🛠️ Compatible with CI/CD, Flyway/Liquibase if needed in the future.

---

## 📁 References

- [`SchemaNames.Default`](/src/Notification/Csnp.Notification.Infrastructure/Persistence/Constants/SchemaNames.cs)
- [`NotificationDbContext`](/src/Notification/Csnp.Notification.Infrastructure/Persistence/NotificationDbContext.cs)
- [`CredentialDbContext`](/src/Credential/Csnp.Credential.Infrastructure/Persistence/CredentialDbContext.cs)
- [`NotificationDbContextFactory`](/migrations/Csnp.Migrations.Notification/NotificationDbContextFactory.cs)

---

For questions or changes to this design, contact the platform architect or lead backend developer.

