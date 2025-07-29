# CSNP Class Design & Access Modifiers Guidelines

This document defines the conventions for using `public`, `internal`, `private`, `sealed`, `abstract`, and `interface` across the CSNP project structure to ensure consistency, clarity, and maintainability. It also outlines general object-oriented principles followed by the team.

---

## 🔓 public

### ✅ When to use:

- **Application Layer:**
  - All `Command`, `Query`, `DTO`, `Handler`, `Validator` classes should be `public`.
  - Required by MediatR, FluentValidation, and DI reflection.
- **Domain Layer:**
  - Entities, Value Objects, and Enums should be `public` so they can be used across layers.
- **Infrastructure Layer:**
  - Only use `public` if the class is **explicitly accessed by external projects** (e.g., `Program.cs`, shared utilities).
- **API Layer:**
  - Controllers and API contracts must be `public`.

### 🔍 Example:

```csharp
public sealed class CreateUserCommand : IRequest<long> { ... }
```

---

## 🔒 internal

### ✅ When to use:

- **Infrastructure Layer:**
  - Default modifier for most service, repository, and mapper classes.
  - Ensures encapsulation within the module.
- **Application Layer:**
  - ❌ **Avoid** using `internal` here if classes are registered with DI, unless using InternalsVisibleTo (not recommended for modular setup).

### 🔍 Example:

```csharp
internal sealed class EmailLogWriteRepository : IEmailLogWriteRepository { ... }
```

---

## 🔐 private

### ✅ When to use:

- Inside any class, to limit access to internal implementation.
- For fields, helper methods, and encapsulated logic.

### 🔍 Example:

```csharp
private readonly EmailSettings _settings;
private string FormatSubject(string template) { ... }
```

---

## 🧱 sealed

### ✅ When to use:

- Prevent a class from being inherited when:
  - It is a leaf in the inheritance tree.
  - You want to protect internal logic from being overridden.
  - For performance (JIT optimizations).
- Often used with:
  - `Command`, `Handler`, `Validator` in Application Layer.
  - Utility/helper classes.

### 🔍 Example:

```csharp
public sealed class CreateUserCommandValidator : AbstractValidator<CreateUserCommand> { ... }
```

---

## 🧰 abstract

### ✅ When to use:

- When defining base class behavior with shared logic.
- When enforcing a contract without implementing all members.
- Common for shared base classes or template method patterns.

### 🔍 Example:

```csharp
public abstract class DomainEventHandler<T> where T : IDomainEvent
{
    public abstract Task HandleAsync(T @event);
}
```

---

## 📐 interface

### ✅ When to use:

- To define behavior contracts.
- For dependency injection and mocking.
- To allow multiple implementations.
- Always name with `I` prefix (e.g., `IEmailService`).

### 🔍 Example:

```csharp
public interface IEmailService
{
    Task SendEmailAsync(string template, string to, object model);
}
```

---

## Summary Table

| Keyword     | Purpose                             | Layer/Usage Recommendations                             |
| ----------- | ----------------------------------- | ------------------------------------------------------- |
| `public`    | Expose to other assemblies          | Application, Domain, APIs                               |
| `internal`  | Limit to current assembly           | Infrastructure (default)                                |
| `private`   | Limit to class only                 | Fields, helpers                                         |
| `sealed`    | Prevent inheritance                 | Application classes, helper utils                       |
| `abstract`  | Base class with shared behavior     | Domain services, base handlers                          |
| `interface` | Define contracts for DI/testability | All layers, especially for Application & Infrastructure |

---

## ✅ General OOP Guidelines

- Prefer **composition over inheritance**.
- Use `interface` + `sealed` class combo for DI.
- Use `abstract` base class only when **logic is truly shared**.
- Avoid deep inheritance trees (max 2 levels).
- Prefer **explicit interface implementation** only when needed to hide methods.
- Use `record` or `record struct` for ValueObjects (immutability).
- Keep `Domain` logic free from infrastructure dependencies.

---

> Consistent OOP principles help protect boundaries, improve testability, and scale codebase sustainably.

