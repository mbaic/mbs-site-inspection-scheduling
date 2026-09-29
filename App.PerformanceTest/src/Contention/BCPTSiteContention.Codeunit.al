namespace MBS.SiteInspection.PerformanceTest;

using MBS.SiteInspection.Inspection;
using MBS.SiteInspection.Scheduling;
using System.Tooling;

codeunit 50211 "MBS BCPT Site Contention"
{
    Access = Internal;

    var
        BCPTLibrary: Codeunit "MBS BCPT Library - Inspection";
        BCPTTestContext: Codeunit "BCPT Test Context";

    trigger OnRun()
    var
        InspType: Record "MBS Inspection Type";
        InspHeader: Record "MBS Inspection Header";
        InspectorNos: List of [Code[20]];
        CustomerNos: List of [Code[20]];
        SharedSites: Integer;
        InspCount: Integer;
        i: Integer;
    begin
        BCPTLibrary.CreateInspectionSetup();
        BCPTLibrary.CreateInspectionType(InspType);
        SharedSites := BCPTLibrary.GetIntegerParameter(BCPTTestContext.GetParameters(), 'Sites', 2);
        InspCount := BCPTLibrary.GetIntegerParameter(BCPTTestContext.GetParameters(), 'Inspections', 30);
        BCPTLibrary.CreateInspectorPool(InspectorNos, 5);
        BCPTLibrary.CreateTargetEntityPool(CustomerNos, SharedSites);
        BCPTTestContext.StartScenario('Site Schedule Contention');
        for i := 1 to InspCount do
            BCPTLibrary.CreateInspection(
                InspType."No.",
                CustomerNos.Get((i mod CustomerNos.Count()) + 1),
                InspectorNos.Get((i mod InspectorNos.Count()) + 1),
                5,
                InspHeader);
        BCPTTestContext.EndScenario('Site Schedule Contention');
    end;
}
