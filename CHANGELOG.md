# Changelog

All notable changes to this project will be documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and the project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial domain models and value objects
- `EmailAddressValidator` extracted from `EmailAddress`
- Support for domain events

### Changed
- Refactored domain layer into `SeedWork` and `SharedKernel`

### Fixed
- Validation exception handling for invalid email formats

---

## [1.0.0] - 2025-07-30

### Added
- Initial release with DDD, CQRS, Clean Architecture foundation
- Event-Driven communication with RabbitMQ
- Health checks, structured logging, metrics support
