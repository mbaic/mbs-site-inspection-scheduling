namespace MBS.SiteInspection.Ledger;

table 50008 "MBS Inspection Register"
{
    Access = Internal;
    Caption = 'Inspection Register';
    DataClassification = CustomerContent;
    DrillDownPageId = "MBS Inspection Registers";
    LookupPageId = "MBS Inspection Registers";

    fields
    {
        field(10; "No."; Integer)
        {
            Caption = 'No.';
        }
        field(20; "From Entry No."; Integer)
        {
            Caption = 'From Entry No.';
            TableRelation = "MBS Inspection Ledger Entry";
            ToolTip = 'Specifies the first ledger entry number in this register.';
        }
        field(30; "To Entry No."; Integer)
        {
            Caption = 'To Entry No.';
            TableRelation = "MBS Inspection Ledger Entry";
            ToolTip = 'Specifies the last ledger entry number in this register.';
        }
        field(40; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            ToolTip = 'Specifies when this register was created.';
        }
        field(50; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            ToolTip = 'Specifies the source code.';
        }
        field(60; "User Id"; Code[50])
        {
            Caption = 'User Id';
            DataClassification = EndUserIdentifiableInformation;
            ToolTip = 'Specifies the user who created this register.';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
