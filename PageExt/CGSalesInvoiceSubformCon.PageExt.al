pageextension 63002 "CG Sales Invoice Subform Con" extends "Posted Sales Invoice Subform"
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