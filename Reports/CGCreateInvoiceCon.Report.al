report 63000 "CG Create Invoice Con"
{
    Caption = 'Create Invoices', Comment = 'DAN="Dan Fakturaer"';
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    dataset
    {
        dataitem(InvoiceImportLedger; "CG Invoice Import Ledger Con")
        {
            RequestFilterFields = AXID;
            // Request for posting of invoices

            trigger OnPreDataItem()
            begin
                Window.open(WindowTxt);
                Setfilter(Filename, '<>%1', '');  // Only Lines with Invoice
            end;

            trigger OnAfterGetRecord()
            begin
                Window.UPDATE(1, AXID);

                if InvoiceImportLedger.Filename <> '' then
                    if not CreateInvoice.Run(invoiceImportLedger) then begin  // if not Codeunit.Run(Codeunit::"CG Create Invoice Con", invoiceImportLedger) then begin
                        InvoiceImportLedger2 := InvoiceImportLedger;
                        InvoiceImportLedger2.ErrorText := CopyStr(GetLastErrorText(), 1, MaxStrLen(InvoiceImportLedger2.ErrorText));
                        InvoiceImportLedger2.Modify();
                        Commit();
                    end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close();
            end;
        }
    }

    var
        InvoiceImportLedger2: Record "CG Invoice Import Ledger Con";
        CreateInvoice: Codeunit "CG Create Invoice Con";
        Window: Dialog;
        WindowTxt: Label 'Creating Documents for Customer #####1####', comment = 'DAN="Salgsdokumenter oprettes for kunde #####1####"';
}