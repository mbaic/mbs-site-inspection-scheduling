namespace MBS.SiteInspection.PostedInspection;

using MBS.SiteInspection.Inspection;

page 50018 "MBS Posted Inspection"
{
    ApplicationArea = All;
    Caption = 'Posted Inspection';
    Editable = false;
    PageType = Document;
    SourceTable = "MBS Posted Inspection Hdr.";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

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
                field("Site Address"; Rec."Site Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the site address.';
                }
                field("Site City"; Rec."Site City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the site city.';
                }
                field("Inspector Resource No."; Rec."Inspector Resource No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the inspector.';
                }
                field("Inspector Name"; Rec."Inspector Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the inspector name.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status when posted.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the priority.';
                }
            }
            part(Lines; "MBS Posted Inspection Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
            group("Posting Details")
            {
                Caption = 'Posting Details';

                field("Planned Date"; Rec."Planned Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the planned date.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document date.';
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the duration.';
                }
                field("Pre-Assigned No."; Rec."Pre-Assigned No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the original inspection document number.';
                }
                field("User Id"; Rec."User Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who posted the inspection.';
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Comments)
            {
                ApplicationArea = All;
                Caption = 'Comments';
                Image = ViewComments;
                RunObject = page "MBS Inspection Comment Sheet";
                RunPageLink = "Table Name" = const("Posted Inspection"), "No." = field("No.");
                ToolTip = 'View comments for the posted inspection.';
            }
        }
    }
}
