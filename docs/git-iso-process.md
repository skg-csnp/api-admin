# GIT ISO PROCESS FOR TEAM

**Document:** Git ISO Process for Team  
**Created:** 09/07/2025  
**Author:** ToanNV  
**Version:** 1.0  

---

## 1. Role-based Permissions

### 👨‍💻 Developer (Member)
**Can do:**
- Create and work on working branches (feature/, bugfix/)
- Commit and push code to working branches
- Create PR/MR to merge into `dev`
- Review other members' code
- Sync and rebase from `dev` branch

**Cannot do:**
- Merge directly into environment branches
- Create hotfix branches (unless assigned)
- Merge into `uat`, `stg`, `pro`
- Delete environment branches

### 👨‍💻 Senior Developer
**Can do (includes Developer permissions):**
- Merge PR/MR into `dev` and `uat`
- Create and handle hotfix branches
- Lead code review for complex features
- Approve deployment to UAT environment

**Cannot do:**
- Merge directly into `stg` and `pro`
- Create release tags
- Approve production deployment

### 👨‍💻 Tech Lead
**Can do (includes all above permissions):**
- Merge into all environment branches
- Create and manage release tags
- Approve deployment to Staging and Production
- Manage branching strategy and process
- Force push in emergency cases (with documentation)

## 2. Branch Structure

### Environment Branches
- **`dev`**: Development environment - internal development and testing
- **`uat`**: User Acceptance Testing environment - testing with users
- **`stg`**: Staging environment - pre-production testing
- **`pro`**: Production environment - live system

### Working Branches
- **`feature/`**: New feature development
- **`hotfix/`**: Emergency fixes on production
- **`bugfix/`**: Bug fixes on environments
- **`refactor/`**: Code refactoring

## 2. Branch Naming Convention

### Standard format:
```
<type>/<ticket-id>-<brief-description>-<member-name>
```

### Examples:
- `feature/CSNP-123-user-authentication-ToanNV`
- `bugfix/CSNP-456-fix-login-error-MinhL`
- `hotfix/CSNP-789-critical-payment-bug-AnhPT`
- `refactor/CSNP-101-optimize-database-HungNQ`

### Rules:
- Use lowercase and hyphens for type and description
- Include ticket ID from project management system
- Brief description of purpose
- **Member name**: Capitalize first letters (e.g.: ToanNV, MinhL)
- Member name format: FirstName initial + LastName initial (e.g.: Nguyen Van Toan → ToanNV, Le Minh → MinhL)

## 3. Commit Message Convention

### Conventional Commits format:
```
<type>(<scope>): <ticket-id> <subject>

<body>

<footer>
```

### Commit types:
- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code format changes (no logic impact)
- **refactor**: Code refactoring
- **test**: Add or fix tests
- **chore**: Update build system, dependencies

### Example:
```
feat(auth): add JWT token validation

- Implement JWT middleware for protected routes
- Add token expiration handling
- Update user authentication flow

Closes #123
```

## 4. Git Clone and Directory Naming Rules

### Directory naming format:
```
<repository-name>_<branch-name>
```

### Repository clone examples:
```bash
# Clone specific branch and name directory
git clone --branch document https://github.com/zngtfy/Interview.git Interview_document

# Clone other branches
git clone --branch dev https://github.com/company/project.git Project_dev
git clone --branch feature/login-ToanNV https://github.com/company/project.git Project_feature-login-ToanNV
git clone --branch uat https://github.com/company/project.git Project_uat
```

### Directory naming rules:
- **Repository name**: Keep original name
- **Branch name**: Replace `/` with `-` to avoid filesystem errors
- **Separator**: Use `_` between repo name and branch name
- **Case**: Keep original case of repository and branch name

### Special cases:
```bash
# Branch with slashes
git clone --branch feature/user-auth-ToanNV https://github.com/company/app.git App_feature-user-auth-ToanNV

# Branch with special characters
git clone --branch hotfix/fix-payment-issue-MinhL https://github.com/company/api.git Api_hotfix-fix-payment-issue-MinhL

# Environment branches
git clone --branch pro https://github.com/company/website.git Website_pro
```

### Benefits:
- **Easy identification**: Know immediately which branch you're working on
- **Avoid conflicts**: Multiple branches of same project don't have duplicate directory names
- **Organization**: Directories are sorted alphabetically
- **Team consistency**: Entire team uses consistent naming

## 5. Standard Workflow

### A. Starting work
```bash
# 1. Update dev branch
git checkout dev
git pull origin dev

# 2. Create feature branch with member name
git checkout -b feature/CSNP-123-user-profile-ToanNV

# 3. Work and commit
git add .
git commit -m "feat(profile): CSNP-123 add user profile page"
```

### B. During development
```bash
# Regularly sync with dev
git checkout dev
git pull origin dev
git checkout feature/CSNP-123-user-profile-ToanNV
git rebase dev
```

