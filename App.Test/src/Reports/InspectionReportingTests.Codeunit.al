namespace MBS.SiteInspection.Test;

using MBS.SiteInspection.Scheduling;
using MBS.SiteInspection.Inspection;
using MBS.SiteInspection.Posting;
using MBS.SiteInspection.Ledger;
using Microsoft.Sales.Customer;
using System.TestLibraries.Utilities;

codeunit 50107 "MBS Inspection Reporting Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        LibraryInspection: Codeunit "MBS Library - Inspection";
        LibraryAssert: Codeunit "Library Assert";

    [Test]
    procedure OverdueInspectionViewShowsExpectedBacklogTest()
    var
        InspHeader: Record "MBS Inspection Header";
        OverdueInspHeader: Record "MBS Inspection Header";
    begin
        LibraryInspection.CreateOverdueInspection(InspHeader);
        OverdueInspHeader.SetFilter("Planned Date", '<%1', WorkDate());
        OverdueInspHeader.SetRange(Status, "MBS Inspection Status"::Open);
        OverdueInspHeader.SetRange("No.", InspHeader."No.");
        LibraryAssert.IsTrue(OverdueInspHeader.FindFirst(), 'Overdue inspection should be visible in filtered view.');
    end;

    [Test]
    procedure RepeatedSiteInspectionHistoryCanBeFilteredTest()
    var
        InspType: Record "MBS Inspection Type";
        Customer: Record Customer;
        InspLedgerEntry: Record "MBS Inspection Ledger Entry";
    begin
        LibraryInspection.CreateInspectionType(InspType);
        LibraryInspection.CreateCustomer(Customer);
        LibraryInspection.CreateRepeatedSiteHistory(Customer."No.", InspType."No.", 3);
        InspLedgerEntry.SetRange("Customer No.", Customer."No.");
        LibraryAssert.AreEqual(3, InspLedgerEntry.Count(),
            'Should have 3 ledger entries for repeated-site history.');
    end;

    [Test]
    procedure InspectionHistoryCanBeFilteredByInspectionTypeTest()
    var
        InspType: Record "MBS Inspection Type";
        Customer: Record Customer;
        InspLedgerEntry: Record "MBS Inspection Ledger Entry";
    begin
        LibraryInspection.CreateInspectionType(InspType);
        LibraryInspection.CreateCustomer(Customer);
        LibraryInspection.CreateRepeatedSiteHistory(Customer."No.", InspType."No.", 2);
        InspLedgerEntry.SetRange("Inspection Type No.", InspType."No.");
        LibraryAssert.AreEqual(2, InspLedgerEntry.Count(),
            'Should have 2 ledger entries for the inspection type.');
    end;
}
