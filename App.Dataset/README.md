# MBS Site Inspection Scheduling — Dataset

Contoso-style demo data for the *MBS Site Inspection Scheduling* extension.

---

## Overview

This companion app registers a dataset module with the Contoso Demo Data framework and generates layered demo data — setup, master, transactional, and historical — in a single idempotent pass. It creates a rich, realistic dataset suitable for demos and training.

## Quick Start

1. Publish the main *MBS Site Inspection Scheduling* app
2. Publish this dataset app
3. Open **Contoso Demo Tool** in Business Central
4. Select the *Site Inspection Scheduling* module
5. Run data generation

## Generated Data

### Setup Layer
- Number series for types, inspections, and posted inspections
- Inspection setup with default duration and threshold

### Master Data Layer

| Entity | Count | Examples |
|--------|-------|---------|
| Inspection Types | 5 | Safety Walkthrough, Compliance Audit, Equipment Condition Review, Site Readiness Check, Close-Out Review |
| Inspector Resources | 4 | Anna Bergström, Carlos Moreno, Diana Patel, Erik Johansson |
| Target Customers (Sites) | 6 | Northwind Warehouse A/B, Contoso Branch Office, Fabrikam Distribution Center, etc. |

### Transactional Layer

| Scenario | Count | Purpose |
|----------|-------|---------|
| Scheduled inspections | 4 | Future work visible in backlog |
| Overdue inspections | 2 | Past-due items requiring attention |
| Ready-to-post inspections | 2 | Can be posted during live demos |

### Historical Layer

| Pattern | Site | Story |
|---------|------|-------|
| Recurring issues | Warehouse B (SITE-002) | 4 safety inspections, 2 with escalating findings |
| Improving trend | Distribution Center (SITE-004) | 3 compliance audits, issues resolved over time |
| Clean record | Warehouse A (SITE-001) | 3 clean inspections for positive comparison |

## Objects

| ID | Type | Name |
|----|------|------|
| 50300 | Enum Extension | MBS Inspection Demo Module |
| 50301 | Codeunit | MBS Contoso Inspection |

## Object ID Range

`50300..50399`

## Design Notes

- **Idempotent**: Master data uses `if Get() then exit` guards; re-runs don't corrupt existing records
- **Four-layer pattern**: Setup → Master → Transactional → Historical
- All historical inspections are posted with full ledger entries

## Dependencies

- MBS Site Inspection Scheduling (main app)
- Microsoft Contoso Coffee Demo Dataset
