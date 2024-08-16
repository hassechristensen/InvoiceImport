permissionset 63000 InvImpGenPermission
{
    Assignable = true;
    Permissions = tabledata "CG Invoice Import Entry Con"=RIMD,
        tabledata "CG Invoice Import Setup Con"=RIMD,
        table "CG Invoice Import Entry Con"=X,
        table "CG Invoice Import Setup Con"=X,
        page "CG Invoice Import Entries Con"=X,
        page "CG Invoice Import Setup Con"=X,
        tabledata "CG Invoice Import Ledger Con"=RIMD,
        table "CG Invoice Import Ledger Con"=X,
        report "CG Create Invoice Con"=X,
        page "CG Invoice Import Ledger Con"=X,
        report "Delete Customers"=X,
        codeunit "CG Create Invoice Con"=X,
        codeunit "CG Invoice Import Events Con"=X;
}