namespace MBS.SiteInspection.Posting;

table 50009 "MBS Inspection Journal Line"
{
    Access = Internal;
    Caption = 'Inspection Journal Line';
    DataClassification = CustomerContent;

    fields
    {
        field(10; "Inspection Type No."; Code[20])
        {
            Caption = 'Inspection Type No.';
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(30; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(40; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(50; "Entry Type"; Enum "MBS Inspection Entry Type")
        {
            Caption = 'Entry Type';
        }
        field(60; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(70; "Inspector Resource No."; Code[20])
        {
            Caption = 'Inspector Resource No.';
        }
        field(80; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(90; "Result Summary"; Text[100])
        {
            Caption = 'Result Summary';
        }
        field(100; Priority; Enum "MBS Inspection Priority")
        {
            Caption = 'Priority';
        }
        field(110; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
        }
        field(120; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
        }
        field(130; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
        }
        field(140; Duration; Decimal)
        {
            Caption = 'Duration';
            DecimalPlaces = 0 : 1;
        }
        field(150; "Planned Date"; Date)
        {
            Caption = 'Planned Date';
        }
    }

    keys
    {
        key(PK; "Document No.")
        {
            Clustered = true;
        }
    }
}
