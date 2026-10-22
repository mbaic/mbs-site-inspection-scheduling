namespace MBS.SiteInspection.PerformanceTest;

using MBS.SiteInspection.Inspection;
using MBS.SiteInspection.Scheduling;
using System.Tooling;

codeunit 50204 "MBS BCPT Create Inspection Blk"
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
        InspHeader: Record "MBS Inspection Header";
        InspCount: Integer;
        LineCount: Integer;
        i: Integer;
    begin
        BCPTLibrary.CreateInspectionSetup();
        BCPTLibrary.CreateInspectionType(InspType);
        BCPTLibrary.CreateInspectorPool(InspectorNos, 3);
        BCPTLibrary.CreateTargetEntityPool(CustomerNos, 5);
        InspCount := BCPTLibrary.GetIntegerParameter(BCPTTestContext.GetParameters(), 'Inspections', 100);
        LineCount := BCPTLibrary.GetIntegerParameter(BCPTTestContext.GetParameters(), 'Lines', 10);
        BCPTTestContext.StartScenario('Create Inspections Bulk');
        for i := 1 to InspCount do
            BCPTLibrary.CreateInspection(
                InspType."No.",
                CustomerNos.Get((i mod CustomerNos.Count()) + 1),
                InspectorNos.Get((i mod InspectorNos.Count()) + 1),
                LineCount,
                InspHeader);
        BCPTTestContext.EndScenario('Create Inspections Bulk');
    end;
}
