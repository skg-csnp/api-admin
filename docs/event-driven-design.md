# 📬 Event-Driven Design

This document explains the event-driven architecture used in the CSNP Platform, including concepts, responsibilities, and implementation guidance.

---

## 📦 Why Event-Driven?

Event-driven design helps decouple bounded contexts and promote asynchronous communication, allowing the platform to scale and evolve independently across services.

Key benefits:
- Loose coupling between services
- Reactive and scalable communication
- Clear audit trails and event sourcing capabilities

---

## 🔑 Core Concepts

### Integration Events
- Represent cross-module or cross-service events
- Typically published via RabbitMQ or a similar message broker
- Should be immutable and carry only necessary data

Example:
```csharp
public record UserSignedUpIntegrationEvent(Guid UserId, string Email) : IntegrationEvent;
```

### Event Handlers
- Implement logic triggered when an event is received
- Typically in the form of `IIntegrationHandler<T>`

```csharp
public class UserSignedUpHandler : IIntegrationHandler<UserSignedUpIntegrationEvent>
{
    public Task Handle(UserSignedUpIntegrationEvent @event, CancellationToken cancellationToken)
    {
        // e.g. Send welcome email
        return Task.CompletedTask;
    }
}
```

---

## 📚 Event Flow in CSNP

```
[Credential Module] --(UserSignedUpEvent)--> [RabbitMQ] --> [Notification Module]
```

1. `Credential.Application` raises domain event internally
2. Event is published as `IntegrationEvent` via `RabbitMqPublisher`
3. `Notification.Application` handles event to trigger email sending

---

## ⚙️ Setup in Code

- Define domain events → `IDomainEvent`
- Raise them from aggregate roots → `AddDomainEvent()`
- Dispatch events via `IDomainEventDispatcher`
- Map to `IntegrationEvent` and publish via RabbitMQ
- Subscribe to events in other services using `IIntegrationHandler<>`

---

## ✅ Best Practices

- Keep events small and meaningful
- Do not use events for critical sync logic (e.g. payments)
- Log and retry failed handlers gracefully
- Keep event contracts stable (version carefully)

---

Event-driven design allows your system to grow with minimal friction and maximum flexibility 💡

