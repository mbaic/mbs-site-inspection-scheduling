namespace MBS.SiteInspection.PerformanceTest;

using MBS.SiteInspection.Inspection;
using MBS.SiteInspection.Scheduling;
using System.Tooling;

codeunit 50206 "MBS BCPT Post Inspection Blk"
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
        HeaderNos: List of [Code[20]];
        InspCount: Integer;
        LineCount: Integer;
        PostedCountBefore: Integer;
    begin
        BCPTLibrary.CreateInspectionSetup();
        BCPTLibrary.CreateInspectionType(InspType);
        BCPTLibrary.CreateInspectorPool(InspectorNos, 3);
        BCPTLibrary.CreateTargetEntityPool(CustomerNos, 5);
        InspCount := BCPTLibrary.GetIntegerParameter(BCPTTestContext.GetParameters(), 'Inspections', 50);
        LineCount := BCPTLibrary.GetIntegerParameter(BCPTTestContext.GetParameters(), 'Lines', 10);
        BCPTLibrary.CreateReadyToPostInspectionBatch(
            InspType."No.", CustomerNos.Get(1), InspectorNos.Get(1), InspCount, LineCount, HeaderNos);
        PostedCountBefore := BCPTLibrary.CountPostedInspections();
        BCPTTestContext.StartScenario('Post Inspections Bulk');
        BCPTLibrary.PostInspectionBatch(HeaderNos);
        BCPTTestContext.EndScenario('Post Inspections Bulk');
        if BCPTLibrary.CountPostedInspections() < PostedCountBefore + InspCount then
            Error('Not all inspections were posted correctly.');
    end;
}
