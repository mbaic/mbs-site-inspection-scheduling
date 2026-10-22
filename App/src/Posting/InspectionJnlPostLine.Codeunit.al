namespace MBS.SiteInspection.Posting;

using MBS.SiteInspection.Ledger;

codeunit 50033 "MBS Inspection Jnl.-Post Line"
{
    Access = Internal;
    TableNo = "MBS Inspection Journal Line";

    trigger OnRun()
    begin
        RunWithCheck(Rec);
    end;

    var
        InspLedgerEntry: Record "MBS Inspection Ledger Entry";
        InspRegister: Record "MBS Inspection Register";
        InspJnlCheckLine: Codeunit "MBS Inspection Jnl.-Check Line";
        NextEntryNo: Integer;
        NextRegisterNo: Integer;

    procedure RunWithCheck(var InspJnlLine: Record "MBS Inspection Journal Line")
    begin
        InspJnlCheckLine.RunCheck(InspJnlLine);
        GetNextEntryNo();
        InsertLedgerEntry(InspJnlLine);
        UpdateRegister(InspJnlLine);
    end;

    local procedure GetNextEntryNo()
    begin
        if NextEntryNo = 0 then begin
            InspLedgerEntry.LockTable();
            if InspLedgerEntry.FindLast() then
                NextEntryNo := InspLedgerEntry."Entry No.";
        end;
        NextEntryNo += 1;
    end;

    local procedure InsertLedgerEntry(var InspJnlLine: Record "MBS Inspection Journal Line")
    begin
        InspLedgerEntry.Init();
        InspLedgerEntry."Entry No." := NextEntryNo;
        InspLedgerEntry."Inspection Type No." := InspJnlLine."Inspection Type No.";
        InspLedgerEntry."Customer No." := InspJnlLine."Customer No.";
        InspLedgerEntry."Inspector Resource No." := InspJnlLine."Inspector Resource No.";
        InspLedgerEntry."Posting Date" := InspJnlLine."Posting Date";
        InspLedgerEntry."Document No." := InspJnlLine."Document No.";
        InspLedgerEntry.Description := InspJnlLine.Description;
        InspLedgerEntry."Result Summary" := InspJnlLine."Result Summary";
        InspLedgerEntry."Entry Type" := InspJnlLine."Entry Type";
        InspLedgerEntry.Priority := InspJnlLine.Priority;
        InspLedgerEntry.Duration := InspJnlLine.Duration;
        InspLedgerEntry."Planned Date" := InspJnlLine."Planned Date";
        InspLedgerEntry."Source Code" := InspJnlLine."Source Code";
        InspLedgerEntry."Reason Code" := InspJnlLine."Reason Code";
        InspLedgerEntry."User Id" := CopyStr(UserId(), 1, 50);
        InspLedgerEntry.Insert(true);
    end;

    local procedure UpdateRegister(var InspJnlLine: Record "MBS Inspection Journal Line")
    begin
        if NextRegisterNo = 0 then begin
            InspRegister.LockTable();
            if InspRegister.FindLast() then
                NextRegisterNo := InspRegister."No." + 1
            else
                NextRegisterNo := 1;

            InspRegister.Init();
            InspRegister."No." := NextRegisterNo;
            InspRegister."From Entry No." := NextEntryNo;
            InspRegister."To Entry No." := NextEntryNo;
            InspRegister."Creation Date" := Today();
            InspRegister."Source Code" := InspJnlLine."Source Code";
            InspRegister."User Id" := CopyStr(UserId(), 1, 50);
            InspRegister.Insert(true);
        end else begin
            InspRegister."To Entry No." := NextEntryNo;
            InspRegister.Modify(true);
        end;
    end;
}
