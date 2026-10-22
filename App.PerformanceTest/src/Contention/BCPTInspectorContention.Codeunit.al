namespace MBS.SiteInspection.PerformanceTest;

using MBS.SiteInspection.Inspection;
using MBS.SiteInspection.Scheduling;
using System.Tooling;

codeunit 50210 "MBS BCPT Inspector Contention"
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
        SharedInspectors: Integer;
        InspCount: Integer;
        i: Integer;
    begin
        BCPTLibrary.CreateInspectionSetup();
        BCPTLibrary.CreateInspectionType(InspType);
        SharedInspectors := BCPTLibrary.GetIntegerParameter(BCPTTestContext.GetParameters(), 'SharedInspectors', 3);
        InspCount := BCPTLibrary.GetIntegerParameter(BCPTTestContext.GetParameters(), 'Inspections', 20);
        BCPTLibrary.CreateInspectorPool(InspectorNos, SharedInspectors);
        BCPTLibrary.CreateTargetEntityPool(CustomerNos, 10);
        BCPTTestContext.StartScenario('Inspector Assignment Contention');
        for i := 1 to InspCount do
            BCPTLibrary.CreateInspection(
                InspType."No.",
                CustomerNos.Get((i mod CustomerNos.Count()) + 1),
                InspectorNos.Get((i mod InspectorNos.Count()) + 1),
                5,
                InspHeader);
        BCPTTestContext.EndScenario('Inspector Assignment Contention');
    end;
}
