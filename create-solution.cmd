@echo off
setlocal enabledelayedexpansion

:: Solution name
set SOLUTION_NAME=Csnp
dotnet new sln -n %SOLUTION_NAME% --force

:: Directories
set ROOT_DIR=%cd%
set SRC_DIR=%ROOT_DIR%\src
set TEST_DIR=%ROOT_DIR%\tests
set SHARED_DIR=%ROOT_DIR%\shared
set MIGRATIONS_DIR=%ROOT_DIR%\migrations

echo Creating CSNP DDD Production Solution Structure...
echo.

:: SeedWork - Foundation layers
echo Creating SeedWork foundation layers
call :create_classlib %SHARED_DIR%\Csnp.SeedWork
call :create_subfolder %SHARED_DIR%\Csnp.SeedWork\Domain
call :create_subfolder %SHARED_DIR%\Csnp.SeedWork\Domain\ValueObjects
call :create_subfolder %SHARED_DIR%\Csnp.SeedWork\Domain\Events
call :create_subfolder %SHARED_DIR%\Csnp.SeedWork\Application

:: SharedKernel - Shared domain logic
echo Creating SharedKernel shared domain logic layers...
call :create_classlib %SHARED_DIR%\Csnp.SharedKernel.Domain
call :create_subfolder %SHARED_DIR%\Csnp.SharedKernel.Domain\Events
call :create_subfolder %SHARED_DIR%\Csnp.SharedKernel.Domain\Exceptions
call :create_subfolder %SHARED_DIR%\Csnp.SharedKernel.Domain\Rules

call :create_classlib %SHARED_DIR%\Csnp.SharedKernel.Application
call :create_subfolder %SHARED_DIR%\Csnp.SharedKernel.Application\Behaviors
call :create_subfolder %SHARED_DIR%\Csnp.SharedKernel.Application\Commands
call :create_subfolder %SHARED_DIR%\Csnp.SharedKernel.Application\Queries
call :create_subfolder %SHARED_DIR%\Csnp.SharedKernel.Application\Events

call :create_classlib %SHARED_DIR%\Csnp.SharedKernel.Infrastructure
call :create_subfolder %SHARED_DIR%\Csnp.SharedKernel.Infrastructure\Events
call :create_subfolder %SHARED_DIR%\Csnp.SharedKernel.Infrastructure\Messaging

:: Common - Cross-cutting utilities
echo Creating Common cross-cutting layer...
call :create_classlib %SHARED_DIR%\Csnp.Security.Infrastructure
call :create_subfolder %SHARED_DIR%\Csnp.Security.Infrastructure\Security

:: EventBus - Event-driven communication
echo Creating EventBus layer...
call :create_classlib %SHARED_DIR%\Csnp.EventBus
call :create_subfolder %SHARED_DIR%\Csnp.EventBus\Abstractions
call :create_subfolder %SHARED_DIR%\Csnp.EventBus\InMemory
call :create_subfolder %SHARED_DIR%\Csnp.EventBus\RabbitMQ

:: Credential Bounded Context
echo Creating Credential bounded context...
call :create_webapi %SRC_DIR%\Credential\Csnp.Credential.Api

call :create_classlib %SRC_DIR%\Credential\Csnp.Credential.Application
call :create_subfolder %SRC_DIR%\Credential\Csnp.Credential.Application\Commands
call :create_subfolder %SRC_DIR%\Credential\Csnp.Credential.Application\Queries
call :create_subfolder %SRC_DIR%\Credential\Csnp.Credential.Application\Events
call :create_subfolder %SRC_DIR%\Credential\Csnp.Credential.Application\Behaviors

call :create_classlib %SRC_DIR%\Credential\Csnp.Credential.Domain
call :create_subfolder %SRC_DIR%\Credential\Csnp.Credential.Domain\Aggregates
call :create_subfolder %SRC_DIR%\Credential\Csnp.Credential.Domain\Events
call :create_subfolder %SRC_DIR%\Credential\Csnp.Credential.Domain\Specifications

call :create_classlib %SRC_DIR%\Credential\Csnp.Credential.Infrastructure
call :create_subfolder %SRC_DIR%\Credential\Csnp.Credential.Infrastructure\Persistence
call :create_subfolder %SRC_DIR%\Credential\Csnp.Credential.Infrastructure\External
call :create_subfolder %SRC_DIR%\Credential\Csnp.Credential.Infrastructure\Services
call :create_subfolder %SRC_DIR%\Credential\Csnp.Credential.Infrastructure\Events

:: Notification Bounded Context
echo Creating Notification bounded context...
call :create_webapi %SRC_DIR%\Notification\Csnp.Notification.Api

