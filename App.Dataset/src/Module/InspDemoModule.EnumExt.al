namespace MBS.SiteInspection.Dataset;

using Microsoft.DemoTool;

enumextension 50300 "MBS Inspection Demo Module" extends "Contoso Demo Data Module"
{
    value(50300; "MB Site Inspection Scheduling")
    {
        Caption = 'Site Inspection Scheduling';
        Implementation = "Contoso Demo Data Module" = "MBS Contoso Inspection";
    }
}
