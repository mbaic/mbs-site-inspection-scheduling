namespace MBS.SiteInspection.Setup;

page 50010 "MBS Inspection Setup"
{
    ApplicationArea = All;
    Caption = 'Inspection Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "MBS Inspection Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Default Duration"; Rec."Default Duration")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default inspection duration in days.';
                }
                field("Overdue Threshold Days"; Rec."Overdue Threshold Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of days past the planned date before an inspection is considered overdue.';
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';

                field("Inspection Type Nos."; Rec."Inspection Type Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for inspection type master records.';
                }
                field("Inspection Nos."; Rec."Inspection Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for inspection documents.';
                }
                field("Posted Inspection Nos."; Rec."Posted Inspection Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for posted inspections.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
