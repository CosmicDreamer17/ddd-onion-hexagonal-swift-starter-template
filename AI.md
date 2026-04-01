# AI Master Source of Truth

This application uses a strict Hexagonal/Clean Architecture.

## Operational Rules
- Always use `/plan` mode before modifying `CoreDomain`.
- Views must be dumb. No business logic in SwiftUI `.onAppear` or other view modifiers. All logic must reside in ViewModels or UseCases.
- All data models must be strictly typed; avoid `Any` or forced unwrapping (`!`).
- Architecture is verified via `scripts/verify.sh`. Ensure you run it before committing.
- Dependencies must point INWARD toward the Domain (`CoreDomain`).
  - `CoreDomain`: Zero dependencies.
  - `CoreData`: Depends on `CoreDomain`.
  - `CoreUI`: Depends on `CoreDomain`.
  - Main App Target: Acts ONLY as the Composition Root, injecting dependencies.