### C. Completing feature
```bash
# 1. Push branch to remote
git push origin feature/CSNP-123-user-profile-ToanNV

# 2. Create Pull Request (PR) / Merge Request (MR) into dev
# 3. Code review
# 4. Merge into dev
```

### D. Workflow between environments
```bash
# dev → uat (after dev testing is complete)
git checkout uat
git pull origin uat
git merge dev
git push origin uat

# uat → stg (after UAT passes)
git checkout stg
git pull origin stg
git merge uat
git push origin stg

# stg → pro (after staging test passes)
git checkout pro
git pull origin pro
git merge stg
git push origin pro
```

## 5. Role-based Workflow

### 👨‍💻 Developer Workflow
**Daily:**
```bash
# 1. Update dev branch
git checkout dev
git pull origin dev

# 2. Create feature branch
git checkout -b feature/CSNP-123-user-profile-ToanNV

# 3. Work and commit regularly
git add .
git commit -m "feat(profile): CSNP-123 add user profile form"

# 4. Push and create PR
git push origin feature/CSNP-123-user-profile-ToanNV
# Create PR/MR into dev branch
```

**Responsibilities:**
- Write unit tests for own code
- Self-review before creating PR
- Respond to review comments within 24h
- Don't merge code that hasn't passed CI/CD

### 👨‍💻 Senior Developer Workflow
**Daily (includes Developer tasks):**
```bash
# Review and merge PR into dev
git checkout dev
git pull origin dev
# Review PRs from developers
# Merge approved PRs

# Deploy to UAT (weekly)
git checkout uat
git pull origin uat
git merge dev
git push origin uat
```

**Responsibilities:**
- Review code quality and architecture
- Mentor junior developers
- Manage UAT deployment
- Handle hotfixes for dev and uat environments

### 👨‍💻 Tech Lead Workflow
**Daily (includes all above tasks):**
```bash
# Manage staging deployment
git checkout stg
git pull origin stg
git merge uat
git push origin stg

# Production deployment (monthly)
git checkout pro
git pull origin pro
git merge stg
git push origin pro
git tag -a v1.2.0 -m "Release version 1.2.0"
git push origin v1.2.0
```

**Responsibilities:**
- Approve architecture decisions
- Manage release process
- Handle production issues
- Maintain branching strategy

## 6. Code Review Process

### 👨‍💻 Developer Review Requirements:
- **Reviewed by**: 1 Senior Developer or Tech Lead
- **Checklist**: Basic functionality, code style, tests
- **Timeline**: PR must be reviewed within 24h
- **Self-review**: Required before assigning reviewer

### 👨‍💻 Senior Developer Review Requirements:
- **Reviewed by**: 1 Tech Lead or peer Senior
- **Checklist**: Architecture, performance, scalability
- **Timeline**: PR must be reviewed within 48h
- **Additional**: Review impact on existing system

### 👨‍💻 Tech Lead Review Requirements:
- **Reviewed by**: Peer Tech Lead or Architect (if available)
- **Checklist**: System design, security, performance
- **Timeline**: PR must be reviewed within 72h
- **Additional**: Long-term maintainability

### PR/MR template by role:
```markdown
## Description
Brief description of changes

## PR Creator Role: [Developer/Senior/Tech Lead]
Implemented by: [Full Name]

## Reviewer Assignment:
- [ ] Developer → Senior/Tech Lead review
- [ ] Senior → Tech Lead review  
- [ ] Tech Lead → Architect review

## Target Environment
- [ ] dev (Developer can create)
- [ ] uat (Senior+ create)
- [ ] stg (Tech Lead create)
- [ ] pro (Tech Lead create)

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update
- [ ] Hotfix

## Member: [MemberName]

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] Tested on target environment
```

## 7. Branching Strategy

### Environment Flow Strategy:
```
pro ← stg ← uat ← dev ← feature/xxx-MemberName
                     ↖ hotfix/xxx-MemberName
                     ↖ bugfix/xxx-MemberName
```

### Merge permissions:
- **dev**: Developer+ (after code review)
- **uat**: Senior Developer+
- **stg**: Tech Lead only
- **pro**: Tech Lead only

### Deployment workflow:
1. **Development**: Developer creates feature → Senior reviews → merge into `dev`
2. **User Testing**: Senior deploys from `dev` → `uat` for user testing
3. **Staging**: Tech Lead deploys from `uat` → `stg` for pre-production testing
4. **Production**: Tech Lead deploys from `stg` → `pro` to production

### Hotfix Process by role:
```bash
# 👨‍💻 Developer: Only fix on dev
git checkout dev
git checkout -b hotfix/CSNP-999-fix-validation-ToanNV

# 👨‍💻 Senior Developer: Fix on dev and uat
git checkout dev  # or uat
git checkout -b hotfix/CSNP-999-critical-fix-MinhL

# 👨‍💻 Tech Lead: Fix on any environment
git checkout pro  # or stg/uat/dev
git checkout -b hotfix/CSNP-999-security-fix-AnhPT

# Merge back to all environments (Tech Lead does this)
git checkout pro
git merge hotfix/CSNP-999-security-fix-AnhPT

git checkout stg
git merge pro

git checkout uat
git merge stg

git checkout dev
git merge uat
```

