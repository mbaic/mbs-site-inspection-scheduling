namespace MBS.SiteInspection.Ledger;

using MBS.SiteInspection.Posting;

table 50007 "MBS Inspection Ledger Entry"
{
    Access = Internal;
    Caption = 'Inspection Ledger Entry';
    DataClassification = CustomerContent;
    DrillDownPageId = "MBS Inspection Ledger Entries";
    LookupPageId = "MBS Inspection Ledger Entries";

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(20; "Inspection Type No."; Code[20])
        {
            Caption = 'Inspection Type No.';
            ToolTip = 'Specifies the inspection type.';
        }
        field(30; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            ToolTip = 'Specifies the customer.';
        }
        field(40; "Inspector Resource No."; Code[20])
        {
            Caption = 'Inspector Resource No.';
            ToolTip = 'Specifies the inspector.';
        }
        field(50; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ToolTip = 'Specifies the posting date.';
        }
        field(60; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            ToolTip = 'Specifies the posted inspection document number.';
        }
        field(70; Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Specifies a description of the inspection.';
        }
        field(80; "Result Summary"; Text[100])
        {
            Caption = 'Result Summary';
            ToolTip = 'Specifies a summary of the inspection result.';
        }
        field(90; "Entry Type"; Enum "MBS Inspection Entry Type")
        {
            Caption = 'Entry Type';
            ToolTip = 'Specifies the entry type.';
        }
        field(100; Priority; Enum "MBS Inspection Priority")
        {
            Caption = 'Priority';
            ToolTip = 'Specifies the inspection priority.';
        }
        field(110; Duration; Decimal)
        {
            Caption = 'Duration';
            DecimalPlaces = 0 : 1;
            ToolTip = 'Specifies the duration.';
        }
        field(120; "Planned Date"; Date)
        {
            Caption = 'Planned Date';
            ToolTip = 'Specifies the planned date.';
        }
        field(130; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
        }
        field(140; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
        }
        field(150; "User Id"; Code[50])
        {
            Caption = 'User Id';
            DataClassification = EndUserIdentifiableInformation;
            ToolTip = 'Specifies the user who posted.';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(DocumentNo; "Document No.")
        {
        }
        key(Customer; "Customer No.", "Posting Date")
        {
        }
        key(InspType; "Inspection Type No.", "Posting Date")
        {
        }
        key(Inspector; "Inspector Resource No.", "Posting Date")
        {
        }
    }
}
