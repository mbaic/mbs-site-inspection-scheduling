namespace MBS.SiteInspection.Scheduling;

using MBS.SiteInspection.Posting;

table 50003 "MBS Inspection Line"
{
    Access = Internal;
    Caption = 'Inspection Line';
    DataClassification = CustomerContent;

    fields
    {
        field(10; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "MBS Inspection Header";
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
            ToolTip = 'Specifies the result of this checklist item or finding.';

            trigger OnValidate()
            begin
                if "Result Status" = "Result Status"::Unsatisfactory then
                    TestField(Description);
            end;
        }
        field(50; "Issue Note"; Text[250])
        {
            Caption = 'Issue Note';
            ToolTip = 'Specifies a note about the issue found during inspection.';
        }
        field(60; Severity; Enum "MBS Inspection Priority")
        {
            Caption = 'Severity';
            ToolTip = 'Specifies the severity of the finding.';
        }
        field(70; "Follow-Up Note"; Text[250])
        {
            Caption = 'Follow-Up Note';
            ToolTip = 'Specifies a note about recommended follow-up actions.';
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
