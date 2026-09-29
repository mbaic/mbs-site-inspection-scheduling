namespace MBS.SiteInspection.Scheduling;

page 50016 "MBS Inspection List"
{
    ApplicationArea = All;
    Caption = 'Inspections';
    CardPageId = "MBS Inspection";
    Editable = false;
    PageType = List;
    SourceTable = "MBS Inspection Header";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the inspection document number.';
                }
                field("Inspection Type No."; Rec."Inspection Type No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the inspection type.';
                }
                field("Inspection Type Name"; Rec."Inspection Type Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the inspection type name.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer name.';
                }
                field("Inspector Resource No."; Rec."Inspector Resource No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the inspector.';
                }
                field("Planned Date"; Rec."Planned Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the planned date.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the priority.';
                }
            }
        }
    }
}
