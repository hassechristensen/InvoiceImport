tableextension 63012 "CG Sales Invoice Line Con" extends "Sales Invoice Line"
{
    fields
    {
        field(63001; "CG From Date Con"; Date)
        {
            Caption = 'From date', Comment = 'DAN="Fra dato"';
            DataClassification = CustomerContent;

        }
        field(63002; "CG To Date Con"; Date)
        {
            Caption = 'To date', Comment = 'DAN="Til dato"';
            DataClassification = CustomerContent;

        }
        field(63003; "CG Service ID Con"; Code[20])
        {
            Caption = 'Service ID', Comment = 'DAN="Service ID"';
            DataClassification = CustomerContent;
        }
        field(63004; ExternalID; Code[20])
        {
            Caption = 'External ID', Comment = 'DAN="External ID"';
            DataClassification = CustomerContent;
        }
    }
}