call :create_classlib %SRC_DIR%\Notification\Csnp.Notification.Application
call :create_subfolder %SRC_DIR%\Notification\Csnp.Notification.Application\Commands
call :create_subfolder %SRC_DIR%\Notification\Csnp.Notification.Application\Queries
call :create_subfolder %SRC_DIR%\Notification\Csnp.Notification.Application\Events
call :create_subfolder %SRC_DIR%\Notification\Csnp.Notification.Application\Behaviors

call :create_classlib %SRC_DIR%\Notification\Csnp.Notification.Domain
call :create_subfolder %SRC_DIR%\Notification\Csnp.Notification.Domain\Aggregates
call :create_subfolder %SRC_DIR%\Notification\Csnp.Notification.Domain\Events
call :create_subfolder %SRC_DIR%\Notification\Csnp.Notification.Domain\Specifications

call :create_classlib %SRC_DIR%\Notification\Csnp.Notification.Infrastructure
call :create_subfolder %SRC_DIR%\Notification\Csnp.Notification.Infrastructure\Persistence
call :create_subfolder %SRC_DIR%\Notification\Csnp.Notification.Infrastructure\External
call :create_subfolder %SRC_DIR%\Notification\Csnp.Notification.Infrastructure\Services
call :create_subfolder %SRC_DIR%\Notification\Csnp.Notification.Infrastructure\Events

:: Presentation
echo Creating Presentation layer...
call :create_mvc %SRC_DIR%\Presentation\Csnp.Presentation.Web

:: Migrations
echo Creating Migration projects...
call :create_classlib %MIGRATIONS_DIR%\Csnp.Migrations.Credential
call :create_subfolder %MIGRATIONS_DIR%\Csnp.Migrations.Credential\Configurations
call :create_subfolder %MIGRATIONS_DIR%\Csnp.Migrations.Credential\Seeds

call :create_classlib %MIGRATIONS_DIR%\Csnp.Migrations.Notification
call :create_subfolder %MIGRATIONS_DIR%\Csnp.Migrations.Notification\Configurations
call :create_subfolder %MIGRATIONS_DIR%\Csnp.Migrations.Notification\Seeds

:: Tests
echo Creating test projects...
call :create_test %TEST_DIR%\Csnp.Credential.Tests.Unit
call :create_test %TEST_DIR%\Csnp.Credential.Tests.Integration
call :create_test %TEST_DIR%\Csnp.Credential.Tests.Architecture
call :create_test %TEST_DIR%\Csnp.Notification.Tests.Unit
call :create_test %TEST_DIR%\Csnp.Notification.Tests.Integration
call :create_test %TEST_DIR%\Csnp.Notification.Tests.Architecture

echo Adding all projects to solution...
:: Add all projects to solution
for /R %%f in (*.csproj) do (
    dotnet sln %SOLUTION_NAME%.sln add "%%f"
)

echo Setting up project references...

:: SharedKernel layer dependencies
dotnet add %SHARED_DIR%\Csnp.SharedKernel.Domain\Csnp.SharedKernel.Domain.csproj reference ^
    %SHARED_DIR%\Csnp.SeedWork\Csnp.SeedWork.csproj

dotnet add %SHARED_DIR%\Csnp.SharedKernel.Application\Csnp.SharedKernel.Application.csproj reference ^
    %SHARED_DIR%\Csnp.SharedKernel.Domain\Csnp.SharedKernel.Domain.csproj

dotnet add %SHARED_DIR%\Csnp.SharedKernel.Infrastructure\Csnp.SharedKernel.Infrastructure.csproj reference ^
    %SHARED_DIR%\Csnp.SharedKernel.Application\Csnp.SharedKernel.Application.csproj

:: Credential bounded context references
dotnet add %SRC_DIR%\Credential\Csnp.Credential.Api\Csnp.Credential.Api.csproj reference ^
    %SRC_DIR%\Credential\Csnp.Credential.Infrastructure\Csnp.Credential.Infrastructure.csproj

dotnet add %SRC_DIR%\Credential\Csnp.Credential.Application\Csnp.Credential.Application.csproj reference ^
    %SRC_DIR%\Credential\Csnp.Credential.Domain\Csnp.Credential.Domain.csproj ^
    %SHARED_DIR%\Csnp.SharedKernel.Application\Csnp.SharedKernel.Application.csproj ^
    %SHARED_DIR%\Csnp.EventBus\Csnp.EventBus.csproj

dotnet add %SRC_DIR%\Credential\Csnp.Credential.Domain\Csnp.Credential.Domain.csproj reference ^
    %SHARED_DIR%\Csnp.SharedKernel.Domain\Csnp.SharedKernel.Domain.csproj

