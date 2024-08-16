pageextension 63000 "CG BusinessManagerRoleExt Con" extends "Business Manager Role Center"
{
    actions
    {
        addafter(Action39)
        {
            group("CG Invoice Import Group Con")
            {
                Caption = 'Invoice Import', comment = 'DAN="Fakturaindlæsning"';
                action("CG Invoice Import Con")
                {
                    Caption = 'Invoice Import', comment = 'DAN="Fakturaindlæsningskladde"';
                    ApplicationArea = all;
                    RunObject = Page "CG Invoice Import Ledger Con";
                }
                group("CG Setup Group Con")
                {
                    Caption = 'Setup', comment = 'DAN="Opsætning"';

                    action("CG Contract Setup Con")
                    {
                        Caption = 'Setup', comment = 'DAN="Opsætning"';
                        ApplicationArea = all;
                        RunObject = Page "CG Invoice Import Setup Con";
                    }
                    action("CG Invoice Import Entries Con")
                    {
                        Caption = 'Invoice Import Entries', comment = 'DAN="Fakturaindlæsningsposter"';
                        ApplicationArea = all;
                        RunObject = Page "cg Invoice Import Entries Con";
                    }
                }
                group("CG Periodic Con")
                {
                    Caption = 'Periodic', comment = 'DAN="Kørsler"';

                    action("CG Create Invoices Con")
                    {
                        Caption = 'Create Invoices', Comment = 'DAN="Opret salgsdokumenter"';
                        Image = Invoice;
                        ApplicationArea = all;
                        RunObject = report "CG Create Invoice Con";
                    }
                }
            }
        }
    }
}