# RESTful API Standards for Csnp.Credential.Api

This document defines the conventions and best practices for building a clean, maintainable, and production-ready RESTful API.

---

## 🔧 1. Resource-Oriented Endpoints

Use **plural nouns** for resources. Avoid verbs in route names.

| Action        | HTTP Method | Endpoint          |
| ------------- | ----------- | ----------------- |
| Get all users | GET         | `/api/users`      |
| Get one user  | GET         | `/api/users/{id}` |
| Create user   | POST        | `/api/users`      |
| Update user   | PUT         | `/api/users/{id}` |
| Patch user    | PATCH       | `/api/users/{id}` |
| Delete user   | DELETE      | `/api/users/{id}` |

---

## 🧾 2. Request & Response Models (DTOs)

Avoid exposing domain or EF Core entities. Use dedicated DTOs in the Application layer.

**Example:**

```csharp
public class CreateUserRequest
{
    public string UserName { get; set; }
    public string DisplayName { get; set; }
}

public class UserResponse
{
    public long Id { get; set; }
    public string UserName { get; set; }
    public string DisplayName { get; set; }
}
```

---

## ✅ 3. HTTP Status Codes

Always return the appropriate status code:

| Code | Meaning                    |
| ---- | -------------------------- |
| 200  | OK                         |
| 201  | Created                    |
| 204  | No Content (for DELETE)    |
| 400  | Bad Request (validation)   |
| 401  | Unauthorized               |
| 403  | Forbidden                  |
| 404  | Not Found                  |
| 409  | Conflict (duplicate, etc.) |
| 500  | Internal Server Error      |

---

## 🧠 4. CQRS with MediatR

Use `Command` classes for write operations and `Query` classes for reads.

Example:

- `CreateUserCommand`, `CreateUserHandler`
- `GetUserByIdQuery`, `GetUserByIdHandler`

---

## 🔍 5. Fluent Validation

Use `FluentValidation` to validate requests. Invalid requests return:

```json
{
  "errors": [
    {
      "field": "UserName",
      "message": "UserName is required."
    }
  ]
}
```

---

## 🔒 6. Consistent Response Format

Wrap all responses in a standard envelope:

```json
{
  "success": true,
  "data": {
    "id": 123,
    "userName": "tona",
    "displayName": "Tona Sama"
  }
}
```

---

## 📄 7. Pagination, Filtering, Searching

Use query parameters:

```http
GET /api/users?page=2&pageSize=10&search=tona
```

Paginated result:

```json
{
  "total": 100,
  "page": 2,
  "pageSize": 10,
  "data": [ ...users... ]
}
```

---

## 🧹 8. API Versioning (Optional)

Use versioned routes:

```
/api/v1/users
```

Use a custom middleware or versioning library as needed.

---

## 🧱 9. Error Handling

Implement centralized exception handling and return standard error payloads.

Example structure:

```json
{
  "success": false,
  "message": "Validation failed",
  "errors": [
    {
      "field": "UserName",
      "message": "UserName is required."
    }
  ]
}
```

---

## 🗂️ 10. Suggested Folder Structure

```
Csnp.Credential.Api/
├── Controllers/
│   └── UsersController.cs
├── Filters/
├── Middleware/
├── Extensions/
└── Program.cs
```

---

## 🚀 11. Security (Basic)

- Use HTTPS.
- Add authentication (JWT, OAuth2, etc.).
- Validate user roles/claims (e.g., `[Authorize(Roles = "Admin")]`).
- Sanitize input to avoid injection attacks.

---

## 📚 12. Documentation

Integrate Swagger (`Swashbuckle`) to document all endpoints.

```bash
dotnet add package Swashbuckle.AspNetCore
```

---

## ✨ Summary

| Area             | Practice                                 |
| ---------------- | ---------------------------------------- |
| Routing          | Resource-based, plural nouns             |
| Methods          | Correct HTTP verbs                       |
| DTOs             | Decoupled from domain/EF Core            |
| Errors           | Consistent structured responses          |
| Validation       | FluentValidation + 400 on failure        |
| Logic Separation | CQRS + MediatR                           |
| Security         | HTTPS + Authorization + Input validation |
| Documentation    | Swagger                                  |

---

*This file should be reviewed and evolved as your architecture grows.*