dotnet add %SRC_DIR%\Credential\Csnp.Credential.Infrastructure\Csnp.Credential.Infrastructure.csproj reference ^
    %SRC_DIR%\Credential\Csnp.Credential.Application\Csnp.Credential.Application.csproj

:: Notification bounded context references
dotnet add %SRC_DIR%\Notification\Csnp.Notification.Api\Csnp.Notification.Api.csproj reference ^
    %SRC_DIR%\Notification\Csnp.Notification.Infrastructure\Csnp.Notification.Infrastructure.csproj

dotnet add %SRC_DIR%\Notification\Csnp.Notification.Application\Csnp.Notification.Application.csproj reference ^
    %SRC_DIR%\Notification\Csnp.Notification.Domain\Csnp.Notification.Domain.csproj ^
    %SHARED_DIR%\Csnp.SharedKernel.Application\Csnp.SharedKernel.Application.csproj ^
    %SHARED_DIR%\Csnp.EventBus\Csnp.EventBus.csproj

dotnet add %SRC_DIR%\Notification\Csnp.Notification.Domain\Csnp.Notification.Domain.csproj reference ^
    %SHARED_DIR%\Csnp.SharedKernel.Domain\Csnp.SharedKernel.Domain.csproj

dotnet add %SRC_DIR%\Notification\Csnp.Notification.Infrastructure\Csnp.Notification.Infrastructure.csproj reference ^
    %SRC_DIR%\Notification\Csnp.Notification.Application\Csnp.Notification.Application.csproj

:: Presentation references
dotnet add %SRC_DIR%\Presentation\Csnp.Presentation.Web\Csnp.Presentation.Web.csproj reference ^
    %SHARED_DIR%\Csnp.Security.Infrastructure\Csnp.Security.Infrastructure.csproj

:: Migration projects references
dotnet add %MIGRATIONS_DIR%\Csnp.Migrations.Credential\Csnp.Migrations.Credential.csproj reference ^
    %SRC_DIR%\Credential\Csnp.Credential.Infrastructure\Csnp.Credential.Infrastructure.csproj

dotnet add %MIGRATIONS_DIR%\Csnp.Migrations.Notification\Csnp.Migrations.Notification.csproj reference ^
    %SRC_DIR%\Notification\Csnp.Notification.Infrastructure\Csnp.Notification.Infrastructure.csproj

:: Test project references
dotnet add %TEST_DIR%\Csnp.Credential.Tests.Unit\Csnp.Credential.Tests.Unit.csproj reference ^
    %SRC_DIR%\Credential\Csnp.Credential.Application\Csnp.Credential.Application.csproj

dotnet add %TEST_DIR%\Csnp.Credential.Tests.Integration\Csnp.Credential.Tests.Integration.csproj reference ^
    %SRC_DIR%\Credential\Csnp.Credential.Api\Csnp.Credential.Api.csproj

dotnet add %TEST_DIR%\Csnp.Credential.Tests.Architecture\Csnp.Credential.Tests.Architecture.csproj reference ^
    %SRC_DIR%\Credential\Csnp.Credential.Infrastructure\Csnp.Credential.Infrastructure.csproj

dotnet add %TEST_DIR%\Csnp.Notification.Tests.Unit\Csnp.Notification.Tests.Unit.csproj reference ^
    %SRC_DIR%\Notification\Csnp.Notification.Application\Csnp.Notification.Application.csproj

dotnet add %TEST_DIR%\Csnp.Notification.Tests.Integration\Csnp.Notification.Tests.Integration.csproj reference ^
    %SRC_DIR%\Notification\Csnp.Notification.Api\Csnp.Notification.Api.csproj

dotnet add %TEST_DIR%\Csnp.Notification.Tests.Architecture\Csnp.Notification.Tests.Architecture.csproj reference ^
    %SRC_DIR%\Notification\Csnp.Notification.Infrastructure\Csnp.Notification.Infrastructure.csproj

goto :eof

:: Helper Functions
:create_classlib
if not exist "%~dp1" mkdir "%~dp1" 2>nul
dotnet new classlib -n %~nx1 -o %1 --force > nul 2>&1
goto :eof

:create_webapi
if not exist "%~dp1" mkdir "%~dp1" 2>nul
dotnet new webapi -n %~nx1 -o %1 --force > nul 2>&1 --use-controllers --use-program-main
goto :eof

:create_mvc
if not exist "%~dp1" mkdir "%~dp1" 2>nul
dotnet new mvc -n %~nx1 -o %1 --force > nul 2>&1
goto :eof

:create_test
if not exist "%~dp1" mkdir "%~dp1" 2>nul
dotnet new xunit -n %~nx1 -o %1 --force > nul 2>&1
goto :eof

:create_subfolder
if not exist "%1" mkdir "%1" 2>nul
echo. > "%1\.gitkeep"
goto :eof
