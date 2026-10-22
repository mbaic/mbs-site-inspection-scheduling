namespace MBS.SiteInspection.PostedInspection;

using MBS.SiteInspection.Posting;

table 50006 "MBS Posted Inspection Line"
{
    Access = Internal;
    Caption = 'Posted Inspection Line';
    DataClassification = CustomerContent;

    fields
    {
        field(10; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "MBS Posted Inspection Hdr.";
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(30; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies the checklist item or finding description.';
        }
        field(40; "Result Status"; Enum "MBS Inspection Result Status")
        {
            Caption = 'Result Status';
            ToolTip = 'Specifies the result of this checklist item.';
        }
        field(50; "Issue Note"; Text[250])
        {
            Caption = 'Issue Note';
            ToolTip = 'Specifies the issue note.';
        }
        field(60; Severity; Enum "MBS Inspection Priority")
        {
            Caption = 'Severity';
            ToolTip = 'Specifies the severity of the finding.';
        }
        field(70; "Follow-Up Note"; Text[250])
        {
            Caption = 'Follow-Up Note';
            ToolTip = 'Specifies the follow-up note.';
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
