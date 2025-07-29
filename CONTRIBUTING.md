# Contributing to CSNP Platform

We welcome contributions! Please follow these guidelines to ensure a consistent and clean workflow across the project.

---

## 🛠️ Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/skg-csnp/api-web.git
   cd api-web
   ```

2. Create a new branch for your feature or fix:
   ```bash
   git checkout -b feat/my-feature
   ```

---

## 💡 Guidelines

- Use **English** in code, comments, and commit messages.
- Follow [Conventional Commits](https://www.conventionalcommits.org/) style:
  - `feat:`     → Introduce a new feature
  - `fix:`      → Fix a bug or regression
  - `docs:`     → Documentation only changes (e.g., README, Markdown)
  - `refactor:` → Code changes that neither fix a bug nor add a feature
  - `test:`     → Adding or updating tests
  - `chore:`    → Maintenance changes (e.g., dependencies, configs)
  - `style:`    → Code style changes (formatting, naming, spacing)
  - `perf:`     → Performance improvements
  - `ci:`       → CI/CD-related changes (Jenkins, GitHub Actions, etc.)
- Group related changes in a single commit/PR.
- Reflect major changes in `CHANGELOG.md` under the correct section.

---

## ✅ Code Style & Formatting

- Follow the rules defined in `.editorconfig`.
- Format code before committing:
  ```bash
  dotnet format
  ```
- Organize usings and structure code using Visual Studio or Rider auto-format.

---

## 🧪 Testing

- Add unit/integration tests for all logic-heavy changes.
- Run all tests before pushing:
  ```bash
  dotnet test
  ```
- Test should be placed under the corresponding module's `Tests` project.

---

## 🔁 Pull Requests

- Open PRs against the `dev` branch unless specified otherwise.
- Provide a clear description of your changes.
- Link to related issues, if applicable.
- Keep PRs focused and small (prefer multiple PRs over one large one).

---

## 📦 Release & CI/CD

- CI runs include build, test, and format check.
- Production deployments are promoted through `dev → uat → stg → pro` branches.
- Harbor & ArgoCD handle deployment automation.

---

Thanks for contributing! 💙

