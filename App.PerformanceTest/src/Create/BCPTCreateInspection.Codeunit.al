namespace MBS.SiteInspection.PerformanceTest;

using MBS.SiteInspection.Inspection;
using MBS.SiteInspection.Scheduling;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Sales.Customer;
using System.Tooling;

codeunit 50203 "MBS BCPT Create Inspection"
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
    begin
        BCPTLibrary.CreateInspectionSetup();
        BCPTLibrary.CreateInspectionType(InspType);
        BCPTLibrary.CreateInspectorPool(InspectorNos, 1);
        BCPTLibrary.CreateTargetEntityPool(CustomerNos, 1);
        LineCount := BCPTLibrary.GetIntegerParameter(BCPTTestContext.GetParameters(), 'Lines', 10);
        BCPTTestContext.StartScenario('Create Inspection');
        BCPTLibrary.CreateInspection(InspType."No.", CustomerNos.Get(1), InspectorNos.Get(1), LineCount, InspHeader);
        BCPTTestContext.EndScenario('Create Inspection');
        if InspHeader."No." = '' then
            Error('Inspection was not created.');
    end;
}
