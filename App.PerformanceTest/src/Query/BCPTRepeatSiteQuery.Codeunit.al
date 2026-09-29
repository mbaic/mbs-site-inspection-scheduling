namespace MBS.SiteInspection.PerformanceTest;

using MBS.SiteInspection.Inspection;
using MBS.SiteInspection.Ledger;
using System.Tooling;

codeunit 50209 "MBS BCPT Repeat Site Query"
{
    Access = Internal;

    var
        BCPTLibrary: Codeunit "MBS BCPT Library - Inspection";
        BCPTTestContext: Codeunit "BCPT Test Context";

    trigger OnRun()
    var
        InspType: Record "MBS Inspection Type";
        InspectorNos: List of [Code[20]];
        CustomerNos: List of [Code[20]];
        InspLedgerEntry: Record "MBS Inspection Ledger Entry";
        HistoryCount: Integer;
        ResultCount: Integer;
    begin
        BCPTLibrary.CreateInspectionSetup();
        BCPTLibrary.CreateInspectionType(InspType);
        BCPTLibrary.CreateInspectorPool(InspectorNos, 3);
        BCPTLibrary.CreateTargetEntityPool(CustomerNos, 1);
        HistoryCount := BCPTLibrary.GetIntegerParameter(BCPTTestContext.GetParameters(), 'HistoryPerSite', 50);
        BCPTLibrary.SeedRepeatedSiteHistory(InspType."No.", CustomerNos.Get(1), InspectorNos.Get(1), HistoryCount);
        BCPTTestContext.StartScenario('Repeated Site History Query');
        InspLedgerEntry.SetRange("Customer No.", CustomerNos.Get(1));
        InspLedgerEntry.SetRange("Inspection Type No.", InspType."No.");
        ResultCount := InspLedgerEntry.Count();
        BCPTTestContext.EndScenario('Repeated Site History Query');
        if ResultCount < HistoryCount then
            Error('Expected at least %1 history entries, found %2.', HistoryCount, ResultCount);
    end;
}
