namespace MBS.SiteInspection.PerformanceTest;

using MBS.SiteInspection.Setup;
using MBS.SiteInspection.Inspection;
using MBS.SiteInspection.Scheduling;
using MBS.SiteInspection.Posting;
using MBS.SiteInspection.PostedInspection;
using MBS.SiteInspection.Ledger;
using Microsoft.Foundation.NoSeries;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Sales.Customer;

codeunit 50200 "MBS BCPT Library - Inspection"
{
    Access = Internal;

    procedure CreateInspectionSetup()
    var
        InspSetup: Record "MBS Inspection Setup";
    begin
        if InspSetup.Get() then
            exit;
        InspSetup.Init();
        InspSetup.Insert(true);
        InspSetup."Inspection Type Nos." := EnsureNoSeries('BCPT-ITYPE', 'BCPT-ITYPE-0001', 'BCPT-ITYPE-9999');
        InspSetup."Inspection Nos." := EnsureNoSeries('BCPT-INSP', 'BCPT-INSP-00001', 'BCPT-INSP-99999');
        InspSetup."Posted Inspection Nos." := EnsureNoSeries('BCPT-PINSP', 'BCPT-PINSP-00001', 'BCPT-PINSP-99999');
        InspSetup."Default Duration" := 1;
        InspSetup.Modify(true);
    end;

    local procedure EnsureNoSeries(SeriesCode: Code[20]; StartNo: Code[20]; EndNo: Code[20]): Code[20]
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
            NoSeriesLine."Starting No." := StartNo;
            NoSeriesLine."Ending No." := EndNo;
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
        InspType.Name := CopyStr('BCPT Type ' + InspType."No.", 1, 100);
        InspType.Category := 'Performance';
        InspType.Duration := 1;
        InspType.Modify(true);
    end;

    procedure CreateInspectionTypes(var FirstTypeNo: Code[20]; Count: Integer)
    var
        InspType: Record "MBS Inspection Type";
        i: Integer;
    begin
        for i := 1 to Count do begin
            CreateInspectionType(InspType);
            if i = 1 then
                FirstTypeNo := InspType."No.";
        end;
    end;

    procedure CreateInspectorPool(var InspectorNos: List of [Code[20]]; Count: Integer)
    var
        Resource: Record Resource;
        i: Integer;
    begin
        for i := 1 to Count do begin
            Resource.Init();
            Resource."No." := CopyStr('BCPT-INSP-' + Format(i, 4, '<Integer,4><Filler Character,0>'), 1, 20);
            Resource.Type := Resource.Type::Person;
            Resource.Name := CopyStr('BCPT Inspector ' + Format(i), 1, 100);
            if not Resource.Get(Resource."No.") then
                Resource.Insert(true);
            InspectorNos.Add(Resource."No.");
        end;
    end;

    procedure CreateTargetEntityPool(var CustomerNos: List of [Code[20]]; Count: Integer)
    var
        Customer: Record Customer;
        i: Integer;
    begin
        for i := 1 to Count do begin
            Customer.Init();
            Customer."No." := CopyStr('BCPT-CUST-' + Format(i, 4, '<Integer,4><Filler Character,0>'), 1, 20);
            Customer.Name := CopyStr('BCPT Site ' + Format(i), 1, 100);
            Customer.Address := 'BCPT Address';
            Customer.City := 'BCPT City';
            if not Customer.Get(Customer."No.") then
                Customer.Insert(true);
            CustomerNos.Add(Customer."No.");
        end;
    end;

    procedure CreateInspection(InspTypeNo: Code[20]; CustomerNo: Code[20]; InspectorNo: Code[20]; LineCount: Integer; var InspHeader: Record "MBS Inspection Header")
    var
        InspLine: Record "MBS Inspection Line";
        i: Integer;
    begin
        CreateInspectionSetup();
        InspHeader.Init();
        InspHeader.Insert(true);
        InspHeader.Validate("Inspection Type No.", InspTypeNo);
        InspHeader.Validate("Customer No.", CustomerNo);
        InspHeader.Validate("Inspector Resource No.", InspectorNo);
        InspHeader."Planned Date" := WorkDate();
        InspHeader."Posting Date" := WorkDate();
        InspHeader."Document Date" := WorkDate();
        InspHeader.Modify(true);

        for i := 1 to LineCount do begin
            InspLine.Init();
            InspLine."Document No." := InspHeader."No.";
            InspLine."Line No." := i * 10000;
            InspLine.Description := CopyStr('BCPT Checklist Item ' + Format(i), 1, 100);
            InspLine."Result Status" := "MBS Inspection Result Status"::Satisfactory;
            InspLine.Insert(true);
        end;
    end;

    procedure CreateReadyToPostInspection(InspTypeNo: Code[20]; CustomerNo: Code[20]; InspectorNo: Code[20]; LineCount: Integer; var InspHeader: Record "MBS Inspection Header")
    begin
        CreateInspection(InspTypeNo, CustomerNo, InspectorNo, LineCount, InspHeader);
        InspHeader.Status := "MBS Inspection Status"::Closed;
        InspHeader.Modify(true);
    end;

    procedure CreateReadyToPostInspectionBatch(InspTypeNo: Code[20]; CustomerNo: Code[20]; InspectorNo: Code[20]; InspCount: Integer; LineCount: Integer; var HeaderNos: List of [Code[20]])
    var
        InspHeader: Record "MBS Inspection Header";
        i: Integer;
    begin
        for i := 1 to InspCount do begin
            CreateReadyToPostInspection(InspTypeNo, CustomerNo, InspectorNo, LineCount, InspHeader);
            HeaderNos.Add(InspHeader."No.");
        end;
    end;

    procedure PostInspection(var InspHeader: Record "MBS Inspection Header")
    var
        InspPost: Codeunit "MBS Inspection-Post";
    begin
        InspPost.Run(InspHeader);
    end;

    procedure PostInspectionBatch(var HeaderNos: List of [Code[20]])
    var
        InspHeader: Record "MBS Inspection Header";
        HeaderNo: Code[20];
    begin
        foreach HeaderNo in HeaderNos do begin
            InspHeader.Get(HeaderNo);
            PostInspection(InspHeader);
        end;
    end;

    procedure SeedOverdueBacklog(InspTypeNo: Code[20]; CustomerNo: Code[20]; InspectorNo: Code[20]; Count: Integer)
    var
        InspHeader: Record "MBS Inspection Header";
        i: Integer;
    begin
        for i := 1 to Count do begin
            CreateInspection(InspTypeNo, CustomerNo, InspectorNo, 3, InspHeader);
            InspHeader."Planned Date" := CalcDate(StrSubstNo('<-%1D>', i), WorkDate());
            InspHeader.Status := "MBS Inspection Status"::Open;
            InspHeader.Modify(true);
        end;
    end;

    procedure SeedRepeatedSiteHistory(InspTypeNo: Code[20]; CustomerNo: Code[20]; InspectorNo: Code[20]; Count: Integer)
    var
        InspHeader: Record "MBS Inspection Header";
        i: Integer;
    begin
        for i := 1 to Count do begin
            CreateReadyToPostInspection(InspTypeNo, CustomerNo, InspectorNo, 5, InspHeader);
            InspHeader."Planned Date" := CalcDate(StrSubstNo('<-%1M>', i), WorkDate());
            InspHeader."Posting Date" := InspHeader."Planned Date";
            InspHeader.Modify(true);
            PostInspection(InspHeader);
        end;
    end;

    procedure GetIntegerParameter(ParamString: Text; ParamName: Text; DefaultValue: Integer): Integer
    var
        Pos: Integer;
        ValueText: Text;
        EndPos: Integer;
        Result: Integer;
    begin
        Pos := StrPos(ParamString, ParamName + '=');
        if Pos = 0 then
            exit(DefaultValue);

        ValueText := CopyStr(ParamString, Pos + StrLen(ParamName) + 1);
        EndPos := StrPos(ValueText, ',');
        if EndPos > 0 then
            ValueText := CopyStr(ValueText, 1, EndPos - 1);

        if Evaluate(Result, ValueText) then
            exit(Result);
        exit(DefaultValue);
    end;

    procedure CountInspectionLedgerEntries(DocumentNo: Code[20]): Integer
    var
        InspLedgerEntry: Record "MBS Inspection Ledger Entry";
    begin
        InspLedgerEntry.SetRange("Document No.", DocumentNo);
        exit(InspLedgerEntry.Count());
    end;

    procedure CountPostedInspections(): Integer
    var
        PstdInspHeader: Record "MBS Posted Inspection Hdr.";
    begin
        exit(PstdInspHeader.Count());
    end;
}
