namespace MBS.SiteInspection.Posting;

codeunit 50032 "MBS Inspection Jnl.-Check Line"
{
    Access = Internal;
    TableNo = "MBS Inspection Journal Line";

    trigger OnRun()
    begin
        RunCheck(Rec);
    end;

    procedure RunCheck(var InspJnlLine: Record "MBS Inspection Journal Line")
    begin
        InspJnlLine.TestField("Posting Date");
        InspJnlLine.TestField("Document No.");
        InspJnlLine.TestField("Inspection Type No.");
    end;
}
