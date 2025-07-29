# CSNP Platform

A production-ready platform built with **Domain-Driven Design (DDD)**, **Clean Architecture**, **CQRS**, and **Event-Driven Microservices** using **.NET 9**, orchestrated with **Kubernetes**.

---

## 💭 Features

- ✅ Modular bounded contexts (Credential, Notification, etc.)
- ✅ Clean separation of concerns (Domain, Application, Infrastructure)
- ✅ CQRS and MediatR pipeline behaviors
- ✅ Domain Events & Integration Events
- ✅ Event-driven communication with RabbitMQ
- ✅ EF Core + FluentValidation
- ✅ Multi-level caching (Memory, Redis)
- ✅ Health checks, metrics, and tracing (Prometheus, Serilog)

---

## 🚀 Getting Started

```bash
# Clone repository
git clone https://github.com/skg-csnp/api-web.git
cd api-web

# Run locally with .NET CLI
dotnet run --project src/Csnp.Presentation.Web
```

---

## 📁 Project Structure

```
src/
├── Credential/              # Bounded Context 1
├── Notification/            # Bounded Context 2

shared/
├── Common/                  # Cross-cutting technical utilities
├── Csnp.SeedWork/           # DDD base abstractions (Entity, ValueObject, Events)
└── Csnp.SharedKernel/       # Shared domain logic (Email, Money, etc.)

migrations/
├── Csnp.Migrations.Credential/     # EF Core migrations for Credential
└── Csnp.Migrations.Notification/   # EF Core migrations for Notification

docs/                        # Architecture and design documentation                        # Architecture and design documentation                        # Architecture and design documentation                        # Architecture and design documentation
```

---

## 📚 Documentation

| Topic                         | Link                                                               |
|-------------------------------|--------------------------------------------------------------------|
| 🧱 Architecture Overview      | [docs/architecture.md](docs/architecture.md)                       |
| 📀 Domain Structure           | [docs/domain-structure.md](docs/domain-structure.md)               |
| 📬 Event-Driven Design        | [docs/event-driven-design.md](docs/event-driven-design.md)         |
| ⚙️ CQRS + Application         | [docs/cqrs-pattern.md](docs/cqrs-pattern.md)                       |
| 📁 SeedWork vs SharedKernel   | [docs/domain-layer-comparison.md](docs/domain-layer-comparison.md) |
| 📁 Format .NET Code           | [docs/dotnet-format-guide.md](docs/dotnet-format-guide.md)         |
| 📁 RESTful API Standards      | [docs/restful-api-guideline.md](docs/restful-api-guideline.md)     |
| 📁 Class Design               | [docs/class-design.md](docs/class-design.md)                       |
| 📁 Shared Database Design     | [docs/shared-db-schema.md](docs/shared-db-schema.md)               |
| 📁 Git ISO process            | [docs/git-iso-process.md](docs/git-iso-process.md)                 |

---

## ✅ Tech Stack

- **Language**: .NET 9, ASP.NET Core, EF Core
- **Messaging**: RabbitMQ
- **Database**: SQL Server, Redis
- **Infrastructure**: Kubernetes, Harbor
- **Observability**: Prometheus, Grafana, Serilog

---

## 🧪 Testing

```bash
# Run all tests
dotnet test
```

---

## ⚙️ CI/CD Overview

- Build & Test: Jenkins pipeline
- GitOps Deploy: ArgoCD sync
- Container Registry: Harbor
- Environment Promotion: Dev → Staging → Production

---

## 🔐 Security Highlights

- JWT Authentication & API rate limiting
- FluentValidation for input security
- TLS termination via Ingress Controller
- Secrets via Kubernetes Secrets + RBAC

---

## 📈 Monitoring & Observability

- Health Checks: `/health`, `/health/live`, `/health/ready`
- Metrics: Prometheus + Grafana dashboards
- Logging: Structured Serilog logs, centralized aggregation

