namespace MBS.SiteInspection.Inspection;

using MBS.SiteInspection.Setup;
using Microsoft.Foundation.NoSeries;

table 50001 "MBS Inspection Type"
{
    Access = Internal;
    Caption = 'Inspection Type';
    DataClassification = CustomerContent;
    DataPerCompany = true;
    DrillDownPageId = "MBS Inspection Type List";
    LookupPageId = "MBS Inspection Type List";

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.';
            ToolTip = 'Specifies the inspection type number.';
        }
        field(20; Name; Text[100])
        {
            Caption = 'Name';
            ToolTip = 'Specifies the name of the inspection type.';

            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then
                    "Search Name" := UpperCase(Name);
            end;
        }
        field(30; Description; Text[250])
        {
            Caption = 'Description';
            ToolTip = 'Specifies a description of the inspection type.';
        }
        field(40; Category; Text[50])
        {
            Caption = 'Category';
            ToolTip = 'Specifies the category of the inspection type, such as Safety, Compliance, or Quality.';
        }
        field(50; Duration; Decimal)
        {
            Caption = 'Duration';
            DecimalPlaces = 0 : 1;
            MinValue = 0;
            ToolTip = 'Specifies the default duration for this inspection type in days.';
        }
        field(60; Blocked; Boolean)
        {
            Caption = 'Blocked';
            ToolTip = 'Specifies whether this inspection type is blocked and cannot be used in new inspections.';
        }
        field(70; "Search Name"; Text[100])
        {
            AllowInCustomizations = Never;
            Caption = 'Search Name';
            ToolTip = 'Specifies the search name.';
        }
        field(80; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
            ToolTip = 'Specifies the date of the last modification.';
        }
        field(90; Comment; Boolean)
        {
            AllowInCustomizations = Never;
            CalcFormula = exist("MBS Inspection Comment Line" where("Table Name" = const("Inspection Type"), "No." = field("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100; "No. Series"; Code[20])
        {
            AllowInCustomizations = Never;
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Name, Category)
        {
        }
        fieldgroup(Brick; "No.", Name, Category)
        {
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            GetSetup();
            InspectionSetup.TestField("Inspection Type Nos.");
            "No." := NoSeries.GetNextNo(InspectionSetup."Inspection Type Nos.", WorkDate());
            "No. Series" := InspectionSetup."Inspection Type Nos.";
        end;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today();
    end;

    trigger OnDelete()
    begin
        InspCommentLine.Reset();
        InspCommentLine.SetRange("Table Name", InspCommentLine."Table Name"::"Inspection Type");
        InspCommentLine.SetRange("No.", "No.");
        InspCommentLine.DeleteAll(false);
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := Today();
    end;

    var
        InspCommentLine: Record "MBS Inspection Comment Line";
        InspectionType: Record "MBS Inspection Type";
        InspectionSetup: Record "MBS Inspection Setup";
        NoSeries: Codeunit "No. Series";
        SetupNotFoundErr: Label 'Inspection Setup not found';

    local procedure GetSetup()
    begin
        if not InspectionSetup.Get() then
            Error(SetupNotFoundErr);
    end;

    procedure AssistEdit(): Boolean
    var
        NoSeriesCode: Code[20];
    begin
        InspectionType := Rec;
        GetSetup();
        InspectionSetup.TestField("Inspection Type Nos.");
        NoSeriesCode := InspectionType."No. Series";
        if NoSeries.LookupRelatedNoSeries(InspectionSetup."Inspection Type Nos.", xRec."No. Series", NoSeriesCode) then begin
            InspectionType."No. Series" := NoSeriesCode;
            InspectionType."No." := NoSeries.GetNextNo(NoSeriesCode, WorkDate());
            Rec := InspectionType;
            exit(true);
        end;
    end;
}
