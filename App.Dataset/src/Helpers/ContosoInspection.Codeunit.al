namespace MBS.SiteInspection.Dataset;

using MBS.SiteInspection.Setup;
using MBS.SiteInspection.Inspection;
using MBS.SiteInspection.Scheduling;
using MBS.SiteInspection.Posting;
using MBS.SiteInspection.PostedInspection;
using MBS.SiteInspection.Ledger;
using Microsoft.DemoTool;
using Microsoft.Foundation.NoSeries;
using Microsoft.Foundation.AuditCodes;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Sales.Customer;

codeunit 50301 "MBS Contoso Inspection" implements "Contoso Demo Data Module"
{
    Access = Internal;

    procedure RunConfigurationPage()
    var
        ContosoDemoTool: Codeunit "Contoso Demo Tool";
    begin
        Message(ContosoDemoTool.GetNoConfiguirationMsg());
    end;

    procedure GetDependencies() Dependencies: List of [Enum "Contoso Demo Data Module"]
    begin
    end;

    procedure CreateSetupData()
    begin
        CreateNoSeries();
        CreateInspectionSetup();
        CreateSourceCodeSetup();
    end;

    local procedure CreateNoSeries()
    begin
        EnsureNoSeries('MB-ITYPE', 'MB-ITYPE-0001', 'MB-ITYPE-9999');
        EnsureNoSeries('MB-INSP', 'MB-INSP-0001', 'MB-INSP-9999');
        EnsureNoSeries('MB-PINSP', 'MB-PINSP-0001', 'MB-PINSP-9999');
    end;

    local procedure EnsureNoSeries(SeriesCode: Code[20]; StartNo: Code[20]; EndNo: Code[20])
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        if not NoSeries.Get(SeriesCode) then begin
            NoSeries.Init();
            NoSeries.Code := SeriesCode;
            NoSeries.Description := SeriesCode;
            NoSeries."Default Nos." := true;
            NoSeries.Insert(true);
        end;
        NoSeriesLine.SetRange("Series Code", SeriesCode);
        if NoSeriesLine.IsEmpty() then begin
            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := SeriesCode;
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := StartNo;
            NoSeriesLine."Ending No." := EndNo;
            NoSeriesLine."Increment-by No." := 1;
            NoSeriesLine.Insert(true);
        end;
    end;

    local procedure CreateInspectionSetup()
    var
        InspSetup: Record "MBS Inspection Setup";
    begin
        if not InspSetup.Get() then begin
            InspSetup.Init();
            InspSetup.Insert(true);
        end;
        InspSetup."Inspection Type Nos." := 'MB-ITYPE';
        InspSetup."Inspection Nos." := 'MB-INSP';
        InspSetup."Posted Inspection Nos." := 'MB-PINSP';
        InspSetup."Default Duration" := 1;
        InspSetup."Overdue Threshold Days" := 0;
        InspSetup.Modify(true);
    end;

    local procedure CreateSourceCodeSetup()
    var
        SourceCodeSetup: Record "Source Code Setup";
    begin
        if not SourceCodeSetup.Get() then begin
            SourceCodeSetup.Init();
            SourceCodeSetup.Insert(true);
        end;
    end;

    procedure CreateMasterData()
    begin
        CreateInspectionTypes();
        CreateInspectorResources();
        CreateTargetCustomers();
    end;

    local procedure CreateInspectionTypes()
    begin
        EnsureInspectionType('SAFETY', 'Safety Walkthrough', 'General safety and hazard review', 'Safety', 0.5);
        EnsureInspectionType('COMPLIANCE', 'Compliance Audit', 'Regulatory compliance verification', 'Compliance', 1);
        EnsureInspectionType('READINESS', 'Site Readiness Check', 'Pre-operational readiness assessment', 'Readiness', 0.5);
        EnsureInspectionType('EQUIPMENT', 'Equipment Condition Review', 'Equipment state and maintenance check', 'Equipment', 1);
        EnsureInspectionType('CLOSEOUT', 'Close-Out Review', 'Final review before project or site closure', 'Closeout', 1.5);
    end;

    local procedure EnsureInspectionType(No: Code[20]; TypeName: Text[100]; Desc: Text[250]; Cat: Text[50]; Dur: Decimal)
    var
        InspType: Record "MBS Inspection Type";
    begin
        if InspType.Get(No) then
            exit;
        InspType.Init();
        InspType."No." := No;
        InspType.Name := TypeName;
        InspType.Description := Desc;
        InspType.Category := Cat;
        InspType.Duration := Dur;
        InspType.Blocked := false;
        InspType.Insert(false);
    end;

    local procedure CreateInspectorResources()
    begin
        EnsureInspectorResource('INSP-001', 'Anna Bergström', 'Senior Inspector');
        EnsureInspectorResource('INSP-002', 'Carlos Moreno', 'Compliance Specialist');
        EnsureInspectorResource('INSP-003', 'Diana Patel', 'Safety Coordinator');
        EnsureInspectorResource('INSP-004', 'Erik Johansson', 'Operations Reviewer');
    end;

    local procedure EnsureInspectorResource(No: Code[20]; ResourceName: Text[100]; JobTitle: Text[50])
    var
        Resource: Record Resource;
    begin
        if Resource.Get(No) then
            exit;
        Resource.Init();
        Resource."No." := No;
        Resource.Name := ResourceName;
        Resource.Type := Resource.Type::Person;
        Resource."Job Title" := JobTitle;
        Resource.Insert(false);
    end;

    local procedure CreateTargetCustomers()
    begin
        EnsureTargetCustomer('SITE-001', 'Northwind Warehouse A', '100 Industrial Blvd', 'Stockholm');
        EnsureTargetCustomer('SITE-002', 'Northwind Warehouse B', '200 Commerce Drive', 'Gothenburg');
        EnsureTargetCustomer('SITE-003', 'Contoso Branch Office', '50 Main Street', 'Malmö');
        EnsureTargetCustomer('SITE-004', 'Fabrikam Distribution Center', '75 Logistics Lane', 'Uppsala');
        EnsureTargetCustomer('SITE-005', 'Woodgrove Service Hub', '30 Service Road', 'Linköping');
        EnsureTargetCustomer('SITE-006', 'Alpine Equipment Yard', '12 Mountain Pass', 'Sundsvall');
    end;

    local procedure EnsureTargetCustomer(No: Code[20]; CustName: Text[100]; Addr: Text[100]; CityName: Text[30])
    var
        Customer: Record Customer;
    begin
        if Customer.Get(No) then
            exit;
        Customer.Init();
        Customer."No." := No;
        Customer.Name := CustName;
        Customer.Address := Addr;
        Customer.City := CityName;
        Customer.Insert(false);
    end;

    procedure CreateTransactionalData()
    begin
        CreateScheduledInspections();
        CreateOverdueInspections();
        CreateReadyToPostInspections();
    end;

    local procedure CreateScheduledInspections()
    begin
        CreateOpenInspection('SAFETY', 'SITE-001', 'INSP-001',
            CalcDate('<+14D>', WorkDate()), 'Safety Walkthrough — Warehouse A', false);
        CreateOpenInspection('COMPLIANCE', 'SITE-003', 'INSP-002',
            CalcDate('<+7D>', WorkDate()), 'Compliance Audit — Branch Office', false);
        CreateOpenInspection('READINESS', 'SITE-005', 'INSP-003',
            CalcDate('<+21D>', WorkDate()), 'Readiness Check — Service Hub', false);
        CreateOpenInspection('EQUIPMENT', 'SITE-006', 'INSP-004',
            CalcDate('<+10D>', WorkDate()), 'Equipment Review — Alpine Yard', false);
    end;

    local procedure CreateOverdueInspections()
    begin
        CreateOpenInspection('SAFETY', 'SITE-002', 'INSP-001',
            CalcDate('<-15D>', WorkDate()), 'OVERDUE: Safety Walkthrough — Warehouse B', true);
        CreateOpenInspection('COMPLIANCE', 'SITE-004', 'INSP-002',
            CalcDate('<-30D>', WorkDate()), 'OVERDUE: Compliance Audit — Distribution Center', true);
    end;

    local procedure CreateOpenInspection(InspTypeNo: Code[20]; CustomerNo: Code[20]; InspectorNo: Code[20]; PlannedDate: Date; Desc: Text; WithIssue: Boolean)
    var
        InspHeader: Record "MBS Inspection Header";
    begin
        InspHeader.Init();
        InspHeader.Insert(true);
        InspHeader.Validate("Inspection Type No.", InspTypeNo);
        InspHeader.Validate("Customer No.", CustomerNo);
        InspHeader.Validate("Inspector Resource No.", InspectorNo);
        InspHeader."Planned Date" := PlannedDate;
        InspHeader."Posting Date" := WorkDate();
        InspHeader."Document Date" := WorkDate();
        InspHeader.Status := "MBS Inspection Status"::Open;
        InspHeader.Modify(true);

        CreateDemoLine(InspHeader."No.", 10000, 'General condition assessment',
            "MBS Inspection Result Status"::Satisfactory, '', "MBS Inspection Priority"::Low);
        CreateDemoLine(InspHeader."No.", 20000, 'Access and egress review',
            "MBS Inspection Result Status"::Satisfactory, '', "MBS Inspection Priority"::Low);

        if WithIssue then
            CreateDemoLine(InspHeader."No.", 30000, 'Fire safety equipment check',
                "MBS Inspection Result Status"::Unsatisfactory,
                'Fire extinguisher expired — replacement required',
                "MBS Inspection Priority"::High);
    end;

    local procedure CreateReadyToPostInspections()
    begin
        CreateClosedInspection('CLOSEOUT', 'SITE-001', 'INSP-004',
            CalcDate('<-3D>', WorkDate()), 'Close-Out Review — Warehouse A Project');
        CreateClosedInspection('READINESS', 'SITE-003', 'INSP-003',
            CalcDate('<-1D>', WorkDate()), 'Readiness Check — Branch Office Renovation');
    end;

    local procedure CreateClosedInspection(InspTypeNo: Code[20]; CustomerNo: Code[20]; InspectorNo: Code[20]; PlannedDate: Date; Desc: Text)
    var
        InspHeader: Record "MBS Inspection Header";
    begin
        InspHeader.Init();
        InspHeader.Insert(true);
        InspHeader.Validate("Inspection Type No.", InspTypeNo);
        InspHeader.Validate("Customer No.", CustomerNo);
        InspHeader.Validate("Inspector Resource No.", InspectorNo);
        InspHeader."Planned Date" := PlannedDate;
        InspHeader."Posting Date" := WorkDate();
        InspHeader."Document Date" := WorkDate();
        InspHeader.Status := "MBS Inspection Status"::Closed;
        InspHeader.Modify(true);

        CreateDemoLine(InspHeader."No.", 10000, 'Final walkthrough completed',
            "MBS Inspection Result Status"::Satisfactory, '', "MBS Inspection Priority"::Low);
        CreateDemoLine(InspHeader."No.", 20000, 'Documentation review',
            "MBS Inspection Result Status"::Satisfactory, '', "MBS Inspection Priority"::Medium);
        CreateDemoLine(InspHeader."No.", 30000, 'Stakeholder sign-off',
            "MBS Inspection Result Status"::Satisfactory, '', "MBS Inspection Priority"::Low);
    end;

    procedure CreateHistoricalData()
    begin
        CreatePostedInspectionHistory();
        CreateRepeatedSitePatterns();
    end;

    local procedure CreatePostedInspectionHistory()
    begin
        CreateAndPostInspection('SAFETY', 'SITE-001', 'INSP-001',
            CalcDate('<-6M>', WorkDate()), true);
        CreateAndPostInspection('COMPLIANCE', 'SITE-003', 'INSP-002',
            CalcDate('<-5M>', WorkDate()), true);
        CreateAndPostInspection('EQUIPMENT', 'SITE-005', 'INSP-004',
            CalcDate('<-4M>', WorkDate()), true);
        CreateAndPostInspection('READINESS', 'SITE-006', 'INSP-003',
            CalcDate('<-3M>', WorkDate()), true);
        CreateAndPostInspection('CLOSEOUT', 'SITE-004', 'INSP-001',
            CalcDate('<-2M>', WorkDate()), true);
    end;

    local procedure CreateRepeatedSitePatterns()
    begin
        CreateAndPostInspection('SAFETY', 'SITE-002', 'INSP-001',
            CalcDate('<-12M>', WorkDate()), true);
        CreateAndPostInspectionWithIssue('SAFETY', 'SITE-002', 'INSP-003',
            CalcDate('<-9M>', WorkDate()),
            'Emergency exit signage missing',
            "MBS Inspection Priority"::High);
        CreateAndPostInspection('SAFETY', 'SITE-002', 'INSP-001',
            CalcDate('<-6M>', WorkDate()), true);
        CreateAndPostInspectionWithIssue('SAFETY', 'SITE-002', 'INSP-002',
            CalcDate('<-3M>', WorkDate()),
            'Storage area obstruction — fire lane blocked',
            "MBS Inspection Priority"::Critical);
        CreateAndPostInspectionWithIssue('COMPLIANCE', 'SITE-004', 'INSP-002',
            CalcDate('<-10M>', WorkDate()),
            'Missing calibration certificates',
            "MBS Inspection Priority"::High);
        CreateAndPostInspectionWithIssue('COMPLIANCE', 'SITE-004', 'INSP-002',
            CalcDate('<-7M>', WorkDate()),
            'Partial calibration certificates — 2 pending',
            "MBS Inspection Priority"::Medium);
        CreateAndPostInspection('COMPLIANCE', 'SITE-004', 'INSP-002',
            CalcDate('<-4M>', WorkDate()), true);
        CreateAndPostInspection('SAFETY', 'SITE-001', 'INSP-001',
            CalcDate('<-11M>', WorkDate()), true);
        CreateAndPostInspection('SAFETY', 'SITE-001', 'INSP-003',
            CalcDate('<-8M>', WorkDate()), true);
        CreateAndPostInspection('SAFETY', 'SITE-001', 'INSP-001',
            CalcDate('<-5M>', WorkDate()), true);
    end;

    local procedure CreateAndPostInspection(InspTypeNo: Code[20]; CustomerNo: Code[20]; InspectorNo: Code[20]; PostingDate: Date; AllSatisfactory: Boolean)
    var
        InspHeader: Record "MBS Inspection Header";
        InspPost: Codeunit "MBS Inspection-Post";
    begin
        InspHeader.Init();
        InspHeader.Insert(true);
        InspHeader.Validate("Inspection Type No.", InspTypeNo);
        InspHeader.Validate("Customer No.", CustomerNo);
        InspHeader.Validate("Inspector Resource No.", InspectorNo);
        InspHeader."Planned Date" := PostingDate;
        InspHeader."Posting Date" := PostingDate;
        InspHeader."Document Date" := PostingDate;
        InspHeader.Status := "MBS Inspection Status"::Closed;
        InspHeader.Modify(true);

        if AllSatisfactory then begin
            CreateDemoLine(InspHeader."No.", 10000, 'General condition — satisfactory',
                "MBS Inspection Result Status"::Satisfactory, '', "MBS Inspection Priority"::Low);
            CreateDemoLine(InspHeader."No.", 20000, 'Safety equipment — satisfactory',
                "MBS Inspection Result Status"::Satisfactory, '', "MBS Inspection Priority"::Low);
            CreateDemoLine(InspHeader."No.", 30000, 'Documentation — satisfactory',
                "MBS Inspection Result Status"::Satisfactory, '', "MBS Inspection Priority"::Low);
        end;

        InspPost.Run(InspHeader);
    end;

    local procedure CreateAndPostInspectionWithIssue(InspTypeNo: Code[20]; CustomerNo: Code[20]; InspectorNo: Code[20]; PostingDate: Date; IssueNote: Text[250]; IssueSeverity: Enum "MBS Inspection Priority")
    var
        InspHeader: Record "MBS Inspection Header";
        InspPost: Codeunit "MBS Inspection-Post";
    begin
        InspHeader.Init();
        InspHeader.Insert(true);
        InspHeader.Validate("Inspection Type No.", InspTypeNo);
        InspHeader.Validate("Customer No.", CustomerNo);
        InspHeader.Validate("Inspector Resource No.", InspectorNo);
        InspHeader."Planned Date" := PostingDate;
        InspHeader."Posting Date" := PostingDate;
        InspHeader."Document Date" := PostingDate;
        InspHeader.Status := "MBS Inspection Status"::Closed;
        InspHeader.Modify(true);

        CreateDemoLine(InspHeader."No.", 10000, 'General condition — satisfactory',
            "MBS Inspection Result Status"::Satisfactory, '', "MBS Inspection Priority"::Low);
        CreateDemoLine(InspHeader."No.", 20000, 'Issue finding',
            "MBS Inspection Result Status"::Unsatisfactory, IssueNote, IssueSeverity);
        CreateDemoLine(InspHeader."No.", 30000, 'Documentation — satisfactory',
            "MBS Inspection Result Status"::Satisfactory, '', "MBS Inspection Priority"::Low);

        InspPost.Run(InspHeader);
    end;

    local procedure CreateDemoLine(DocumentNo: Code[20]; LineNo: Integer; Desc: Text[100]; ResultStatus: Enum "MBS Inspection Result Status"; IssueNote: Text[250]; Severity: Enum "MBS Inspection Priority")
    var
        InspLine: Record "MBS Inspection Line";
    begin
        if InspLine.Get(DocumentNo, LineNo) then
            exit;
        InspLine.Init();
        InspLine."Document No." := DocumentNo;
        InspLine."Line No." := LineNo;
        InspLine.Description := Desc;
        InspLine."Result Status" := ResultStatus;
        InspLine."Issue Note" := IssueNote;
        InspLine.Severity := Severity;
        InspLine.Insert(false);
    end;
}
