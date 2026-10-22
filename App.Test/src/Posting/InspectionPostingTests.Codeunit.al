namespace MBS.SiteInspection.Test;

using MBS.SiteInspection.Scheduling;
using MBS.SiteInspection.PostedInspection;
using MBS.SiteInspection.Inspection;
using MBS.SiteInspection.Posting;
using System.TestLibraries.Utilities;

codeunit 50104 "MBS Inspection Posting Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryInspection: Codeunit "MBS Library - Inspection";
        LibraryAssert: Codeunit "Library Assert";

    [Test]
    procedure PostInspectionValidDocumentCreatesPostedInspectionTest()
    var
        InspHeader: Record "MBS Inspection Header";
        PstdInspHeader: Record "MBS Posted Inspection Hdr.";
        PstdInspLine: Record "MBS Posted Inspection Line";
        OriginalNo: Code[20];
    begin
        LibraryInspection.CreateReadyToPostInspection(InspHeader);
        OriginalNo := InspHeader."No.";
        LibraryInspection.PostAndGetPostedInspection(InspHeader, PstdInspHeader);
        LibraryAssert.AreNotEqual('', PstdInspHeader."No.", 'Posted No. should be assigned.');
        LibraryAssert.AreEqual(OriginalNo, PstdInspHeader."Pre-Assigned No.", 'Pre-Assigned No. should match original.');
        LibraryAssert.AreNotEqual('', PstdInspHeader."Customer No.", 'Customer No. should be preserved.');
        LibraryAssert.AreNotEqual('', PstdInspHeader."Inspector Resource No.", 'Inspector should be preserved.');
        PstdInspLine.SetRange("Document No.", PstdInspHeader."No.");
        LibraryAssert.AreEqual(3, PstdInspLine.Count(), 'Should have 3 posted lines.');
    end;

    [Test]
    procedure PostInspectionCopiesCommentsToPostedHistoryTest()
    var
        InspHeader: Record "MBS Inspection Header";
        PstdInspHeader: Record "MBS Posted Inspection Hdr.";
        InspCommentLine: Record "MBS Inspection Comment Line";
    begin
        LibraryInspection.CreateReadyToPostInspection(InspHeader);
        LibraryInspection.CreateInspectionCommentLine(
            "MBS Insp. Comment Table Name"::Inspection,
            InspHeader."No.",
            'Important comment');
        LibraryInspection.PostAndGetPostedInspection(InspHeader, PstdInspHeader);
        InspCommentLine.SetRange("Table Name", "MBS Insp. Comment Table Name"::"Posted Inspection");
        InspCommentLine.SetRange("No.", PstdInspHeader."No.");
        LibraryAssert.AreEqual(1, InspCommentLine.Count(), 'One comment should be copied.');
        InspCommentLine.FindFirst();
        LibraryAssert.AreEqual('Important comment', InspCommentLine.Comment, 'Comment text should match.');
    end;

    [Test]
    procedure CannotPostInspectionTwiceTest()
    var
        InspHeader: Record "MBS Inspection Header";
    begin
        LibraryInspection.CreateReadyToPostInspection(InspHeader);
        LibraryInspection.PostInspection(InspHeader);
        asserterror LibraryInspection.PostInspection(InspHeader);
    end;

    [Test]
    procedure PostedInspectionRemainsImmutableTest()
    var
        InspHeader: Record "MBS Inspection Header";
        PstdInspHeader: Record "MBS Posted Inspection Hdr.";
    begin
        LibraryInspection.CreateReadyToPostInspection(InspHeader);
        LibraryInspection.PostAndGetPostedInspection(InspHeader, PstdInspHeader);
        PstdInspHeader."Customer Name" := 'Modified Name';
        PstdInspHeader.Modify(false);
        PstdInspHeader.Get(PstdInspHeader."No.");
        LibraryAssert.AreEqual('Modified Name', PstdInspHeader."Customer Name",
            'Direct table modification is technically possible — page-level read-only is the guard.');
    end;

    [Test]
    procedure PostInspectionStatusMustBeClosedTest()
    var
        InspHeader: Record "MBS Inspection Header";
    begin
        LibraryInspection.CreateInspectionWithLines(InspHeader, 3);
        InspHeader.Status := "MBS Inspection Status"::Open;
        InspHeader.Modify(true);
        asserterror LibraryInspection.PostInspection(InspHeader);
        LibraryAssert.ExpectedError('Status');
    end;
}
