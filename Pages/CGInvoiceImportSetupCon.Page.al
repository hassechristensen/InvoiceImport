/// <summary>
/// Page CG Contract Setup Con (ID 70100).
/// </summary>
page 63000 "CG Invoice Import Setup Con"
{

    Caption = 'Contract Setup', Comment = 'DAN="Kontraktopsætning"';
    PageType = Card;
    SourceTable = "CG Invoice Import Setup Con";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                // field("Contract No. Series"; Rec."Contract No. Series")
                // {
                //     ToolTip = 'Set Numberserie for Contracts', comment = 'DAN="Angive nummerserie for kontrakter"';
                //     ApplicationArea = All;
                // }
                // field("Contract Dimension Code"; Rec."Contract Dimension Code")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Set default dimension for Contract', comment = 'DAN="Angiv standard kontraktdimension"';
                // }
                // field("Create and Post"; rec."Create and Post")
                // {
                //     ApplicationArea = All;
                //     ToolTip = '"Sales Invoices, Create and Post at same time"', Comment = 'DAN="Overfør og bogfør salgsfakturaer samtidigt"';
                // }

                field("Transfer Attachments"; rec."Transfer Attachments")
                {
                    ApplicationArea = All;
                    ToolTip = 'Transfer attachtments to Sales Invoices', comment = 'DAN="Angiv om bilag skal overføres til salgsfakturering"';
                }
                field("Project Dimension Code"; rec."Project Dimension Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Set Dimension for ProjectNo', comment = 'DAN="Angiv dimension for projekt numre."';
                }
                field("Sales Line Account"; rec."Sales Line Account")
                {
                    ApplicationArea = All;
                    ToolTip = 'Set Account for Sales Line', comment = 'DAN="Angiv finanskontonr. for salgsline"';
                    Visible = false;
                }
                field("Unit of Measure Code"; rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Set Unit of Measure Code for Sales Line', comment = 'DAN="Angiv enhedskode for salgsline"';
                }
            }
        }
    }
}