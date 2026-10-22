namespace MBS.SiteInspection.Permissions;

using MBS.SiteInspection.Inspection;
using MBS.SiteInspection.Scheduling;
using MBS.SiteInspection.PostedInspection;
using MBS.SiteInspection.Ledger;
using MBS.SiteInspection.Setup;
using MBS.SiteInspection.Posting;

permissionset 50050 "MBS Insp. All Users"
{
    Assignable = true;
    Caption = 'Inspection - All Users';

    Permissions =
        table "MBS Inspection Setup" = X,
        table "MBS Inspection Type" = X,
        table "MBS Inspection Header" = X,
        table "MBS Inspection Line" = X,
        table "MBS Inspection Comment Line" = X,
        table "MBS Posted Inspection Hdr." = X,
        table "MBS Posted Inspection Line" = X,
        table "MBS Inspection Ledger Entry" = X,
        table "MBS Inspection Register" = X,
        table "MBS Inspection Journal Line" = X,
        tabledata "MBS Inspection Setup" = RIMD,
        tabledata "MBS Inspection Type" = RIMD,
        tabledata "MBS Inspection Header" = RIMD,
        tabledata "MBS Inspection Line" = RIMD,
        tabledata "MBS Inspection Comment Line" = RIMD,
        tabledata "MBS Posted Inspection Hdr." = RIMD,
        tabledata "MBS Posted Inspection Line" = RIMD,
        tabledata "MBS Inspection Ledger Entry" = RIMD,
        tabledata "MBS Inspection Register" = RIMD,
        tabledata "MBS Inspection Journal Line" = RIMD,
        page "MBS Inspection Setup" = X,
        page "MBS Inspection Type List" = X,
        page "MBS Inspection Type Card" = X,
        page "MBS Inspection Comment Sheet" = X,
        page "MBS Inspection Comment List" = X,
        page "MBS Inspection" = X,
        page "MBS Inspection List" = X,
        page "MBS Inspection Subpage" = X,
        page "MBS Posted Inspection" = X,
        page "MBS Posted Inspection List" = X,
        page "MBS Posted Inspection Subpage" = X,
        page "MBS Inspection Ledger Entries" = X,
        page "MBS Inspection Registers" = X,
        codeunit "MBS Inspection-Post" = X,
        codeunit "MBS Inspection-Post (Yes/No)" = X,
        codeunit "MBS Inspection Jnl.-Check Line" = X,
        codeunit "MBS Inspection Jnl.-Post Line" = X;
}
