namespace MBS.SiteInspection.PostedInspection;

using MBS.SiteInspection.Inspection;
using MBS.SiteInspection.Posting;
using Microsoft.Foundation.NoSeries;

table 50005 "MBS Posted Inspection Hdr."
{
    Access = Internal;
    Caption = 'Posted Inspection Header';
    DataClassification = CustomerContent;
    DataPerCompany = true;
    LookupPageId = "MBS Posted Inspection List";
    DrillDownPageId = "MBS Posted Inspection List";

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.';
            ToolTip = 'Specifies the posted inspection number.';
        }
        field(20; "Inspection Type No."; Code[20])
        {
            Caption = 'Inspection Type No.';
            ToolTip = 'Specifies the inspection type.';
        }
        field(30; "Inspection Type Name"; Text[100])
        {
            Caption = 'Inspection Type Name';
            ToolTip = 'Specifies the inspection type name.';
        }
        field(40; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            ToolTip = 'Specifies the customer.';
        }
        field(50; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            ToolTip = 'Specifies the customer name.';
        }
        field(60; "Site Address"; Text[100])
        {
            Caption = 'Site Address';
            ToolTip = 'Specifies the site address at time of inspection.';
        }
        field(70; "Site City"; Text[30])
        {
            Caption = 'Site City';
            ToolTip = 'Specifies the site city at time of inspection.';
        }
        field(80; "Inspector Resource No."; Code[20])
        {
            Caption = 'Inspector Resource No.';
            ToolTip = 'Specifies the inspector.';
        }
        field(90; "Inspector Name"; Text[100])
        {
            Caption = 'Inspector Name';
            ToolTip = 'Specifies the inspector name.';
        }
        field(100; "Planned Date"; Date)
        {
            Caption = 'Planned Date';
            ToolTip = 'Specifies the planned date.';
        }
        field(110; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ToolTip = 'Specifies the posting date.';
        }
        field(120; "Document Date"; Date)
        {
            Caption = 'Document Date';
            ToolTip = 'Specifies the document date.';
        }
        field(130; Duration; Decimal)
        {
            Caption = 'Duration';
            DecimalPlaces = 0 : 1;
            ToolTip = 'Specifies the duration.';
        }
        field(140; Status; Enum "MBS Inspection Status")
        {
            Caption = 'Status';
            ToolTip = 'Specifies the status when posted.';
        }
        field(150; Priority; Enum "MBS Inspection Priority")
        {
            Caption = 'Priority';
            ToolTip = 'Specifies the priority.';
        }
        field(160; "No. Series"; Code[20])
        {
            AllowInCustomizations = Never;
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(170; "Source Code"; Code[10])
        {
            AllowInCustomizations = Never;
            Caption = 'Source Code';
        }
        field(180; "User Id"; Code[50])
        {
            Caption = 'User Id';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
            ToolTip = 'Specifies the user who posted the inspection.';
        }
        field(190; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            ToolTip = 'Specifies the reason code.';
        }
        field(200; Comment; Boolean)
        {
            AllowInCustomizations = Never;
            CalcFormula = exist("MBS Inspection Comment Line" where("Table Name" = const("Posted Inspection"), "No." = field("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(210; "Pre-Assigned No."; Code[20])
        {
            Caption = 'Pre-Assigned No.';
            Editable = false;
            ToolTip = 'Specifies the original inspection document number.';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Customer; "Customer No.", "Posting Date")
        {
        }
        key(InspType; "Inspection Type No.", "Posting Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Inspection Type Name", "Customer Name", "Posting Date")
        {
        }
    }
}
