namespace MBS.SiteInspection.Inspection;

table 50004 "MBS Inspection Comment Line"
{
    Access = Internal;
    Caption = 'Inspection Comment Line';
    DataClassification = CustomerContent;
    DrillDownPageId = "MBS Inspection Comment List";
    LookupPageId = "MBS Inspection Comment List";

    fields
    {
        field(10; "Table Name"; Enum "MBS Insp. Comment Table Name")
        {
            Caption = 'Table Name';
        }
        field(20; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(30; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(40; Date; Date)
        {
            Caption = 'Date';
            ToolTip = 'Specifies the date of the comment.';
        }
        field(50; "Code"; Code[10])
        {
            Caption = 'Code';
            ToolTip = 'Specifies a code for the comment.';
        }
        field(60; Comment; Text[80])
        {
            Caption = 'Comment';
            ToolTip = 'Specifies the comment text.';
        }
    }

    keys
    {
        key(PK; "Table Name", "No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
