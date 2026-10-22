namespace MBS.SiteInspection.PerformanceTest;

using MBS.SiteInspection.Inspection;
using MBS.SiteInspection.Scheduling;
using MBS.SiteInspection.Posting;
using System.Tooling;

codeunit 50208 "MBS BCPT Overdue Backlog Query"
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
        OverdueHeader: Record "MBS Inspection Header";
        SeedCount: Integer;
        OverdueCount: Integer;
    begin
        BCPTLibrary.CreateInspectionSetup();
        BCPTLibrary.CreateInspectionType(InspType);
        BCPTLibrary.CreateInspectorPool(InspectorNos, 3);
        BCPTLibrary.CreateTargetEntityPool(CustomerNos, 5);
        SeedCount := BCPTLibrary.GetIntegerParameter(BCPTTestContext.GetParameters(), 'Inspections', 500);
        BCPTLibrary.SeedOverdueBacklog(InspType."No.", CustomerNos.Get(1), InspectorNos.Get(1), SeedCount);
        BCPTTestContext.StartScenario('Overdue Backlog Query');
        OverdueHeader.SetFilter("Planned Date", '<%1', WorkDate());
        OverdueHeader.SetRange(Status, "MBS Inspection Status"::Open);
        OverdueCount := OverdueHeader.Count();
        BCPTTestContext.EndScenario('Overdue Backlog Query');
        if OverdueCount < SeedCount then
            Error('Expected at least %1 overdue inspections, found %2.', SeedCount, OverdueCount);
    end;
}
