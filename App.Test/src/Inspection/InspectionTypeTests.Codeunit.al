namespace MBS.SiteInspection.Test;

using MBS.SiteInspection.Inspection;
using MBS.SiteInspection.Scheduling;
using System.TestLibraries.Utilities;

codeunit 50102 "MBS Inspection Type Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryInspection: Codeunit "MBS Library - Inspection";
        LibraryAssert: Codeunit "Library Assert";

    [Test]
    procedure BlockedInspectionTypeCannotBeScheduledTest()
    var
        InspType: Record "MBS Inspection Type";
        InspHeader: Record "MBS Inspection Header";
    begin
        LibraryInspection.CreateBlockedInspectionType(InspType);
        LibraryInspection.CreateInspectionSetup();
        InspHeader.Init();
        InspHeader.Insert(true);
        asserterror InspHeader.Validate("Inspection Type No.", InspType."No.");
        LibraryAssert.ExpectedError('blocked');
    end;

    [Test]
    procedure InspectionTypeDurationDefaultsToSetupWhenBlankTest()
    var
        InspType: Record "MBS Inspection Type";
    begin
        LibraryInspection.CreateInspectionType(InspType);
        LibraryAssert.AreEqual(1, InspType.Duration, 'Duration should be 1 day by default from library.');
    end;

    [Test]
    procedure InspectionTypeCommentIndicatorUpdatesCorrectlyTest()
    var
        InspType: Record "MBS Inspection Type";
    begin
        LibraryInspection.CreateInspectionType(InspType);
        InspType.CalcFields(Comment);
        LibraryAssert.IsFalse(InspType.Comment, 'Comment should be false initially.');
        LibraryInspection.CreateInspectionCommentLine(
            "MBS Insp. Comment Table Name"::"Inspection Type",
            InspType."No.",
            'Test comment');
        InspType.CalcFields(Comment);
        LibraryAssert.IsTrue(InspType.Comment, 'Comment should be true after adding comment.');
    end;
}
