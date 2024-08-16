pageextension 63003 SalesInvoice extends "Sales Invoice"
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("CG From Date Con"; Rec."CG From Date Con")
            {
                ToolTip = ' ';
                ApplicationArea = All;
            }
            field("CG To Date Con"; rec."CG To Date Con")
            {
                ToolTip = ' ';
                ApplicationArea = All;
            }
            field("CG Service ID Con"; Rec."CG Service ID Con")
            {
                ToolTip = ' ';
                ApplicationArea = All;
            }
            field("ExternalID"; Rec.ExternalID)
            {
                ToolTip = ' ';
                ApplicationArea = All;
            }
        }
    }
}