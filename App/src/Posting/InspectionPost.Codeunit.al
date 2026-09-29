namespace MBS.SiteInspection.Posting;

using MBS.SiteInspection.Inspection;
using MBS.SiteInspection.PostedInspection;
using MBS.SiteInspection.Scheduling;
using MBS.SiteInspection.Setup;
using Microsoft.Foundation.AuditCodes;
using Microsoft.Foundation.NoSeries;

codeunit 50030 "MBS Inspection-Post"
{
    Access = Internal;
    TableNo = "MBS Inspection Header";

    trigger OnRun()
    begin
        ClearAll();
        InspHeader := Rec;

        ValidateHeaderFields();
        CheckLinesExist();

        Window.Open('#1#################################\\' + PostingLinesProgressTxt);
        Window.Update(1, StrSubstNo('%1 %2', InspectionLbl, InspHeader."No."));

        AssignPostingNo();
        InitPosting();
        CreatePostedHeader();

        Window.Update(1, StrSubstNo(InspectionPostedProgressTxt, InspHeader."No.", PstdInspHeader."No."));

        CopyCommentLines(
            InspCommentLine."Table Name"::Inspection,
            InspCommentLine."Table Name"::"Posted Inspection",
            InspHeader."No.",
            PstdInspHeader."No.");

        PostLines();
        PostInspectionJournalLine();
        CleanupSourceDocument();

        Window.Close();
        Rec := InspHeader;
    end;

    var
        InspHeader: Record "MBS Inspection Header";
        InspLine: Record "MBS Inspection Line";
        InspCommentLine: Record "MBS Inspection Comment Line";
        InspCommentLine2: Record "MBS Inspection Comment Line";
        InspJnlLine: Record "MBS Inspection Journal Line";
        PstdInspHeader: Record "MBS Posted Inspection Hdr.";
        PstdInspLine: Record "MBS Posted Inspection Line";
        InspSetup: Record "MBS Inspection Setup";
        SourceCodeSetup: Record "Source Code Setup";
        InspJnlPostLine: Codeunit "MBS Inspection Jnl.-Post Line";
        NoSeriesMgt: Codeunit "No. Series";
        SourceCode: Code[10];
        Window: Dialog;
        LineCount: Integer;
        NoLinesErr: Label 'There are no inspection lines to post.';
        PostingLinesProgressTxt: Label 'Posting lines              #2######\', Comment = '#2 is the line count being posted.';
        InspectionLbl: Label 'Inspection';
        InspectionPostedProgressTxt: Label 'Inspection %1  -> Posted Inspection %2', Comment = '%1 = inspection number, %2 = posted inspection number';

    local procedure ValidateHeaderFields()
    begin
        InspHeader.TestField("Posting Date");
        InspHeader.TestField("Document Date");
        InspHeader.TestField("Inspection Type No.");
        InspHeader.TestField("Customer No.");
        InspHeader.TestField("Inspector Resource No.");
        InspHeader.TestField(Status, InspHeader.Status::Closed);
    end;

    local procedure CheckLinesExist()
    begin
        InspLine.Reset();
        InspLine.SetRange("Document No.", InspHeader."No.");
        if InspLine.IsEmpty() then
            Error(NoLinesErr);
    end;

    local procedure AssignPostingNo()
    begin
        if InspHeader."Posting No." <> '' then
            exit;

        InspHeader.TestField("Posting No. Series");
        InspHeader."Posting No." := NoSeriesMgt.GetNextNo(InspHeader."Posting No. Series", InspHeader."Posting Date");
        InspHeader.Modify(false);
        Commit();
    end;

    local procedure InitPosting()
    begin
        InspLine.ReadIsolation(IsolationLevel::UpdLock);
        SourceCodeSetup.Get();
        SourceCode := SourceCodeSetup."MBS Site Inspection";
    end;

    local procedure CreatePostedHeader()
    begin
        PstdInspHeader.Init();
        PstdInspHeader.TransferFields(InspHeader);
        PstdInspHeader."No." := InspHeader."Posting No.";
        PstdInspHeader."No. Series" := InspHeader."Posting No. Series";
        PstdInspHeader."Pre-Assigned No." := InspHeader."No.";
        PstdInspHeader."Source Code" := SourceCode;
        PstdInspHeader."User Id" := CopyStr(UserId(), 1, 50);
        PstdInspHeader.Insert(false);
    end;

    local procedure CopyCommentLines(FromDocType: Enum "MBS Insp. Comment Table Name"; ToDocType: Enum "MBS Insp. Comment Table Name"; FromNo: Code[20]; ToNo: Code[20])
    begin
        InspCommentLine.Reset();
        InspCommentLine.SetRange("Table Name", FromDocType);
        InspCommentLine.SetRange("No.", FromNo);
        if InspCommentLine.FindSet() then
            repeat
                InspCommentLine2 := InspCommentLine;
                InspCommentLine2."Table Name" := ToDocType;
                InspCommentLine2."No." := ToNo;
                InspCommentLine2.Insert(false);
            until InspCommentLine.Next() = 0;
    end;

    local procedure PostLines()
    begin
        LineCount := 0;
        InspLine.Reset();
        InspLine.SetRange("Document No.", InspHeader."No.");
        if not InspLine.FindSet() then
            exit;

        repeat
            LineCount += 1;
            Window.Update(2, LineCount);
            CreatePostedLine();
        until InspLine.Next() = 0;
    end;

    local procedure CreatePostedLine()
    begin
        PstdInspLine.Init();
        PstdInspLine.TransferFields(InspLine);
        PstdInspLine."Document No." := PstdInspHeader."No.";
        PstdInspLine.Insert(false);
    end;

    local procedure PostInspectionJournalLine()
    begin
        InspJnlLine.Init();
        InspJnlLine."Inspection Type No." := InspHeader."Inspection Type No.";
        InspJnlLine."Posting Date" := InspHeader."Posting Date";
        InspJnlLine."Document Date" := InspHeader."Document Date";
        InspJnlLine."Document No." := PstdInspHeader."No.";
        InspJnlLine."Entry Type" := InspJnlLine."Entry Type"::Inspection;
        InspJnlLine."Customer No." := InspHeader."Customer No.";
        InspJnlLine."Inspector Resource No." := InspHeader."Inspector Resource No.";
        InspJnlLine.Description := CopyStr(InspHeader."Inspection Type Name", 1, 100);
        InspJnlLine."Result Summary" := BuildResultSummary();
        InspJnlLine.Priority := InspHeader.Priority;
        InspJnlLine.Duration := InspHeader.Duration;
        InspJnlLine."Planned Date" := InspHeader."Planned Date";
        InspJnlLine."Source Code" := SourceCode;
        InspJnlLine."Reason Code" := InspHeader."Reason Code";
        InspJnlLine."Posting No. Series" := InspHeader."Posting No. Series";
        InspJnlPostLine.RunWithCheck(InspJnlLine);
    end;

    local procedure BuildResultSummary(): Text[100]
    var
        SatisfactoryCount: Integer;
        UnsatisfactoryCount: Integer;
        TotalCount: Integer;
        ResultLine: Record "MBS Inspection Line";
    begin
        ResultLine.SetRange("Document No.", InspHeader."No.");
        TotalCount := ResultLine.Count();
        ResultLine.SetRange("Result Status", "MBS Inspection Result Status"::Satisfactory);
        SatisfactoryCount := ResultLine.Count();
        ResultLine.SetRange("Result Status", "MBS Inspection Result Status"::Unsatisfactory);
        UnsatisfactoryCount := ResultLine.Count();
        exit(CopyStr(StrSubstNo('%1/%2 satisfactory, %3 issues', SatisfactoryCount, TotalCount, UnsatisfactoryCount), 1, 100));
    end;

    local procedure CleanupSourceDocument()
    begin
        InspLine.Reset();
        InspLine.SetRange("Document No.", InspHeader."No.");
        InspLine.DeleteAll(false);

        InspCommentLine.Reset();
        InspCommentLine.SetRange("Table Name", InspCommentLine."Table Name"::Inspection);
        InspCommentLine.SetRange("No.", InspHeader."No.");
        InspCommentLine.DeleteAll(false);

        InspHeader.Delete(false);
    end;
}
