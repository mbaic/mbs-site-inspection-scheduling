namespace MBS.SiteInspection.Posting;

using MBS.SiteInspection.Scheduling;

codeunit 50031 "MBS Inspection-Post (Yes/No)"
{
    Access = Internal;
    TableNo = "MBS Inspection Header";

    trigger OnRun()
    begin
        InspHeader.Copy(Rec);
        Code();
        Rec := InspHeader;
    end;

    var
        InspHeader: Record "MBS Inspection Header";
        PostConfirmQst: Label 'Do you want to post the inspection?';
        PostedMsg: Label 'The inspection has been posted.';

    local procedure Code()
    var
        InspPost: Codeunit "MBS Inspection-Post";
    begin
        if not Confirm(PostConfirmQst, false) then
            exit;

        InspPost.Run(InspHeader);
        Message(PostedMsg);
    end;
}
