# DDD Onion Hexagonal iOS Starter Template

A high-performance, autonomous-ready iOS application template built with **SwiftUI** and **Clean Architecture (Hexagonal)**. Designed for **AI-only maintenance** and strict architectural boundaries.

## 🏛 Architecture Overview

The project is structured as a set of isolated Swift Package Manager (SPM) packages to ensure strict dependency inversion (The Dependency Rule).

- **CoreDomain (The Center):** Pure business logic. Zero dependencies on UI, network, or persistence. Contains Entities, Use Case Protocols, and Domain Errors.
- **CoreData (Infrastructure):** Implements `CoreDomain` protocols. Contains Networking (URLSession), Persistence (SwiftData), and Mocks.
- **CoreUI (Presentation):** Contains dumb SwiftUI Views and strict ViewModels that orchestrate Domain Use Cases.
- **App (Composition Root):** The main target that wires up dependencies using the `CompositionRoot` pattern.

## 🤖 AI-Agent Rules

This repository contains critical guardrails for AI agents in the root:
- `AI.md`: The Master Source of Truth for architectural rules.
- `GEMINI.md`, `CLAUDE.md`, `CODEX.md`: Thin wrappers enforcing the reading of `AI.md`.

## 🛠 Automation & Quality

Run all architectural and quality checks using the provided Makefile:

```bash
make verify
```

This script enforces:
1. **No UI Frameworks in Domain:** Verifies `CoreDomain` doesn't import `SwiftUI` or `UIKit`.
2. **SwiftLint Verification:** Enforces coding standards (if `swiftlint` is installed).
3. **Multi-Package Testing:** Runs tests for all SPM packages simultaneously.

## 🚀 Getting Started

1. Open the Swift packages in Xcode or your preferred editor.
2. Run `make verify` to ensure the environment is correctly set up.
3. Start implementing your vertical slices by defining a UseCase in `CoreDomain`.

## 🔒 Security

- Credentials and API keys must be handled through `AppConfiguration`.
- Use SSH keys for Git operations. Never commit credentials or tokens to source.

---
*Built for the future of autonomous software engineering.*
