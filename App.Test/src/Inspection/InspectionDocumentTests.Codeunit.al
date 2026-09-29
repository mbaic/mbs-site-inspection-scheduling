namespace MBS.SiteInspection.Test;

using MBS.SiteInspection.Scheduling;
using MBS.SiteInspection.Posting;
using System.TestLibraries.Utilities;

codeunit 50103 "MBS Inspection Document Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryInspection: Codeunit "MBS Library - Inspection";
        LibraryAssert: Codeunit "Library Assert";

    [Test]
    procedure InspectionWithoutCustomerThrowsErrorTest()
    var
        InspHeader: Record "MBS Inspection Header";
    begin
        LibraryInspection.CreateReadyToPostInspection(InspHeader);
        InspHeader."Customer No." := '';
        InspHeader."Customer Name" := '';
        InspHeader.Modify(true);
        asserterror LibraryInspection.PostInspection(InspHeader);
        LibraryAssert.ExpectedError('Customer No.');
    end;

    [Test]
    procedure InspectionWithoutInspectorThrowsErrorTest()
    var
        InspHeader: Record "MBS Inspection Header";
    begin
        LibraryInspection.CreateReadyToPostInspection(InspHeader);
        InspHeader."Inspector Resource No." := '';
        InspHeader."Inspector Name" := '';
        InspHeader.Modify(true);
        asserterror LibraryInspection.PostInspection(InspHeader);
        LibraryAssert.ExpectedError('Inspector Resource No.');
    end;

    [Test]
    procedure InspectionWithoutPlannedDateDoesNotBlockPostingTest()
    var
        InspHeader: Record "MBS Inspection Header";
    begin
        LibraryInspection.CreateReadyToPostInspection(InspHeader);
        InspHeader."Planned Date" := 0D;
        InspHeader.Modify(true);
        LibraryInspection.PostInspection(InspHeader);
    end;

    [Test]
    procedure InspectionWithoutPostingDateThrowsErrorTest()
    var
        InspHeader: Record "MBS Inspection Header";
    begin
        LibraryInspection.CreateReadyToPostInspection(InspHeader);
        InspHeader."Posting Date" := 0D;
        InspHeader.Modify(true);
        asserterror LibraryInspection.PostInspection(InspHeader);
        LibraryAssert.ExpectedError('Posting Date');
    end;

    [Test]
    procedure InspectionWithoutRequiredLinesThrowsErrorTest()
    var
        InspHeader: Record "MBS Inspection Header";
        InspLine: Record "MBS Inspection Line";
    begin
        LibraryInspection.CreateReadyToPostInspection(InspHeader);
        InspLine.SetRange("Document No.", InspHeader."No.");
        InspLine.DeleteAll(true);
        asserterror LibraryInspection.PostInspection(InspHeader);
        LibraryAssert.ExpectedError('no inspection lines');
    end;

    [Test]
    procedure InvalidFindingResultCombinationThrowsErrorTest()
    var
        InspLine: Record "MBS Inspection Line";
        InspHeader: Record "MBS Inspection Header";
    begin
        LibraryInspection.CreateInspectionWithLines(InspHeader, 1);
        InspLine.SetRange("Document No.", InspHeader."No.");
        InspLine.FindFirst();
        InspLine.Description := '';
        InspLine.Modify(true);
        asserterror InspLine.Validate("Result Status", "MBS Inspection Result Status"::Unsatisfactory);
        LibraryAssert.ExpectedError('Description');
    end;

    [Test]
    procedure ClosedInspectionCannotBeReopenedByInvalidTransitionTest()
    var
        InspHeader: Record "MBS Inspection Header";
    begin
        LibraryInspection.CreateReadyToPostInspection(InspHeader);
        LibraryInspection.PostInspection(InspHeader);
    end;
}
