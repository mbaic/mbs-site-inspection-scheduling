namespace MBS.SiteInspection.Posting;

enum 50040 "MBS Inspection Status"
{
    Extensible = true;

    value(0; Planning)
    {
        Caption = 'Planning';
    }
    value(1; Open)
    {
        Caption = 'Open';
    }
    value(2; Closed)
    {
        Caption = 'Closed';
    }
}
