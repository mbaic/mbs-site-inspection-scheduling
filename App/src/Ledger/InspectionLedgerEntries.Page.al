namespace MBS.SiteInspection.Ledger;

page 50021 "MBS Inspection Ledger Entries"
{
    ApplicationArea = All;
    Caption = 'Inspection Ledger Entries';
    Editable = false;
    PageType = List;
    SourceTable = "MBS Inspection Ledger Entry";
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posted inspection number.';
                }
                field("Inspection Type No."; Rec."Inspection Type No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the inspection type.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer.';
                }
                field("Inspector Resource No."; Rec."Inspector Resource No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the inspector.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description.';
                }
                field("Result Summary"; Rec."Result Summary")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the result summary.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the priority.';
                }
                field("Planned Date"; Rec."Planned Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the planned date.';
                }
            }
        }
    }
}
