# SeedWork vs SharedKernel in DDD

This document compares `Csnp.SeedWork.Domain` and `Csnp.SharedKernel.Domain`, explaining their roles, differences, and usage guidelines in a Domain-Driven Design (DDD) architecture.

---

## Purpose

| Category              | Csnp.SeedWork.Domain                              | Csnp.SharedKernel.Domain                        |
|----------------------|---------------------------------------------------|-------------------------------------------------|
| Purpose              | Technical foundations for DDD                    | Common business concepts shared across domains |
| Focus                | Abstractions and base classes for domain modeling| Stable domain-level value objects & exceptions |
| Scope                | Internal to DDD infrastructure                   | Shared between multiple bounded contexts       |

---

## Contents

| Category              | Csnp.SeedWork.Domain                              | Csnp.SharedKernel.Domain                        |
|----------------------|---------------------------------------------------|-------------------------------------------------|
| Contains             | Entity, ValueObject, DomainEvent, IAggregateRoot | EmailAddress, InvalidEmailException, Validators |
| Business logic       | ❌ Not included                                   | ✅ Lightweight, stable logic                    |
| Dependencies         | None or very minimal                             | Might reference domain value object validators |

---

## Examples

### Csnp.SeedWork.Domain
```csharp
public abstract class Entity<TId> { ... }
public abstract class ValueObject { ... }
public interface IAggregateRoot { }
```

### Csnp.SharedKernel.Domain
```csharp
public sealed class EmailAddress : ValueObject { ... }
public class InvalidEmailException : Exception { ... }
```

---

## Best Practices

| Guideline                                               | Recommendation                         |
|---------------------------------------------------------|----------------------------------------|
| Keep SeedWork free from business logic                  | ✅                                      |
| Keep SharedKernel small and stable                     | ✅                                      |
| Avoid sharing large domain services via SharedKernel   | ✅ Use contracts and abstractions only |
| Avoid circular dependencies between SeedWork/SharedKernel| ✅ Strict separation                    |

---

## Summary

| Aspect        | Csnp.SeedWork.Domain        | Csnp.SharedKernel.Domain         |
|---------------|-----------------------------|----------------------------------|
| Role          | DDD infrastructure base     | Shared business model elements   |
| Granularity   | Generic, abstract            | Specific, reusable value objects |
| Change Rate   | Rare                        | Infrequent but business-driven   |
| Reusability   | High (internal only)        | High (shared across domains)     |

Use both thoughtfully to support scalable and maintainable domain models.

