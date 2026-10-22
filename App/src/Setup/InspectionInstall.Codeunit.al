namespace MBS.SiteInspection.Setup;

using Microsoft.Foundation.AuditCodes;

codeunit 50034 "MBS Inspection Install"
{
    Subtype = Install;
    Access = Internal;

    trigger OnInstallAppPerCompany()
    begin
        InsertSourceCode();
    end;

    local procedure InsertSourceCode()
    var
        SourceCode: Record "Source Code";
        SourceCodeSetup: Record "Source Code Setup";
        SourceCodeCodeTok: Label 'MBSINSP', Locked = true;
        SourceCodeDescTxt: Label 'Site Inspection Posting';
    begin
        if not SourceCode.Get(SourceCodeCodeTok) then begin
            SourceCode.Init();
            SourceCode.Code := SourceCodeCodeTok;
            SourceCode.Description := CopyStr(SourceCodeDescTxt, 1, MaxStrLen(SourceCode.Description));
            SourceCode.Insert(false);
        end;

        SourceCodeSetup.Get();
        if SourceCodeSetup."MBS Site Inspection" <> SourceCodeCodeTok then begin
            SourceCodeSetup."MBS Site Inspection" := SourceCodeCodeTok;
            SourceCodeSetup.Modify(false);
        end;
    end;
}
