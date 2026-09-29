# MBS Site Inspection Scheduling

A Microsoft Dynamics 365 Business Central **Per-Tenant Extension (PTE)** demo app for planning, executing, posting, and reviewing site inspections — built on the [AL-Go for GitHub](https://github.com/microsoft/AL-Go) template.

Many organizations run repeated inspections for quality, compliance, safety, or readiness reasons, but the process is often fragmented across spreadsheets, PDFs, email, and field notes. This app introduces a BC-native workflow for inspection scheduling, execution, and immutable posted history — so it's always possible to answer *what was inspected, by whom, with what result, and which sites keep coming up*.

## Solution overview

| Capability | Description |
|---|---|
| **Inspection Types** | Reusable inspection categories (Safety, Compliance, Equipment, etc.) |
| **Inspection Documents** | Schedule inspections against customer sites, with inspectors and checklist lines |
| **Posting** | Post completed inspections to create immutable historical records |
| **Ledger & Register** | Full audit trail via inspection ledger entries and posting registers |
| **Comments** | Attach comments to inspection types, active documents, and posted history |

### Primary personas

- **Inspection Coordinator** — schedules inspections and manages backlog/overdue work
- **Inspector** — performs inspections and records findings
- **Compliance / Quality Manager** — reviews historical outcomes and recurring issues
- **Operations Manager** — tracks site readiness and completion trends

## Repository structure

This repository is built on [AL-Go for GitHub](https://aka.ms/AL-Go) (PTE template) and contains four AL projects:

| Folder | App | Purpose |
|---|---|---|
| `App` | MBS Site Inspection Scheduling | Main extension — tables, pages, posting logic, permission set |
| `App.Test` | MBS Site Inspection Scheduling Test | Automated test suite (25 test methods) |
| `App.Dataset` | MBS Site Inspection Scheduling Dataset | Contoso Demo Data module — generates realistic demo data |
| `App.PerformanceTest` | MBS Site Inspection Scheduling Performance Test | Business Central Performance Toolkit (BCPT) scenarios |

Object ID ranges (non-overlapping):

| App | Range |
|---|---|
| App | `50000..50099` |
| App.Test | `50100..50199` |
| App.PerformanceTest | `50200..50299` |
| App.Dataset | `50300..50399` |

See each app folder's own `README.md` for a full object reference.

## Quick start (in Business Central)

1. Publish **App** (main extension)
2. Open **Inspection Setup** and configure number series
3. Open **Inspection Types** and create categories (e.g. Safety Walkthrough, Compliance Audit)
4. Open **Inspections**, create a document, assign a type, site/customer, and inspector
5. Add checklist lines with findings (Satisfactory / Unsatisfactory)
6. Set status to **Closed** and **Post** (F9) to create the posted record

Optionally publish **App.Dataset** and run the **Contoso Demo Tool** to seed realistic demo data (master data, scheduled/overdue/ready-to-post inspections, and historical patterns across sites).

## Building and CI/CD

This repository uses AL-Go for GitHub for build, test, and release automation. Key workflows under `.github/workflows`:

- **CI/CD** (`CICD.yaml`) — builds and tests all four apps on push to `main`/`release/*`/`feature/*`, or via manual dispatch
- **Pull Request Build** (`PullRequestHandler.yaml`) — validates pull requests targeting `main`
- **Create Release** (`CreateRelease.yaml`) — packages and publishes GitHub releases
- **Increment Version Number**, **Current/NextMinor/NextMajor** — version management and forward-compatibility testing against upcoming Business Central releases

See [`.github/RELEASENOTES.copy.md`](.github/RELEASENOTES.copy.md) for the AL-Go release notes, and [AL-Go Scenarios](https://github.com/microsoft/AL-Go/tree/main/Scenarios) for usage documentation.

## Requirements

- Business Central platform/application **28.0.0.0** or later
- No external app dependencies for the main app; `App.Dataset` depends on Microsoft's **Contoso Coffee Demo Dataset**

## Disclaimer

This is a **demo/sample application** intended to showcase AL-Go and modern AL development practices (namespaces, layered test/performance/dataset apps). It is not an officially supported Microsoft product.

## License

Licensed under the [MIT License](LICENSE).
