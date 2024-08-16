report 63001 "Delete Customers"
{
    Caption = 'Delete Customers', comment = 'DAN="Slet debitorer"';
    ProcessingOnly = true;
    ApplicationArea = All;
    AdditionalSearchTerms = 'Delete Customers', comment = 'DAN="Slet debitorer,"';
    UsageCategory = Administration;
    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "Customer Posting Group", "No.";

            trigger OnAfterGetRecord()
            var
                CustLedgerEntry: record "Cust. Ledger Entry";
                Cust: Record Customer;
            begin
                CustLedgerEntry.SetRange("Customer No.", "No.");
                if not CustLedgerEntry.IsEmpty() then
                    exit;
                Cust.get("No.");
                Cust.Delete(true);
                i := i + 1;
            end;

            trigger OnPostDataItem()
            begin
                if i > 0 then
                    Message('Deleted %1 customers', i);
            end;

        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
        i: Integer;
}