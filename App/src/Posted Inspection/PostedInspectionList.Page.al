namespace MBS.SiteInspection.PostedInspection;

page 50019 "MBS Posted Inspection List"
{
    ApplicationArea = All;
    Caption = 'Posted Inspections';
    CardPageId = "MBS Posted Inspection";
    Editable = false;
    PageType = List;
    SourceTable = "MBS Posted Inspection Hdr.";
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posted inspection number.';
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
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date.';
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
