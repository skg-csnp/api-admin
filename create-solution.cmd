@echo off
setlocal enabledelayedexpansion

:: Solution name
set SOLUTION_NAME=csnp

echo Creating CSNP NestJS Production Solution Structure...
echo.

:: Directories
set ROOT_DIR=%cd%
set SRC_DIR=%ROOT_DIR%\src
set TEST_DIR=%ROOT_DIR%\tests
set SHARED_DIR=%ROOT_DIR%\shared
set MIGRATIONS_DIR=%ROOT_DIR%\migrations

:: Create main directories first
if not exist "%SRC_DIR%" mkdir "%SRC_DIR%"
if not exist "%TEST_DIR%" mkdir "%TEST_DIR%"
if not exist "%SHARED_DIR%" mkdir "%SHARED_DIR%"
if not exist "%MIGRATIONS_DIR%" mkdir "%MIGRATIONS_DIR%"
if not exist "%ROOT_DIR%\prisma" mkdir "%ROOT_DIR%\prisma"

:: Create root package.json for monorepo
call :create_root_package_json

:: Create pnpm workspace configuration
call :create_pnpm_workspace

:: SeedWork - Foundation layers
echo Creating SeedWork foundation layers...
call :create_lib "%SHARED_DIR%\seedwork-domain"
call :create_subfolder "%SHARED_DIR%\seedwork-domain\events"
call :create_subfolder "%SHARED_DIR%\seedwork-domain\exceptions"
call :create_subfolder "%SHARED_DIR%\seedwork-domain\rules"

call :create_lib "%SHARED_DIR%\seedwork-application"
call :create_subfolder "%SHARED_DIR%\seedwork-application\behaviors"
call :create_subfolder "%SHARED_DIR%\seedwork-application\commands"
call :create_subfolder "%SHARED_DIR%\seedwork-application\queries"
call :create_subfolder "%SHARED_DIR%\seedwork-application\events"

call :create_lib "%SHARED_DIR%\seedwork-infrastructure"
call :create_subfolder "%SHARED_DIR%\seedwork-infrastructure\events"
call :create_subfolder "%SHARED_DIR%\seedwork-infrastructure\messaging"

:: SharedKernel - Shared domain logic
echo Creating SharedKernel...
call :create_lib "%SHARED_DIR%\shared-kernel"
call :create_subfolder "%SHARED_DIR%\shared-kernel\domain"
call :create_subfolder "%SHARED_DIR%\shared-kernel\domain\value-objects"
call :create_subfolder "%SHARED_DIR%\shared-kernel\domain\events"
call :create_subfolder "%SHARED_DIR%\shared-kernel\application"

:: Common - Cross-cutting utilities
echo Creating Common cross-cutting layer...
call :create_lib "%SHARED_DIR%\common"
call :create_subfolder "%SHARED_DIR%\common\services"
call :create_subfolder "%SHARED_DIR%\common\abstractions"
call :create_subfolder "%SHARED_DIR%\common\utils"
call :create_subfolder "%SHARED_DIR%\common\security"
call :create_subfolder "%SHARED_DIR%\common\logging"
call :create_subfolder "%SHARED_DIR%\common\caching"
call :create_subfolder "%SHARED_DIR%\common\monitoring"
call :create_subfolder "%SHARED_DIR%\common\configuration"

:: EventBus - Event-driven communication
echo Creating EventBus layer...
call :create_lib "%SHARED_DIR%\event-bus"
call :create_subfolder "%SHARED_DIR%\event-bus\abstractions"
call :create_subfolder "%SHARED_DIR%\event-bus\in-memory"
call :create_subfolder "%SHARED_DIR%\event-bus\rabbitmq"

:: Credential Bounded Context
echo Creating Credential bounded context...
call :create_app "%SRC_DIR%\credential\credential-api"

call :create_lib "%SRC_DIR%\credential\credential-application"
call :create_subfolder "%SRC_DIR%\credential\credential-application\commands"
call :create_subfolder "%SRC_DIR%\credential\credential-application\queries"
call :create_subfolder "%SRC_DIR%\credential\credential-application\events"
call :create_subfolder "%SRC_DIR%\credential\credential-application\behaviors"

