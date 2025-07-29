# ⚙️ CQRS + Application Layer

This document describes how the CSNP Platform applies the Command Query Responsibility Segregation (CQRS) pattern with a clean separation of application logic.

---

## 🧩 What is CQRS?

CQRS separates **read** and **write** operations into different models:
- **Commands**: change system state (create, update, delete)
- **Queries**: retrieve data without side effects

Benefits:
- Better scalability
- Clear responsibility separation
- Easier to evolve read/write independently

---

## 🏗 Structure Overview

Each bounded context (e.g., `Credential`) has:

```
Application/
├── Commands/
│   ├── CreateUser/
│   │   ├── CreateUserCommand.cs
│   │   ├── CreateUserHandler.cs
│   │   └── CreateUserValidator.cs
├── Queries/
│   ├── GetUser/
│   │   ├── GetUserQuery.cs
│   │   └── GetUserHandler.cs
├── Abstractions/
│   └── IUserWriteRepository.cs
│   └── IUserReadRepository.cs
```

---

## 📦 Commands

- Encapsulate intent to change the system
- Always have a `Command` + `Handler` + `Validator`
- Use `MediatR` for handling commands via `IRequest<T>`

```csharp
public record CreateUserCommand(string Email) : IRequest<Guid>;
```

```csharp
public class CreateUserHandler : IRequestHandler<CreateUserCommand, Guid>
{
    public async Task<Guid> Handle(CreateUserCommand request, CancellationToken ct)
    {
        // Business logic + persistence
        return newUserId;
    }
}
```

---

## 🔍 Queries

- Only return data (no side effects)
- Use a `Query` + `Handler` pair
- Handlers use `IUserReadRepository` or projections

```csharp
public record GetUserQuery(Guid UserId) : IRequest<UserDto>;
```

---

## 🧠 Design Decisions

- Each handler lives in its own folder (by feature)
- Validation is isolated using FluentValidation
- Interfaces are split: `IUserReadRepository` vs `IUserWriteRepository`

---

## ✅ Best Practices

- Keep command/query logic thin — delegate to domain or services
- Avoid mixing concerns between commands and queries
- Use response types consistently (e.g. `IResult<T>`)
- Do not leak EF entities to handlers directly — map to DTOs

---

CQRS helps enforce clean boundaries and clear flows of responsibility 🧠

