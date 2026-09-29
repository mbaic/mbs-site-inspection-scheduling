namespace MBS.SiteInspection.PerformanceTest;

using MBS.SiteInspection.Inspection;
using System.Tooling;

codeunit 50201 "MBS BCPT Create Insp. Type"
{
    Access = Internal;

    var
        BCPTLibrary: Codeunit "MBS BCPT Library - Inspection";
        BCPTTestContext: Codeunit "BCPT Test Context";

    trigger OnRun()
    var
        InspType: Record "MBS Inspection Type";
    begin
        BCPTLibrary.CreateInspectionSetup();
        BCPTTestContext.StartScenario('Create Inspection Type');
        BCPTLibrary.CreateInspectionType(InspType);
        BCPTTestContext.EndScenario('Create Inspection Type');
        if InspType."No." = '' then
            Error('Inspection Type was not created with a valid number.');
    end;
}
