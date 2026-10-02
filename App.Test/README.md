# MBS Site Inspection Scheduling - Test

Automated test suite for the [MBS Site Inspection Scheduling](../README.md) extension.

## Problem

The inspection workflow (setup, scheduling, posting, ledger) contains rules that must keep holding as the extension and the Business Central platform evolve, such as required fields, blocked types, posting prerequisites, and ledger traceability. Without automated tests, regressions only surface in manual demos.

## Why this matters

It gives fast regression feedback in AL-Go CI and on upcoming BC releases (`Current` / `NextMinor` / `NextMajor` workflows), and shows a layered test-app structure for partner projects.

## Architecture

- **Scope:** 7 test codeunits (50101-50107) and one shared library (50100), 25 test methods in total, covering setup, type management, document creation, posting, ledger entries, permissions, and reporting views.
- **Access:** the tests call internal objects of the main app (tables, posting codeunits) through `internalsVisibleTo`.
- **Data:** every test builds its own data through `MBS Library - Inspection`; names and numbers are randomized with the Microsoft `Any` library.
- **Boundaries:** inside Business Central only, no external components.

### Test coverage

| Codeunit | ID | Tests | Area |
|----------|----|-------|------|
| MBS Inspection Setup Tests | 50101 | 3 | Setup initialization, type number series, posting without required setup |
| MBS Inspection Type Tests | 50102 | 3 | Blocked types, duration default, comment indicator |
| MBS Inspection Document Tests | 50103 | 7 | Required header fields (customer, inspector, posting date), no-lines error, finding/result validation, optional planned date |
| MBS Inspection Posting Tests | 50104 | 5 | Posted record creation, comment copy, double posting, status must be *Closed*, direct table modification |
| MBS Inspection Ledger Tests | 50105 | 3 | Ledger entries, register, traceability |
| MBS Inspection Perm. Tests | 50106 | 1 | End-to-end workflow run |
| MBS Inspection Reporting Tests | 50107 | 3 | Overdue filtering, site history, type filtering |

**Total: 25 test methods**

### Test library

| Codeunit | ID | Purpose |
|----------|----|---------|
| MBS Library - Inspection | 50100 | Test data helpers (setup, types, headers, lines, posting) |

### Test patterns

- Arrange-act-assert; three tests also carry `[SCENARIO]` tags.
- `asserterror` with `LibraryAssert.ExpectedError` for negative tests.
- Each test creates its own data, so there is no execution order dependency.

## Demo steps

1. Publish the main *MBS Site Inspection Scheduling* app.
2. Publish this test app.
3. Run the tests via the **Test Tool** page or **Test Runner** in Business Central.
4. All 25 tests should pass.

## What is intentionally simple

- Tests exercise the domain logic through records and codeunits, not through UI pages.
- One shared helper library; no mocking.
- Reporting tests check filtered views over the data, not report objects (the app has none).

## Risks/limits

- **Permissions are not tested.** All test codeunits run with `TestPermissions = Disabled`, and `MBS Inspection Perm. Tests` is a single workflow run, so it does not verify the permission set.
- **Some tests assert less than their names suggest:**
  - `ClosedInspectionCannotBeReopenedByInvalidTransitionTest` only creates and posts a document (the app has no status transition rules).
  - `InspectionTypeDurationDefaultsToSetupWhenBlankTest` only checks the library's default duration.
  - `OverdueInspectionViewShowsExpectedBacklogTest` checks a filter on planned date and status.
  - `CannotPostInspectionTwiceTest` asserts only that an error occurs, not which one.
  - `PostedInspectionRemainsImmutableTest` documents that direct table modification succeeds; immutability relies on read-only pages.
- No UI, performance, or upgrade tests (performance is in `App.PerformanceTest`).

## Next iteration

- Align test names and assertions, and add the missing status-transition checks once they exist in the app.
- Add permission tests with test permissions enabled, per role once role-based permission sets exist.
- Add negative tests for table-level immutability once guards are added.

## Notes

- **Object ID range:** `50100..50199`
- **Dependencies:** MBS Site Inspection Scheduling (main app); Microsoft Library Assert, Any, System Application Test Library, Tests-TestLibraries, Test Runner, Library Variable Storage.
- **Structure:** one folder per area under `src/` (`Inspection`, `Ledger`, `Permissions`, `Posting`, `Reports`, `Setup`) plus `src/Library`.
- **CI:** registered under `testFolders` in `.AL-Go/settings.json`.
- **License:** [MIT](../LICENSE)
