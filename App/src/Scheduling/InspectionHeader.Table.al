namespace MBS.SiteInspection.Scheduling;

using MBS.SiteInspection.Inspection;
using MBS.SiteInspection.Posting;
using MBS.SiteInspection.Setup;
using Microsoft.Foundation.NoSeries;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Sales.Customer;

table 50002 "MBS Inspection Header"
{
    Access = Internal;
    Caption = 'Inspection Header';
    DataClassification = CustomerContent;
    DataPerCompany = true;
    LookupPageId = "MBS Inspection List";
    DrillDownPageId = "MBS Inspection List";

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.';
            ToolTip = 'Specifies the inspection document number.';
        }
        field(20; "Inspection Type No."; Code[20])
        {
            Caption = 'Inspection Type No.';
            TableRelation = "MBS Inspection Type";
            ToolTip = 'Specifies the inspection type for this inspection.';

            trigger OnValidate()
            var
                InspectionType: Record "MBS Inspection Type";
            begin
                if "Inspection Type No." <> '' then begin
                    InspectionType.Get("Inspection Type No.");
                    if InspectionType.Blocked then
                        Error(BlockedInspTypeErr, "Inspection Type No.");
                    "Inspection Type Name" := InspectionType.Name;
                    if Duration = 0 then
                        Duration := InspectionType.Duration;
                end else begin
                    "Inspection Type Name" := '';
                    Duration := 0;
                end;
            end;
        }
        field(30; "Inspection Type Name"; Text[100])
        {
            Caption = 'Inspection Type Name';
            Editable = false;
            ToolTip = 'Specifies the name of the inspection type.';
        }
        field(40; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
            ToolTip = 'Specifies the customer at whose site the inspection takes place.';

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if "Customer No." <> '' then begin
                    Customer.Get("Customer No.");
                    "Customer Name" := Customer.Name;
                    "Site Address" := Customer.Address;
                    "Site City" := Customer.City;
                end else begin
                    "Customer Name" := '';
                    "Site Address" := '';
                    "Site City" := '';
                end;
            end;
        }
        field(50; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            Editable = false;
            ToolTip = 'Specifies the customer name.';
        }
        field(60; "Site Address"; Text[100])
        {
            Caption = 'Site Address';
            ToolTip = 'Specifies the address of the inspection site.';
        }
        field(70; "Site City"; Text[30])
        {
            Caption = 'Site City';
            ToolTip = 'Specifies the city of the inspection site.';
        }
        field(80; "Inspector Resource No."; Code[20])
        {
            Caption = 'Inspector Resource No.';
            TableRelation = Resource where(Type = const(Person));
            ToolTip = 'Specifies the resource assigned as inspector.';

            trigger OnValidate()
            var
                Resource: Record Resource;
            begin
                if "Inspector Resource No." <> '' then begin
                    Resource.Get("Inspector Resource No.");
                    "Inspector Name" := Resource.Name;
                end else
                    "Inspector Name" := '';
            end;
        }
        field(90; "Inspector Name"; Text[100])
        {
            Caption = 'Inspector Name';
            Editable = false;
            ToolTip = 'Specifies the name of the assigned inspector.';
        }
        field(100; "Planned Date"; Date)
        {
            Caption = 'Planned Date';
            ToolTip = 'Specifies the planned date of the inspection.';
        }
        field(110; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ToolTip = 'Specifies the posting date for the inspection.';
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
            MinValue = 0;
            ToolTip = 'Specifies the duration of the inspection in days.';
        }
        field(140; Status; Enum "MBS Inspection Status")
        {
            Caption = 'Status';
            ToolTip = 'Specifies the current status of the inspection.';
        }
        field(150; Priority; Enum "MBS Inspection Priority")
        {
            Caption = 'Priority';
            ToolTip = 'Specifies the priority of the inspection.';
        }
        field(160; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
            Editable = false;
            ToolTip = 'Specifies the posting number assigned during posting.';
        }
        field(170; "Posting No. Series"; Code[20])
        {
            AllowInCustomizations = Never;
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(180; "No. Series"; Code[20])
        {
            AllowInCustomizations = Never;
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(190; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            ToolTip = 'Specifies the reason code for the inspection.';
        }
        field(200; Comment; Boolean)
        {
            AllowInCustomizations = Never;
            CalcFormula = exist("MBS Inspection Comment Line" where("Table Name" = const(Inspection), "No." = field("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(210; "Source Code"; Code[10])
        {
            AllowInCustomizations = Never;
            Caption = 'Source Code';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Status; Status, "Planned Date")
        {
        }
        key(Customer; "Customer No.", "Planned Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Inspection Type Name", "Customer Name", "Planned Date")
        {
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            GetSetup();
            InspSetup.TestField("Inspection Nos.");
            "No." := NoSeries.GetNextNo(InspSetup."Inspection Nos.", WorkDate());
            "No. Series" := InspSetup."Inspection Nos.";
        end;

        if "Posting Date" = 0D then
            "Posting Date" := WorkDate();
        if "Document Date" = 0D then
            "Document Date" := WorkDate();

        InitPostingNoSeries();
    end;

    trigger OnDelete()
    var
        InspLine: Record "MBS Inspection Line";
        InspCommentLine: Record "MBS Inspection Comment Line";
    begin
        InspLine.SetRange("Document No.", "No.");
        InspLine.DeleteAll(false);

        InspCommentLine.SetRange("Table Name", InspCommentLine."Table Name"::Inspection);
        InspCommentLine.SetRange("No.", "No.");
        InspCommentLine.DeleteAll(false);
    end;

    var
        InspSetup: Record "MBS Inspection Setup";
        NoSeries: Codeunit "No. Series";
        BlockedInspTypeErr: Label 'Inspection Type %1 is blocked.', Comment = '%1 = inspection type number';
        SetupNotFoundErr: Label 'Inspection Setup not found';

    local procedure GetSetup()
    begin
        if not InspSetup.Get() then
            Error(SetupNotFoundErr);
    end;

    local procedure InitPostingNoSeries()
    begin
        GetSetup();
        InspSetup.TestField("Posted Inspection Nos.");
        "Posting No. Series" := InspSetup."Posted Inspection Nos.";
    end;

    procedure AssistEdit(): Boolean
    var
        NoSeriesCode: Code[20];
        InspHeader: Record "MBS Inspection Header";
    begin
        InspHeader := Rec;
        GetSetup();
        InspSetup.TestField("Inspection Nos.");
        NoSeriesCode := InspHeader."No. Series";
        if NoSeries.LookupRelatedNoSeries(InspSetup."Inspection Nos.", xRec."No. Series", NoSeriesCode) then begin
            InspHeader."No. Series" := NoSeriesCode;
            InspHeader."No." := NoSeries.GetNextNo(NoSeriesCode, WorkDate());
            Rec := InspHeader;
            exit(true);
        end;
    end;
}
