pageextension 63001 "CG Sales Subform Con" extends "Sales Invoice Subform"
{
    layout
    {
        addafter("Description")
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