call :create_lib "%SRC_DIR%\credential\credential-domain"
call :create_subfolder "%SRC_DIR%\credential\credential-domain\aggregates"
call :create_subfolder "%SRC_DIR%\credential\credential-domain\events"
call :create_subfolder "%SRC_DIR%\credential\credential-domain\specifications"

call :create_lib "%SRC_DIR%\credential\credential-infrastructure"
call :create_subfolder "%SRC_DIR%\credential\credential-infrastructure\persistence"
call :create_subfolder "%SRC_DIR%\credential\credential-infrastructure\external"
call :create_subfolder "%SRC_DIR%\credential\credential-infrastructure\services"
call :create_subfolder "%SRC_DIR%\credential\credential-infrastructure\events"

:: Notification Bounded Context
echo Creating Notification bounded context...
call :create_app "%SRC_DIR%\notification\notification-api"

call :create_lib "%SRC_DIR%\notification\notification-application"
call :create_subfolder "%SRC_DIR%\notification\notification-application\commands"
call :create_subfolder "%SRC_DIR%\notification\notification-application\queries"
call :create_subfolder "%SRC_DIR%\notification\notification-application\events"
call :create_subfolder "%SRC_DIR%\notification\notification-application\behaviors"

call :create_lib "%SRC_DIR%\notification\notification-domain"
call :create_subfolder "%SRC_DIR%\notification\notification-domain\aggregates"
call :create_subfolder "%SRC_DIR%\notification\notification-domain\events"
call :create_subfolder "%SRC_DIR%\notification\notification-domain\specifications"

call :create_lib "%SRC_DIR%\notification\notification-infrastructure"
call :create_subfolder "%SRC_DIR%\notification\notification-infrastructure\persistence"
call :create_subfolder "%SRC_DIR%\notification\notification-infrastructure\external"
call :create_subfolder "%SRC_DIR%\notification\notification-infrastructure\services"
call :create_subfolder "%SRC_DIR%\notification\notification-infrastructure\events"

:: Presentation
echo Creating Presentation layer...
call :create_web "%SRC_DIR%\presentation\presentation-web"

:: Migrations
echo Creating Migration projects...
call :create_lib "%MIGRATIONS_DIR%\credential-migrations"
call :create_subfolder "%MIGRATIONS_DIR%\credential-migrations\configurations"
call :create_subfolder "%MIGRATIONS_DIR%\credential-migrations\seeds"

call :create_lib "%MIGRATIONS_DIR%\notification-migrations"
call :create_subfolder "%MIGRATIONS_DIR%\notification-migrations\configurations"
call :create_subfolder "%MIGRATIONS_DIR%\notification-migrations\seeds"

:: Tests
echo Creating test projects...
call :create_test "%TEST_DIR%\credential-tests-unit"
call :create_test "%TEST_DIR%\credential-tests-integration"
call :create_test "%TEST_DIR%\credential-tests-architecture"
call :create_test "%TEST_DIR%\notification-tests-unit"
call :create_test "%TEST_DIR%\notification-tests-integration"
call :create_test "%TEST_DIR%\notification-tests-architecture"

echo.
echo Installing dependencies...
echo Please run manually: pnpm install

echo.
echo Solution structure created successfully!
echo.
echo Next steps:
echo 1. Configure your PostgreSQL connection in .env file
echo 2. Run: pnpm install
echo 3. Run: pnpm prisma:migrate to set up database
echo 4. Run: pnpm dev to start development servers
echo.

goto :eof

:: Helper Functions
:create_lib
set "LIB_PATH=%~1"
set "LIB_NAME=%~nx1"
if not exist "%LIB_PATH%" mkdir "%LIB_PATH%" 2>nul
if not exist "%LIB_PATH%\src" mkdir "%LIB_PATH%\src" 2>nul

(
echo {
echo   "name": "@csnp/%LIB_NAME%",
echo   "version": "1.0.0",
echo   "main": "dist/index.js",
echo   "types": "dist/index.d.ts",
echo   "scripts": {
echo     "build": "tsc",
echo     "test": "jest"
echo   },
echo   "dependencies": {
echo     "@nestjs/common": "^10.3.0"
echo   },
echo   "devDependencies": {
echo     "typescript": "^5.3.0",
echo     "jest": "^29.7.0",
echo     "@types/jest": "^29.5.0"
echo   }
echo }
) > "%LIB_PATH%\package.json"

