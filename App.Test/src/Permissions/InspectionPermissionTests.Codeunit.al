namespace MBS.SiteInspection.Test;

using MBS.SiteInspection.Setup;
using MBS.SiteInspection.Scheduling;
using System.TestLibraries.Utilities;

codeunit 50106 "MBS Inspection Perm. Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryInspection: Codeunit "MBS Library - Inspection";
        LibraryAssert: Codeunit "Library Assert";

    [Test]
    procedure OperationalUserCanProcessStandardInspectionWorkflowTest()
    var
        InspHeader: Record "MBS Inspection Header";
    begin
        LibraryInspection.CreateInspectionSetup();
        LibraryInspection.CreateReadyToPostInspection(InspHeader);
        LibraryInspection.PostInspection(InspHeader);
    end;
}
