# MBS Site Inspection Scheduling

A Microsoft Dynamics 365 Business Central extension for managing site inspections — from scheduling through posting to historical analysis.

---

## Overview

| Feature | Description |
|---------|-------------|
| **Inspection Types** | Define reusable inspection categories (Safety, Compliance, Equipment, etc.) |
| **Inspection Documents** | Schedule inspections with customer sites, inspectors, and checklist lines |
| **Posting** | Post completed inspections to create immutable historical records |
| **Ledger & Register** | Full audit trail with inspection ledger entries and registers |
| **Comments** | Attach comments to inspection types, documents, and posted inspections |

## Quick Start

1. **Setup** — Open *Inspection Setup* and configure number series for types, inspections, and posted inspections
2. **Create Types** — Open *Inspection Types* and create categories (e.g., Safety Walkthrough, Compliance Audit)
3. **Schedule** — Open *Inspections*, create a new document, assign type, customer site, and inspector
4. **Inspect** — Add checklist lines with findings (Satisfactory / Unsatisfactory)
5. **Post** — Set status to *Closed* and press **Post** (F9) to create the posted record

## Object ID Range

`50000..50099`

## Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────────┐
│  Inspection      │───▶│  Inspection      │───▶│  Posted Inspection  │
│  Type (Master)   │    │  Document        │    │  (Immutable)        │
└─────────────────┘    └──────────────────┘    └─────────────────────┘
                              │                         │
                              ▼                         ▼
                       ┌──────────────┐         ┌──────────────────┐
                       │  Insp. Lines  │         │  Ledger Entries  │
                       │  (Checklist)  │         │  + Registers     │
                       └──────────────┘         └──────────────────┘
```

## Detailed Object Reference

### Tables

| ID | Name | Purpose |
|----|------|---------|
| 50000 | MBS Inspection Setup | Number series and default configuration |
| 50001 | MBS Inspection Type | Master data for inspection categories |
| 50002 | MBS Inspection Header | Active inspection documents |
| 50003 | MBS Inspection Line | Checklist items and findings |
| 50004 | MBS Inspection Comment Line | Comments across all document types |
| 50005 | MBS Posted Inspection Hdr. | Immutable posted inspection header |
| 50006 | MBS Posted Inspection Line | Immutable posted inspection lines |
| 50007 | MBS Inspection Ledger Entry | Audit trail entries |
| 50008 | MBS Inspection Register | Posting register |
| 50009 | MBS Inspection Journal Line | Internal posting buffer |

### Pages

| ID | Name | Type |
|----|------|------|
| 50010 | MBS Inspection Setup | Card |
| 50011 | MBS Inspection Type List | List |
| 50012 | MBS Inspection Type Card | Card |
| 50013 | MBS Inspection Comment Sheet | List |
| 50014 | MBS Inspection Comment List | ListPart |
| 50015 | MBS Inspection | Document |
| 50016 | MBS Inspection List | List |
| 50017 | MBS Inspection Subpage | ListPart |
| 50018 | MBS Posted Inspection | Document |
| 50019 | MBS Posted Inspection List | List |
| 50020 | MBS Posted Inspection Subpage | ListPart |
| 50021 | MBS Inspection Ledger Entries | List |
| 50022 | MBS Inspection Registers | List |

### Codeunits

| ID | Name | Purpose |
|----|------|---------|
| 50030 | MBS Inspection-Post | Core posting logic |
| 50031 | MBS Inspection-Post (Yes/No) | Posting with confirmation dialog |
| 50032 | MBS Inspection Jnl.-Check Line | Journal line validation |
| 50033 | MBS Inspection Jnl.-Post Line | Journal line posting to ledger |

### Enums

| ID | Name | Values |
|----|------|--------|
| 50040 | MBS Inspection Status | Planning, Open, Closed |
| 50041 | MBS Inspection Result Status | (blank), Satisfactory, Unsatisfactory, Not Inspected |
| 50042 | MBS Inspection Entry Type | Inspection |
| 50043 | MBS Insp. Comment Table Name | Inspection Type, Inspection, Posted Inspection |
| 50044 | MBS Inspection Priority | Low, Medium, High, Critical |

## Dependencies

- Business Central platform 28.0.0.0+
- No external app dependencies

## License

Proprietary — MBS
