table 63003 "CG Invoice Import Entry Con"
{
    Caption = 'Invoice Import Entry', comment = 'DAN="Fakturaindlæsningsposter"';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.', Comment = 'DAN="Løbenr."';
            AutoIncrement = true;
        }
        field(4; AXID; Code[20])
        {
            Caption = 'AXID', Comment = 'DAN="AXID"';
            DataClassification = CustomerContent;
            // TableRelation = Customer;
        }
        field(5; ProjectNo; Code[20])
        {
            Caption = '"Project No"', Comment = 'DAN="Projekt Nr."';
            DataClassification = CustomerContent;
            // TableRelation = Job;
        }
        field(6; ItemID; Code[20])
        {
            Caption = '"Item ID"', Comment = 'DAN="Vare Nr."';
            DataClassification = CustomerContent;
            // TableRelation = Item;
        }
        field(8; VariantID; Code[20])
        {
            Caption = '"Variant ID"', Comment = 'DAN="Variant ID"';
            DataClassification = CustomerContent;
        }
        field(9; ProjectCategory; Code[20])
        {
            Caption = '"ProjectCategory"', Comment = 'DAN="Projektkategori"';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[250])
        {
            Caption = 'Description', Comment = 'DAN="Beskrivelse"';
            DataClassification = CustomerContent;
        }
        field(12; Quantity; Decimal)
        {
            Caption = 'Quantity', Comment = 'DAN="Antal"';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            BlankZero = true;
        }
        field(14; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price', Comment = 'DAN="Salgspris"';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 5;
            BlankZero = true;
        }
        field(21; ServiceID; Code[20])
        {
            Caption = '"Service ID"', Comment = 'DAN="Service ID"';
            DataClassification = CustomerContent;
        }
        field(25; FromDate; Date)
        {
            Caption = 'From Date', Comment = 'DAN="Fradato"';
            DataClassification = CustomerContent;
        }
        field(26; ToDate; Date)
        {
            Caption = 'To Date', Comment = 'DAN="Tildato"';
            DataClassification = CustomerContent;
        }
        field(31; Filename; Text[100])
        {
            Caption = 'Filename', Comment = 'DAN="Filnavn"';
            DataClassification = CustomerContent;
        }
        field(35; ExternalID; Code[20])
        {
            Caption = '"External ID"', Comment = 'DAN="External ID"';
            DataClassification = CustomerContent;
        }
        field(61; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.', Comment = 'DAN="Salgsfaktura nr."';
        }
        field(62; "Invoice Line No."; Integer)
        {
            Caption = 'Invoice Line No.', Comment = 'DAN="Salgsfakturalinje nr."';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; AXID)
        {
        }
    }
}