echo export {}; > "%LIB_PATH%\src\index.ts"
goto :eof

:create_app
set "APP_PATH=%~1"
set "APP_NAME=%~nx1"
if not exist "%APP_PATH%" mkdir "%APP_PATH%" 2>nul
if not exist "%APP_PATH%\src" mkdir "%APP_PATH%\src" 2>nul

(
echo {
echo   "name": "@csnp/%APP_NAME%",
echo   "version": "1.0.0",
echo   "scripts": {
echo     "build": "nest build",
echo     "start": "nest start",
echo     "start:dev": "nest start --watch",
echo     "start:prod": "node dist/main",
echo     "test": "jest"
echo   },
echo   "dependencies": {
echo     "@nestjs/common": "^10.3.0",
echo     "@nestjs/core": "^10.3.0",
echo     "@nestjs/platform-express": "^10.3.0",
echo     "reflect-metadata": "^0.2.0",
echo     "rxjs": "^7.8.0"
echo   },
echo   "devDependencies": {
echo     "@nestjs/cli": "^10.3.0",
echo     "typescript": "^5.3.0",
echo     "jest": "^29.7.0",
echo     "@types/jest": "^29.5.0"
echo   }
echo }
) > "%APP_PATH%\package.json"

(
echo import { NestFactory } from '@nestjs/core';
echo import { AppModule } from './app.module';
echo.
echo async function bootstrap^(^) {
echo   const app = await NestFactory.create^(AppModule^);
echo   await app.listen^(3000^);
echo }
echo bootstrap^(^);
) > "%APP_PATH%\src\main.ts"

(
echo import { Module } from '@nestjs/common';
echo.
echo @Module^({
echo   imports: [],
echo   controllers: [],
echo   providers: [],
echo }^)
echo export class AppModule {}
) > "%APP_PATH%\src\app.module.ts"
goto :eof

:create_web
set "WEB_PATH=%~1"
set "WEB_NAME=%~nx1"
if not exist "%WEB_PATH%" mkdir "%WEB_PATH%" 2>nul
if not exist "%WEB_PATH%\src" mkdir "%WEB_PATH%\src" 2>nul

(
echo {
echo   "name": "@csnp/%WEB_NAME%",
echo   "version": "1.0.0",
echo   "scripts": {
echo     "dev": "next dev",
echo     "build": "next build",
echo     "start": "next start"
echo   },
echo   "dependencies": {
echo     "next": "^14.0.0",
echo     "react": "^18.0.0",
echo     "react-dom": "^18.0.0"
echo   },
echo   "devDependencies": {
echo     "@types/react": "^18.0.0",
echo     "typescript": "^5.3.0"
echo   }
echo }
) > "%WEB_PATH%\package.json"
goto :eof

:create_test
set "TEST_PATH=%~1"
set "TEST_NAME=%~nx1"
if not exist "%TEST_PATH%" mkdir "%TEST_PATH%" 2>nul
if not exist "%TEST_PATH%\src" mkdir "%TEST_PATH%\src" 2>nul

(
echo {
echo   "name": "@csnp/%TEST_NAME%",
echo   "version": "1.0.0",
echo   "scripts": {
echo     "test": "jest",
echo     "test:watch": "jest --watch",
echo     "test:coverage": "jest --coverage"
echo   },
echo   "devDependencies": {
echo     "jest": "^29.7.0",
echo     "@types/jest": "^29.5.0",
echo     "typescript": "^5.3.0"
echo   }
echo }
) > "%TEST_PATH%\package.json"

echo export {}; > "%TEST_PATH%\src\index.ts"
goto :eof

:create_subfolder
set "FOLDER_PATH=%~1"
if not exist "%FOLDER_PATH%" mkdir "%FOLDER_PATH%" 2>nul
echo. > "%FOLDER_PATH%\.gitkeep"
goto :eof

