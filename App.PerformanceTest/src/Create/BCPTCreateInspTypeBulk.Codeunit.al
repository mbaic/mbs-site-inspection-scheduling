namespace MBS.SiteInspection.PerformanceTest;

using MBS.SiteInspection.Inspection;
using System.Tooling;

codeunit 50202 "MBS BCPT Create Insp. Type Blk"
{
    Access = Internal;

    var
        BCPTLibrary: Codeunit "MBS BCPT Library - Inspection";
        BCPTTestContext: Codeunit "BCPT Test Context";

    trigger OnRun()
    var
        FirstTypeNo: Code[20];
        TypeCount: Integer;
    begin
        BCPTLibrary.CreateInspectionSetup();
        TypeCount := BCPTLibrary.GetIntegerParameter(BCPTTestContext.GetParameters(), 'InspectionTypes', 100);
        BCPTTestContext.StartScenario('Create Inspection Types Bulk');
        BCPTLibrary.CreateInspectionTypes(FirstTypeNo, TypeCount);
        BCPTTestContext.EndScenario('Create Inspection Types Bulk');
        if FirstTypeNo = '' then
            Error('Bulk type creation did not produce valid records.');
    end;
}
