namespace MBS.SiteInspection.Test;

using MBS.SiteInspection.Scheduling;
using MBS.SiteInspection.PostedInspection;
using MBS.SiteInspection.Ledger;
using System.TestLibraries.Utilities;

codeunit 50105 "MBS Inspection Ledger Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryInspection: Codeunit "MBS Library - Inspection";
        LibraryAssert: Codeunit "Library Assert";

    [Test]
    procedure PostInspectionCreatesInspectionLedgerEntriesTest()
    var
        InspHeader: Record "MBS Inspection Header";
        PstdInspHeader: Record "MBS Posted Inspection Hdr.";
        InspLedgerEntry: Record "MBS Inspection Ledger Entry";
    begin
        LibraryInspection.CreateReadyToPostInspection(InspHeader);
        LibraryInspection.PostAndGetPostedInspection(InspHeader, PstdInspHeader);
        LibraryAssert.IsTrue(
            LibraryInspection.FindInspectionLedgerEntry(PstdInspHeader."No.", InspLedgerEntry),
            'Ledger entry should exist.');
        LibraryAssert.AreEqual(PstdInspHeader."Inspection Type No.", InspLedgerEntry."Inspection Type No.",
            'Inspection Type should match.');
        LibraryAssert.AreEqual(PstdInspHeader."Customer No.", InspLedgerEntry."Customer No.",
            'Customer should match.');
        LibraryAssert.AreEqual(PstdInspHeader."Inspector Resource No.", InspLedgerEntry."Inspector Resource No.",
            'Inspector should match.');
    end;

    [Test]
    procedure PostInspectionCreatesInspectionRegisterEntryTest()
    var
        InspHeader: Record "MBS Inspection Header";
        InspRegister: Record "MBS Inspection Register";
        PstdInspHeader: Record "MBS Posted Inspection Hdr.";
    begin
        LibraryInspection.CreateReadyToPostInspection(InspHeader);
        LibraryInspection.PostAndGetPostedInspection(InspHeader, PstdInspHeader);
        LibraryAssert.IsTrue(
            LibraryInspection.FindInspectionRegister(InspRegister),
            'Register should exist.');
        LibraryAssert.IsTrue(InspRegister."From Entry No." > 0, 'From Entry No. should be positive.');
        LibraryAssert.IsTrue(InspRegister."To Entry No." >= InspRegister."From Entry No.",
            'To Entry No. should be >= From Entry No.');
    end;

    [Test]
    procedure LedgerEntryTraceableToPostedInspectionTest()
    var
        InspHeader: Record "MBS Inspection Header";
        PstdInspHeader: Record "MBS Posted Inspection Hdr.";
        InspLedgerEntry: Record "MBS Inspection Ledger Entry";
    begin
        LibraryInspection.CreateReadyToPostInspection(InspHeader);
        LibraryInspection.PostAndGetPostedInspection(InspHeader, PstdInspHeader);
        LibraryInspection.FindInspectionLedgerEntry(PstdInspHeader."No.", InspLedgerEntry);
        LibraryAssert.AreEqual(PstdInspHeader."No.", InspLedgerEntry."Document No.",
            'Document No. should match posted inspection.');
    end;
}
