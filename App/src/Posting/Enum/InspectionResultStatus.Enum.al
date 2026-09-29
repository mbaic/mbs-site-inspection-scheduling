namespace MBS.SiteInspection.Posting;

enum 50041 "MBS Inspection Result Status"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; Satisfactory)
    {
        Caption = 'Satisfactory';
    }
    value(2; Unsatisfactory)
    {
        Caption = 'Unsatisfactory';
    }
    value(3; "Not Inspected")
    {
        Caption = 'Not Inspected';
    }
}
