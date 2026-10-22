namespace MBS.SiteInspection.Scheduling;

using MBS.SiteInspection.Inspection;
using MBS.SiteInspection.Posting;
using MBS.SiteInspection.PostedInspection;

page 50015 "MBS Inspection"
{
    ApplicationArea = All;
    Caption = 'Inspection';
    PageType = Document;
    SourceTable = "MBS Inspection Header";

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
                    ToolTip = 'Specifies the inspection document number.';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit() then
                            CurrPage.Update();
                    end;
                }
                field("Inspection Type No."; Rec."Inspection Type No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the inspection type for this inspection.';
                }
                field("Inspection Type Name"; Rec."Inspection Type Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the inspection type.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer at whose site the inspection takes place.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer name.';
                }
                field("Site Address"; Rec."Site Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the address of the inspection site.';
                }
                field("Site City"; Rec."Site City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the city of the inspection site.';
                }
                field("Inspector Resource No."; Rec."Inspector Resource No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the resource assigned as inspector.';
                }
                field("Inspector Name"; Rec."Inspector Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the assigned inspector.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the inspection.';
                }
                field(Priority; Rec.Priority)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the priority of the inspection.';
                }
            }
            part(Lines; "MBS Inspection Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
            }
            group(Posting)
            {
                Caption = 'Posting';

                field("Planned Date"; Rec."Planned Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the planned date of the inspection.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date for the inspection.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document date.';
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the duration of the inspection in days.';
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
                RunPageLink = "Table Name" = const(Inspection), "No." = field("No.");
                ToolTip = 'View or add comments for this inspection.';
            }
        }
        area(Processing)
        {
            action(Post)
            {
                ApplicationArea = All;
                Caption = 'P&ost';
                Ellipsis = true;
                Image = PostOrder;
                ShortcutKey = 'F9';
                ToolTip = 'Post the inspection to create an immutable posted record.';

                trigger OnAction()
                var
                    InspPostYesNo: Codeunit "MBS Inspection-Post (Yes/No)";
                begin
                    InspPostYesNo.Run(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(Post_Promoted; Post)
                {
                }
            }
        }
    }
}
