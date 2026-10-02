# MBS Site Inspection Scheduling - Dataset

Contoso-style demo data for the [MBS Site Inspection Scheduling](../README.md) extension, delivered as a module for Microsoft's Contoso Demo Data framework.

## Problem

An inspection app is hard to demo or train on with an empty database. The scenarios that matter (a backlog, overdue work, recurring issues at one site, an improving trend at another) need realistic data across setup, master data, open documents, and posted history.

## Why this matters

Demo and training environments get a consistent, story-driven dataset in a few clicks, using the same Contoso Demo Tool as the standard BC demo data. Reviewers can show the full workflow without hand-keying data, including live posting.

## Architecture

- **Module registration:** enum extension 50300 adds *Site Inspection Scheduling* to the `Contoso Demo Data Module` enum and binds it to codeunit 50301, `MBS Contoso Inspection`, which implements `Contoso Demo Data Module`.
- **Layers:** setup, master data, transactional, and historical, run in that order by the Contoso Demo Tool.
- **Posting:** historical inspections are created as closed documents and posted through the main app's `MBS Inspection-Post`, so they produce real posted records, ledger entries, and registers.
- **Scope:** writes inside Business Central only (no external components). Setup and master-data writes are guarded with `Get()` checks.
- **Dependencies:** the main app and Microsoft's Contoso Coffee Demo Dataset. The module itself declares no Contoso module dependencies and has no configuration page.

### Generated data

**Setup layer**

- Number series `MB-ITYPE`, `MB-INSP`, and `MB-PINSP` for types, inspections, and posted inspections
- Inspection setup with default duration (1 day) and overdue threshold (0 days)

**Master data layer**

| Entity | Count | Examples |
|--------|-------|----------|
| Inspection Types | 5 | Safety Walkthrough, Compliance Audit, Equipment Condition Review, Site Readiness Check, Close-Out Review |
| Inspector Resources | 4 | Anna Bergström, Carlos Moreno, Diana Patel, Erik Johansson |
| Target Customers (Sites) | 6 | Northwind Warehouse A/B, Contoso Branch Office, Fabrikam Distribution Center, Woodgrove Service Hub, Alpine Equipment Yard |

**Transactional layer**

| Scenario | Count | Purpose |
|----------|-------|---------|
| Scheduled inspections | 4 | Future work visible in the backlog |
| Overdue inspections | 2 | Past-due items requiring attention (one open finding each) |
| Ready-to-post inspections | 2 | Closed documents that can be posted during live demos |

**Historical layer** (all posted, with ledger entries)

| Pattern | Site | Story |
|---------|------|-------|
| Baseline history | Various | 5 posted inspections, one per inspection type, 2 to 6 months back |
| Recurring issues | Warehouse B (SITE-002) | 4 safety inspections, 2 with escalating findings (High, then Critical) |
| Improving trend | Distribution Center (SITE-004) | 3 compliance audits, issues resolved over time |
| Clean record | Warehouse A (SITE-001) | 3 clean safety inspections for positive comparison |

### Objects

| ID | Type | Name |
|----|------|------|
| 50300 | Enum Extension | MBS Inspection Demo Module |
| 50301 | Codeunit | MBS Contoso Inspection |

## Demo steps

1. Publish the main *MBS Site Inspection Scheduling* app.
2. Publish this dataset app.
3. Open **Contoso Demo Tool** in Business Central.
4. Select the *Site Inspection Scheduling* module.
5. Run data generation.
6. Verify: *Inspections* shows 8 unposted documents (4 scheduled and 2 overdue with status *Open*, 2 *Closed* and ready to post); *Posted Inspections* and *Inspection Ledger Entries* show the 15 historical records.

## What is intentionally simple

- Hardcoded numbers series, codes, names, and Swedish city addresses (`SITE-001..006`, `INSP-001..004`).
- Minimal customer and resource records (name, address, city, job title); no posting groups, so the sites are not set up for sales use.
- Fixed checklist lines with generic descriptions.
- Dates are calculated relative to the work date at generation time.

## Risks/limits

- **Only setup and master data are re-run safe.** Number series, setup, types, resources, and customers are skipped if they already exist. Transactional and historical data always create new documents, so running generation twice duplicates them.
- Demo and sandbox use only; the data creates customers and resources with fixed numbers that could clash with existing records.
- "Overdue" is relative to the work date at generation time.
- No configuration options: the module has no configuration page.

## Next iteration

- Make transactional and historical generation re-run safe (for example, skip when the demo documents already exist).
- Add configuration (dates, volumes, localized names).
- Complete the demo customers and resources so they are usable in other BC processes.

## Notes

- **Object ID range:** `50300..50399`
- **Dependencies:** MBS Site Inspection Scheduling (main app); Microsoft Contoso Coffee Demo Dataset
- **Structure:** `src/Module/` holds the enum extension; `src/Helpers/` holds the generator codeunit.
- **License:** [MIT](../LICENSE)
