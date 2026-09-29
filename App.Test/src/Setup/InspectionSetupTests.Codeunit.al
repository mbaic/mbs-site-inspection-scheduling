namespace MBS.SiteInspection.Test;

using MBS.SiteInspection.Setup;
using MBS.SiteInspection.Inspection;
using MBS.SiteInspection.Scheduling;
using System.TestLibraries.Utilities;

codeunit 50101 "MBS Inspection Setup Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryInspection: Codeunit "MBS Library - Inspection";
        LibraryAssert: Codeunit "Library Assert";

    [Test]
    procedure CreateInspectionSetupInitializesRequiredFieldsTest()
    var
        InspSetup: Record "MBS Inspection Setup";
    begin
        // [SCENARIO] Setup initialization creates a record with required no. series
        InspSetup.DeleteAll();
        LibraryInspection.CreateInspectionSetup();
        LibraryAssert.IsTrue(InspSetup.Get(), 'Setup record should exist.');
        LibraryAssert.AreNotEqual('', InspSetup."Inspection Type Nos.", 'Inspection Type Nos. should be populated.');
        LibraryAssert.AreNotEqual('', InspSetup."Inspection Nos.", 'Inspection Nos. should be populated.');
        LibraryAssert.AreNotEqual('', InspSetup."Posted Inspection Nos.", 'Posted Inspection Nos. should be populated.');
    end;

    [Test]
    procedure CreateInspectionTypeWithoutNoAssignsSeriesNumberTest()
    var
        InspType: Record "MBS Inspection Type";
    begin
        // [SCENARIO] Creating an inspection type without a number assigns from the No. Series
        LibraryInspection.CreateInspectionSetup();
        LibraryInspection.CreateInspectionType(InspType);
        LibraryAssert.AreNotEqual('', InspType."No.", 'No. should be assigned from no. series.');
        LibraryAssert.AreNotEqual('', InspType."No. Series", 'No. Series should be populated.');
    end;

    [Test]
    procedure PostingWithoutRequiredSetupThrowsErrorTest()
    var
        InspSetup: Record "MBS Inspection Setup";
    begin
        // [SCENARIO] Posting without required setup fails
        LibraryInspection.CreateInspectionSetup();
        InspSetup.Get();
        InspSetup."Posted Inspection Nos." := '';
        InspSetup.Modify();
        asserterror CreateHeaderThatRequiresPostingNoSeries();
        LibraryAssert.ExpectedError('Posted Inspection Nos.');
    end;

    local procedure CreateHeaderThatRequiresPostingNoSeries()
    var
        InspHeader: Record "MBS Inspection Header";
    begin
        InspHeader.Init();
        InspHeader.Insert(true);
    end;
}
