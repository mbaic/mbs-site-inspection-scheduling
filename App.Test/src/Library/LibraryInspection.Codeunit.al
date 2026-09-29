namespace MBS.SiteInspection.Test;

using MBS.SiteInspection.Setup;
using MBS.SiteInspection.Inspection;
using MBS.SiteInspection.Scheduling;
using MBS.SiteInspection.Posting;
using MBS.SiteInspection.PostedInspection;
using MBS.SiteInspection.Ledger;
using Microsoft.Foundation.NoSeries;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Sales.Customer;
using System.TestLibraries.Utilities;

codeunit 50100 "MBS Library - Inspection"
{
    Access = Internal;

    var
        Any: Codeunit Any;

    procedure CreateInspectionSetup()
    var
        InspSetup: Record "MBS Inspection Setup";
    begin
        if not InspSetup.Get() then begin
            InspSetup.Init();
            InspSetup.Insert(true);
        end;
        InspSetup."Inspection Type Nos." := EnsureNoSeries('MB-ITYPE');
        InspSetup."Inspection Nos." := EnsureNoSeries('MB-INSP');
        InspSetup."Posted Inspection Nos." := EnsureNoSeries('MB-PINSP');
        InspSetup."Default Duration" := 1;
        InspSetup."Overdue Threshold Days" := 0;
        InspSetup.Modify(true);
    end;

    local procedure EnsureNoSeries(SeriesCode: Code[20]): Code[20]
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        if not NoSeries.Get(SeriesCode) then begin
            NoSeries.Init();
            NoSeries.Code := SeriesCode;
            NoSeries.Description := SeriesCode;
            NoSeries."Default Nos." := true;
            NoSeries.Insert(true);
        end;

        NoSeriesLine.SetRange("Series Code", SeriesCode);
        if NoSeriesLine.IsEmpty() then begin
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := SeriesCode;
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := SeriesCode + '-0001';
            NoSeriesLine."Ending No." := SeriesCode + '-9999';
            NoSeriesLine."Increment-by No." := 1;
            NoSeriesLine.Insert(true);
        end;
        exit(SeriesCode);
    end;

    procedure CreateInspectionType(var InspType: Record "MBS Inspection Type")
    begin
        CreateInspectionSetup();
        InspType.Init();
        InspType.Insert(true);
        InspType.Name := CopyStr('Test Inspection Type ' + Format(Any.IntegerInRange(1000, 9999)), 1, 100);
        InspType.Category := 'Safety';
        InspType.Duration := 1;
        InspType.Modify(true);
    end;

    procedure CreateBlockedInspectionType(var InspType: Record "MBS Inspection Type")
    begin
        CreateInspectionType(InspType);
        InspType.Blocked := true;
        InspType.Modify(true);
    end;

    procedure CreateInspectorResource(var Resource: Record Resource)
    begin
        Resource.Init();
        Resource."No." := GenerateUniqueCode20();
        Resource.Name := CopyStr('Inspector ' + Format(Any.IntegerInRange(100, 999)), 1, 100);
        Resource.Type := Resource.Type::Person;
        Resource.Insert(true);
    end;

    procedure CreateCustomer(var Customer: Record Customer)
    begin
        Customer.Init();
        Customer."No." := GenerateUniqueCode20();
        Customer.Name := CopyStr('Site Customer ' + Format(Any.IntegerInRange(100, 999)), 1, 100);
        Customer.Address := '123 Test Street';
        Customer.City := 'Test City';
        Customer.Insert(true);
    end;

    procedure CreateInspectionHeader(var InspHeader: Record "MBS Inspection Header")
    var
        InspType: Record "MBS Inspection Type";
        Resource: Record Resource;
        Customer: Record Customer;
    begin
        CreateInspectionSetup();
        CreateInspectionType(InspType);
        CreateInspectorResource(Resource);
        CreateCustomer(Customer);

        InspHeader.Init();
        InspHeader.Insert(true);
        InspHeader.Validate("Inspection Type No.", InspType."No.");
        InspHeader.Validate("Customer No.", Customer."No.");
        InspHeader.Validate("Inspector Resource No.", Resource."No.");
        InspHeader."Planned Date" := WorkDate();
        InspHeader."Posting Date" := WorkDate();
        InspHeader."Document Date" := WorkDate();
        InspHeader.Modify(true);
    end;

    procedure CreateInspectionLine(var InspLine: Record "MBS Inspection Line"; DocumentNo: Code[20]; LineNo: Integer)
    begin
        InspLine.Init();
        InspLine."Document No." := DocumentNo;
        InspLine."Line No." := LineNo;
        InspLine.Description := CopyStr('Checklist Item ' + Format(LineNo), 1, 100);
        InspLine."Result Status" := "MBS Inspection Result Status"::Satisfactory;
        InspLine.Insert(true);
    end;

    procedure CreateInspectionWithLines(var InspHeader: Record "MBS Inspection Header"; LineCount: Integer)
    var
        InspLine: Record "MBS Inspection Line";
        i: Integer;
    begin
        CreateInspectionHeader(InspHeader);
        for i := 1 to LineCount do
            CreateInspectionLine(InspLine, InspHeader."No.", i * 10000);
    end;

    procedure CreateReadyToPostInspection(var InspHeader: Record "MBS Inspection Header")
    begin
        CreateInspectionWithLines(InspHeader, 3);
        InspHeader.Status := "MBS Inspection Status"::Closed;
        InspHeader.Modify(true);
    end;

    procedure CreateInspectionCommentLine(TableName: Enum "MBS Insp. Comment Table Name"; No: Code[20]; CommentText: Text[80])
    var
        InspCommentLine: Record "MBS Inspection Comment Line";
        NextLineNo: Integer;
    begin
        InspCommentLine.SetRange("Table Name", TableName);
        InspCommentLine.SetRange("No.", No);
        if InspCommentLine.FindLast() then
            NextLineNo := InspCommentLine."Line No." + 10000
        else
            NextLineNo := 10000;

        InspCommentLine.Init();
        InspCommentLine."Table Name" := TableName;
        InspCommentLine."No." := No;
        InspCommentLine."Line No." := NextLineNo;
        InspCommentLine.Date := WorkDate();
        InspCommentLine.Comment := CommentText;
        InspCommentLine.Insert(true);
    end;

    procedure PostInspection(var InspHeader: Record "MBS Inspection Header")
    var
        InspPost: Codeunit "MBS Inspection-Post";
    begin
        InspPost.Run(InspHeader);
    end;

    procedure PostAndGetPostedInspection(var InspHeader: Record "MBS Inspection Header"; var PstdInspHeader: Record "MBS Posted Inspection Hdr.")
    var
        PostingNo: Code[20];
    begin
        PostingNo := InspHeader."Posting No.";
        if PostingNo = '' then begin
            PostInspection(InspHeader);
            PstdInspHeader.SetRange("Pre-Assigned No.", InspHeader."No.");
            PstdInspHeader.FindFirst();
        end else begin
            PostInspection(InspHeader);
            PstdInspHeader.Get(PostingNo);
        end;
    end;

    procedure FindPostedInspectionHeader(PreAssignedNo: Code[20]; var PstdInspHeader: Record "MBS Posted Inspection Hdr."): Boolean
    begin
        PstdInspHeader.SetRange("Pre-Assigned No.", PreAssignedNo);
        exit(PstdInspHeader.FindFirst());
    end;

    procedure FindPostedInspectionLine(DocumentNo: Code[20]; var PstdInspLine: Record "MBS Posted Inspection Line"): Boolean
    begin
        PstdInspLine.SetRange("Document No.", DocumentNo);
        exit(PstdInspLine.FindSet());
    end;

    procedure FindInspectionLedgerEntry(DocumentNo: Code[20]; var InspLedgerEntry: Record "MBS Inspection Ledger Entry"): Boolean
    begin
        InspLedgerEntry.SetRange("Document No.", DocumentNo);
        exit(InspLedgerEntry.FindFirst());
    end;

    procedure FindInspectionRegister(var InspRegister: Record "MBS Inspection Register"): Boolean
    begin
        exit(InspRegister.FindLast());
    end;

    procedure CreateOverdueInspection(var InspHeader: Record "MBS Inspection Header")
    begin
        CreateInspectionWithLines(InspHeader, 2);
        InspHeader."Planned Date" := CalcDate('<-30D>', WorkDate());
        InspHeader.Status := "MBS Inspection Status"::Open;
        InspHeader.Modify(true);
    end;

    procedure CreateRepeatedSiteHistory(CustomerNo: Code[20]; InspTypeNo: Code[20]; Count: Integer)
    var
        InspHeader: Record "MBS Inspection Header";
        InspLine: Record "MBS Inspection Line";
        Resource: Record Resource;
        i: Integer;
    begin
        for i := 1 to Count do begin
            CreateInspectionSetup();
            InspHeader.Init();
            InspHeader.Insert(true);
            InspHeader.Validate("Inspection Type No.", InspTypeNo);
            InspHeader.Validate("Customer No.", CustomerNo);
            InspHeader."Planned Date" := CalcDate(StrSubstNo('<-%1M>', i), WorkDate());
            InspHeader."Posting Date" := InspHeader."Planned Date";
            InspHeader."Document Date" := InspHeader."Planned Date";

            CreateInspectorResource(Resource);
            InspHeader.Validate("Inspector Resource No.", Resource."No.");

            InspHeader.Status := "MBS Inspection Status"::Closed;
            InspHeader.Modify(true);

            CreateInspectionLine(InspLine, InspHeader."No.", 10000);
            PostInspection(InspHeader);
        end;
    end;

    local procedure GenerateUniqueCode20(): Code[20]
    var
        GuidText: Text;
    begin
        GuidText := DelChr(Format(Any.GuidValue()), '=', '{}-');
        exit(CopyStr(GuidText, 1, 20));
    end;
}
