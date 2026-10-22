namespace MBS.SiteInspection.Scheduling;

page 50017 "MBS Inspection Subpage"
{
    ApplicationArea = All;
    AutoSplitKey = true;
    Caption = 'Inspection Lines';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "MBS Inspection Line";

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
                    ToolTip = 'Specifies a note about the issue found.';
                }
                field(Severity; Rec.Severity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the severity of the finding.';
                }
                field("Follow-Up Note"; Rec."Follow-Up Note")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies recommended follow-up actions.';
                }
            }
        }
    }
}
