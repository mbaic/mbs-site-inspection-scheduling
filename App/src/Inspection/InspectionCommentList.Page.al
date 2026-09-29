namespace MBS.SiteInspection.Inspection;

page 50014 "MBS Inspection Comment List"
{
    ApplicationArea = All;
    AutoSplitKey = true;
    Caption = 'Inspection Comments';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "MBS Inspection Comment Line";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the comment.';
                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a code for the comment.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the comment text.';
                }
            }
        }
    }
}
