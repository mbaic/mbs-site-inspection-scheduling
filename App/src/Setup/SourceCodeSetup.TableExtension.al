namespace MBS.SiteInspection.Setup;

using Microsoft.Foundation.AuditCodes;

tableextension 50000 "MBS Source Code Setup" extends "Source Code Setup"
{
    fields
    {
        field(50000; "MBS Site Inspection"; Code[10])
        {
            Caption = 'Site Inspection';
            TableRelation = "Source Code".Code;
            DataClassification = CustomerContent;
        }
    }
}
