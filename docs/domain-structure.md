# 📀 Domain Structure

This document explains the domain structure design used in the CSNP Platform, including the purpose of key domain layers and how they interact.

---

## 🧱 Core Concepts

### Csnp.SeedWork.Domain

Contains foundational domain building blocks:

- `Entity<T>`: Base class for aggregate roots or entities with identity.
- `ValueObject`: Base class for value objects with equality based on content.
- `IDomainEvent`, `IEntityWithEvents`: Event publishing interfaces.
- `IAggregateRoot`: Marker interface for aggregates.

### Csnp.SharedKernel.Domain

Contains reusable domain concepts shared across bounded contexts:

- Common value objects like `EmailAddress`, `PhoneNumber`
- Domain-specific exceptions (e.g., `InvalidEmailException`)
- Domain validators (e.g., `EmailAddressValidator`)

> 📌 Note: `SharedKernel` has no business rules. It should only hold logic that's **meaningfully shared**, not just utility.

---

## 🔄 Folder Structure

```
shared/
├── Csnp.SeedWork/           # DDD base abstractions
│   ├── Domain/
│   │   ├── Entity.cs
│   │   ├── ValueObject.cs
│   │   ├── IAggregateRoot.cs
│   │   ├── Events/
│   │   │   └── IDomainEvent.cs
├── Csnp.SharedKernel/       # Shared domain logic
│   ├── Domain/
│   │   ├── ValueObjects/
│   │   │   └── EmailAddress.cs
│   │   ├── Exceptions/
│   │   │   └── InvalidEmailException.cs
│   │   ├── Validators/
│   │   │   └── EmailAddressValidator.cs
```

---

## 🧠 Design Rationale

- **Csnp.SeedWork** enables reusable, framework-agnostic DDD patterns.
- **Csnp.SharedKernel** reduces duplication and enforces shared semantics across bounded contexts.
- Both `shared/` projects are **domain-level** and free of infrastructure concerns.

---

## ✅ Best Practices

- Keep logic minimal and reusable.
- Don't introduce infrastructure dependencies.
- Avoid bloating SharedKernel — only move shared business concepts.

---

Let your domain speak clearly. Keep your building blocks lean and purposeful 💡

