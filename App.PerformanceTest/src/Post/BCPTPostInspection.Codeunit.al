namespace MBS.SiteInspection.PerformanceTest;

using MBS.SiteInspection.Inspection;
using MBS.SiteInspection.Scheduling;
using MBS.SiteInspection.PostedInspection;
using System.Tooling;

codeunit 50205 "MBS BCPT Post Inspection"
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
        LineCount: Integer;
        PostedCountBefore: Integer;
    begin
        BCPTLibrary.CreateInspectionSetup();
        BCPTLibrary.CreateInspectionType(InspType);
        BCPTLibrary.CreateInspectorPool(InspectorNos, 1);
        BCPTLibrary.CreateTargetEntityPool(CustomerNos, 1);
        LineCount := BCPTLibrary.GetIntegerParameter(BCPTTestContext.GetParameters(), 'Lines', 10);
        BCPTLibrary.CreateReadyToPostInspection(InspType."No.", CustomerNos.Get(1), InspectorNos.Get(1), LineCount, InspHeader);
        PostedCountBefore := BCPTLibrary.CountPostedInspections();
        BCPTTestContext.StartScenario('Post Inspection');
        BCPTLibrary.PostInspection(InspHeader);
        BCPTTestContext.EndScenario('Post Inspection');
        if BCPTLibrary.CountPostedInspections() <= PostedCountBefore then
            Error('Posted inspection count did not increase.');
    end;
}