## 8. Release Process

### Semantic Versioning:
- **MAJOR**: Incompatible changes (Tech Lead decides)
- **MINOR**: New features (Senior+ proposes)
- **PATCH**: Bug fixes (Developer+ can propose)

### Release process by role:

#### 👨‍💻 Developer:
```bash
# Can only propose patch version
# Create ticket to propose release
# No permission to create tags
```

#### 👨‍💻 Senior Developer:
```bash
# Can propose minor/patch version
# Prepare release notes
# Review release impact
```

#### 👨‍💻 Tech Lead:
```bash
# Create tag from pro branch
git checkout pro
git tag -a v1.2.0 -m "Release version 1.2.0"
git push origin v1.2.0

# Update changelog
git commit -m "chore(release): update changelog for v1.2.0"

# Ensure sync back to dev
git checkout dev
git merge pro
```

### Environment Deployment Schedule:
- **dev**: Continuous deployment (Developer merge)
- **uat**: Weekly deployment (Senior Developer - Mondays)
- **stg**: Bi-weekly deployment (Tech Lead - every 2 weeks)
- **pro**: Monthly deployment (Tech Lead - end of month)

### Release Approval:
- **Patch**: Senior Developer approval
- **Minor**: Tech Lead approval  
- **Major**: Tech Lead + Product Owner approval

## 9. Security Rules

### Protected Branches:
- `pro`, `stg`, `uat`, `dev` must be protected
- No force push on environment branches
- Require PR review before merging into environment branches

### Branch Permissions:
- **pro**: Only Tech Lead merge and has admin rights
- **stg**: Tech Lead merge, Senior Developer has read access
- **uat**: Senior Developer and Tech Lead merge
- **dev**: Developer+ can merge after review

### Deployment Permissions:
- **Development**: Developer can trigger
- **UAT**: Senior Developer+ can trigger
- **Staging**: Tech Lead can trigger
- **Production**: Tech Lead + approval process

### Rollback Permissions:
- **dev/uat**: Senior Developer can rollback
- **stg/pro**: Only Tech Lead can rollback

### Sensitive Data:
- No committing passwords, API keys
- Use `.gitignore` for config files
- Use environment variables for each environment
- Separate config files for each environment
- Secret management only Tech Lead and Senior have access

## 9. Tools and Automation

### Pre-commit Hooks:
```bash
# Install pre-commit
npm install --save-dev husky lint-staged

# package.json
{
  "husky": {
    "hooks": {
      "pre-commit": "lint-staged"
    }
  },
  "lint-staged": {
    "*.js": ["eslint --fix", "git add"]
  }
}
```

### CI/CD Integration:
- Automated testing on every PR
- Build and deploy automation
- Code quality checks (SonarQube, CodeClimate)

## 10. Best Practices

### DO:
- Commit small and frequently
- Write meaningful commit messages
- Rebase before merge (for clean history)
- Use .gitignore effectively
- Backup important branches

### DON'T:
- Commit untested code
- Force push to shared branches
- Commit large binary files
- Use `git add .` without checking
- Ignore conflict resolution

## 11. Troubleshooting

### Rollback commits:
```bash
# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo commit and delete changes
git reset --hard HEAD~1

# Revert commit (create new commit)
git revert <commit-hash>
```

### Resolve conflicts:
```bash
# During merge/rebase
git status
# Fix conflicts in files
git add <resolved-files>
git rebase --continue
```

## 13. Monitoring and Metrics

### Environment monitoring:
- **dev**: Commit frequency, build success rate (Developer monitors)
- **uat**: Bug detection rate, user feedback (Senior Developer monitors)
- **stg**: Performance metrics, load testing results (Tech Lead monitors)
- **pro**: Uptime, error rate, performance (Tech Lead monitors)

### Role-based monitoring:

#### 👨‍💻 Developer Metrics:
- Commit frequency per day
- PR creation rate
- Code review response time
- Test coverage contribution
- Bug fix time

#### 👨‍💻 Senior Developer Metrics:
- Code review quality score
- Mentoring effectiveness
- UAT deployment success rate
- Hotfix resolution time
- Junior developer progress

#### 👨‍💻 Tech Lead Metrics:
- System stability across environments
- Release success rate
- Team velocity
- Architecture decision impact
- Production incident resolution

### Reporting:
- **Daily**: Developer commit activity
- **Weekly**: Senior Developer environment health
- **Monthly**: Tech Lead overall system metrics
- **Quarterly**: Team performance and growth metrics

### Tools:
- GitLab/GitHub Analytics
- SonarQube for code quality
- JIRA integration for ticket tracking
- Environment monitoring tools (New Relic, DataDog)
- Performance dashboards per environment