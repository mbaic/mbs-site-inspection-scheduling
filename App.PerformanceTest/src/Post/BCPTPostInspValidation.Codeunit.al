namespace MBS.SiteInspection.PerformanceTest;

using MBS.SiteInspection.Inspection;
using MBS.SiteInspection.Scheduling;
using MBS.SiteInspection.Posting;
using MBS.SiteInspection.PostedInspection;
using System.Tooling;

codeunit 50207 "MBS BCPT Post Insp. Validation"
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
        PostedCountBefore: Integer;
    begin
        BCPTLibrary.CreateInspectionSetup();
        BCPTLibrary.CreateInspectionType(InspType);
        BCPTLibrary.CreateInspectorPool(InspectorNos, 1);
        BCPTLibrary.CreateTargetEntityPool(CustomerNos, 1);
        BCPTLibrary.CreateInspection(InspType."No.", CustomerNos.Get(1), InspectorNos.Get(1), 0, InspHeader);
        InspHeader.Status := "MBS Inspection Status"::Closed;
        InspHeader.Modify(true);
        PostedCountBefore := BCPTLibrary.CountPostedInspections();
        BCPTTestContext.StartScenario('Post Inspection Validation');
        asserterror BCPTLibrary.PostInspection(InspHeader);
        BCPTTestContext.EndScenario('Post Inspection Validation');
        if BCPTLibrary.CountPostedInspections() <> PostedCountBefore then
            Error('Failed posting left partial posted artifacts.');
    end;
}
