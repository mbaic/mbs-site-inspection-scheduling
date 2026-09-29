# MBS Site Inspection Scheduling — Test

Automated test suite for the *MBS Site Inspection Scheduling* extension.

---

## Overview

This companion app provides comprehensive automated tests covering the full inspection lifecycle: setup, type management, document creation, posting, ledger entries, permissions, and reporting views.

## Quick Start

1. Publish the main *MBS Site Inspection Scheduling* app
2. Publish this test app
3. Run tests via the **Test Tool** page or **Test Runner** in Business Central

## Test Coverage

| Codeunit | ID | Tests | Area |
|----------|----|-------|------|
| MBS Inspection Setup Tests | 50101 | 3 | Setup initialization, no. series, validation |
| MBS Inspection Type Tests | 50102 | 3 | Blocked types, duration defaults, comments |
| MBS Inspection Document Tests | 50103 | 7 | Required fields, status transitions, line validation |
| MBS Inspection Posting Tests | 50104 | 5 | Posting lifecycle, comments copy, immutability |
| MBS Inspection Ledger Tests | 50105 | 3 | Ledger entries, register, traceability |
| MBS Inspection Perm. Tests | 50106 | 1 | End-to-end workflow permissions |
| MBS Inspection Reporting Tests | 50107 | 3 | Overdue filtering, site history, type filtering |

**Total: 25 test methods**

## Test Library

| Codeunit | ID | Purpose |
|----------|----|---------|
| MBS Library - Inspection | 50100 | Test data helpers (setup, types, headers, lines, posting) |

## Object ID Range

`50100..50199`

## Test Patterns

- **GIVEN / WHEN / THEN** structure with `[SCENARIO]` tags
- Deterministic data via `MBS Library - Inspection`
- `asserterror` + `ExpectedError` for negative tests
- Each test is independent — no execution order dependency

## Dependencies

- MBS Site Inspection Scheduling (main app)
- Microsoft Library Assert
- Microsoft Test Runner
- Microsoft Library Variable Storage
- Microsoft Tests-TestLibraries
