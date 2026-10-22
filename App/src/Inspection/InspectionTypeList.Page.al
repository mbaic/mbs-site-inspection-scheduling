namespace MBS.SiteInspection.Inspection;

page 50011 "MBS Inspection Type List"
{
    ApplicationArea = All;
    Caption = 'Inspection Types';
    CardPageId = "MBS Inspection Type Card";
    Editable = false;
    PageType = List;
    SourceTable = "MBS Inspection Type";
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
                    ToolTip = 'Specifies the inspection type number.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the inspection type.';
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category of the inspection type.';
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default duration for this inspection type.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this inspection type is blocked.';
                }
            }
        }
    }
}
