# MBS Site Inspection Scheduling — Performance Test

Performance Toolkit (BCPT) scenarios for the *MBS Site Inspection Scheduling* extension.

---

## Overview

This companion app provides 11 BCPT codeunits covering creation, posting, query, and contention scenarios for site inspections. Use these with the Business Central Performance Toolkit to benchmark and stress-test the inspection scheduling workflow.

## Quick Start

1. Publish the main *MBS Site Inspection Scheduling* app
2. Publish this performance test app
3. Open **BCPT Setup** in Business Central
4. Import `bcptSuite.json` or manually configure scenarios
5. Run the performance test suite

## Scenarios

### Creation

| Codeunit | ID | Description | Parameters |
|----------|----|-------------|------------|
| MBS BCPT Create Insp. Type | 50201 | Single type creation | — |
| MBS BCPT Create Insp. Type Blk | 50202 | Bulk type creation | `InspectionTypes=100` |
| MBS BCPT Create Inspection | 50203 | Single inspection with lines | `Lines=10` |
| MBS BCPT Create Inspection Blk | 50204 | Bulk inspection creation | `Inspections=100,Lines=10` |

### Posting

| Codeunit | ID | Description | Parameters |
|----------|----|-------------|------------|
| MBS BCPT Post Inspection | 50205 | Post single inspection | `Lines=10` |
| MBS BCPT Post Inspection Blk | 50206 | Post batch of inspections | `Inspections=50,Lines=10` |
| MBS BCPT Post Insp. Validation | 50207 | Validation failure path | — |

### Query

| Codeunit | ID | Description | Parameters |
|----------|----|-------------|------------|
| MBS BCPT Overdue Backlog Query | 50208 | Query overdue inspections | `Inspections=500` |
| MBS BCPT Repeat Site Query | 50209 | Query repeated-site history | `HistoryPerSite=50` |

### Contention

| Codeunit | ID | Description | Parameters |
|----------|----|-------------|------------|
| MBS BCPT Inspector Contention | 50210 | Shared inspector assignment | `SharedInspectors=3,Inspections=20` |
| MBS BCPT Site Contention | 50211 | Shared site scheduling | `Sites=2,Inspections=30` |

## Library

| Codeunit | ID | Purpose |
|----------|----|---------|
| MBS BCPT Library - Inspection | 50200 | Setup, data creation, posting, seeding helpers |

## Object ID Range

`50200..50299`

## Dependencies

- MBS Site Inspection Scheduling (main app)
- Microsoft Performance Toolkit
- Microsoft Tests-TestLibraries