:create_root_package_json
(
echo {
echo   "name": "%SOLUTION_NAME%",
echo   "version": "1.0.0",
echo   "private": true,
echo   "packageManager": "pnpm@8.15.0",
echo   "engines": {
echo     "node": "^22.0.0"
echo   },
echo   "scripts": {
echo     "build": "pnpm -r build",
echo     "dev": "pnpm -r --parallel start:dev",
echo     "test": "pnpm -r test",
echo     "test:coverage": "pnpm -r test:coverage",
echo     "prisma:generate": "prisma generate",
echo     "prisma:migrate": "prisma migrate dev",
echo     "prisma:studio": "prisma studio",
echo     "typecheck": "tsc --noEmit",
echo     "lint": "eslint . --ext .ts,.tsx",
echo     "format": "prettier --write ."
echo   },
echo   "devDependencies": {
echo     "@nestjs/cli": "^10.3.0",
echo     "@types/node": "^20.11.0",
echo     "typescript": "^5.3.0",
echo     "prisma": "^5.8.0",
echo     "jest": "^29.7.0",
echo     "@types/jest": "^29.5.0",
echo     "eslint": "^8.56.0",
echo     "prettier": "^3.2.0"
echo   },
echo   "dependencies": {
echo     "@nestjs/common": "^10.3.0",
echo     "@nestjs/core": "^10.3.0",
echo     "@nestjs/platform-express": "^10.3.0",
echo     "@prisma/client": "^5.8.0",
echo     "reflect-metadata": "^0.2.0",
echo     "rxjs": "^7.8.0"
echo   }
echo }
) > package.json

(
echo # Database Configuration
echo DATABASE_URL="postgresql://username:password@localhost:5432/csnp_dev"
echo.
echo # Application Configuration
echo NODE_ENV=development
echo PORT=3000
echo.
echo # JWT Configuration
echo JWT_SECRET=your-super-secret-jwt-key
echo JWT_EXPIRATION=24h
echo.
echo # Redis Configuration ^(optional^)
echo REDIS_URL=redis://localhost:6379
echo.
echo # RabbitMQ Configuration ^(optional^)
echo RABBITMQ_URL=amqp://localhost:5672
) > .env

(
echo # Prisma
echo /prisma/migrations/
echo.
echo # Dependencies
echo node_modules/
echo.
echo # Build outputs
echo dist/
echo build/
echo .next/
echo.
echo # Environment files
echo .env.local
echo .env.production
echo.
echo # Logs
echo *.log
echo logs/
echo.
echo # OS generated files
echo .DS_Store
echo Thumbs.db
echo.
echo # IDE files
echo .vscode/
echo .idea/
echo *.swp
echo *.swo
) > .gitignore

(
echo generator client {
echo   provider = "prisma-client-js"
echo }
echo.
echo datasource db {
echo   provider = "postgresql"
echo   url      = env^("DATABASE_URL"^)
echo }
echo.
echo // Example models - remove or modify as needed
echo model User {
echo   id        String   @id @default^(cuid^(^)^)
echo   email     String   @unique
echo   name      String?
echo   createdAt DateTime @default^(now^(^)^)
echo   updatedAt DateTime @updatedAt
echo.
echo   @@map^("users"^)
echo }
) > prisma\schema.prisma

(
echo {
echo   "compilerOptions": {
echo     "module": "commonjs",
echo     "declaration": true,
echo     "removeComments": true,
echo     "emitDecoratorMetadata": true,
echo     "experimentalDecorators": true,
echo     "allowSyntheticDefaultImports": true,
echo     "target": "ES2022",
echo     "sourceMap": true,
echo     "outDir": "./dist",
echo     "baseUrl": "./",
echo     "incremental": true,
echo     "skipLibCheck": true,
echo     "strictNullChecks": false,
echo     "noImplicitAny": false,
echo     "strictBindCallApply": false,
echo     "forceConsistentCasingInFileNames": false,
echo     "noFallthroughCasesInSwitch": false,
echo     "paths": {
echo       "@csnp/*": ["./src/*", "./shared/*"]
echo     }
echo   }
echo }
) > tsconfig.json
goto :eof

:create_pnpm_workspace
(
echo packages:
echo   - "src/**"
echo   - "shared/**"
echo   - "migrations/**"
echo   - "tests/**"
) > pnpm-workspace.yaml
goto :eof