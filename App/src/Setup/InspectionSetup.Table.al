namespace MBS.SiteInspection.Setup;

using Microsoft.Foundation.NoSeries;

table 50000 "MBS Inspection Setup"
{
    Access = Internal;
    Caption = 'Inspection Setup';
    DataClassification = CustomerContent;
    DataPerCompany = true;

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            AllowInCustomizations = Never;
            Caption = 'Primary Key';
            NotBlank = true;
        }
        field(20; "Inspection Type Nos."; Code[20])
        {
            Caption = 'Inspection Type Nos.';
            TableRelation = "No. Series";
            ToolTip = 'Specifies the number series for inspection type master records.';
        }
        field(30; "Inspection Nos."; Code[20])
        {
            Caption = 'Inspection Nos.';
            TableRelation = "No. Series";
            ToolTip = 'Specifies the number series for inspection documents.';
        }
        field(40; "Posted Inspection Nos."; Code[20])
        {
            Caption = 'Posted Inspection Nos.';
            TableRelation = "No. Series";
            ToolTip = 'Specifies the number series for posted inspections.';
        }
        field(50; "Default Duration"; Decimal)
        {
            Caption = 'Default Duration';
            DecimalPlaces = 0 : 1;
            MinValue = 0;
            ToolTip = 'Specifies the default inspection duration in days.';
        }
        field(60; "Overdue Threshold Days"; Integer)
        {
            Caption = 'Overdue Threshold Days';
            MinValue = 0;
            ToolTip = 'Specifies the number of days past the planned date before an inspection is considered overdue. Zero means overdue as of the planned date.';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
