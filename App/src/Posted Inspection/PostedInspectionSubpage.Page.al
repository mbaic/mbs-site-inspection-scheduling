namespace MBS.SiteInspection.PostedInspection;

page 50020 "MBS Posted Inspection Subpage"
{
    ApplicationArea = All;
    Caption = 'Posted Inspection Lines';
    Editable = false;
    PageType = ListPart;
    SourceTable = "MBS Posted Inspection Line";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the checklist item or finding description.';
                }
                field("Result Status"; Rec."Result Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the result of this checklist item.';
                }
                field("Issue Note"; Rec."Issue Note")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the issue note.';
                }
                field(Severity; Rec.Severity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the severity of the finding.';
                }
                field("Follow-Up Note"; Rec."Follow-Up Note")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the follow-up note.';
                }
            }
        }
    }
}
