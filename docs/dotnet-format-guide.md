# Using `dotnet-format` to Format .NET Code

This guide explains how to install and use the `dotnet-format` tool to apply consistent code style rules across your .NET projects.

## Prerequisites

- .NET SDK 6.0 or later installed

## Installation

Install `dotnet-format` as a global tool:

```bash
dotnet tool install -g dotnet-format
```

After installation, you can use the `dotnet format` command from any directory.

## Usage

### Format the Entire Solution

To format all projects in a solution file (e.g., `Csnp.sln`):

```bash
dotnet format Csnp.sln
```

### Format with Specific Severity

Apply formatting only to issues with `warn` severity or higher:

```bash
dotnet format --severity warn
```

This avoids formatting changes for informational (`info`) or hidden diagnostics.

## Notes

- `dotnet-format` respects your `.editorconfig` settings.
- Ideal for use in CI pipelines to enforce style and formatting rules.
- To check for formatting issues without applying changes:

```bash
dotnet format --verify-no-changes
```

## Example CI Command

```bash
dotnet format --verify-no-changes --severity warn Csnp.sln
```

This command will fail the build if formatting issues of severity `warn` or higher are detected.

## Additional CI Maintenance Steps (Optional)

Use the following commands when needed to ensure a clean and consistent environment:

```bash
dotnet clean
dotnet build
dotnet format --verbosity detailed
```

---

📚 **Official documentation:**\
[https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-format](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-format)
