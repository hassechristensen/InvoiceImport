table 63000 "CG Invoice Import Setup Con"
{
    Caption = 'Inoice Import Setup', comment = 'DAN="Fakturainlæsningsopsætning"';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key', Comment = 'DAN="Primærnøgle"';
            DataClassification = CustomerContent;
        }

        field(6; "Transfer Attachments"; Boolean)
        {
            Caption = '"Transfer Attachments to Sales Documents"', Comment = 'DAN="Overfør bilag til salgsfakturaer"';
            DataClassification = CustomerContent;
        }
        field(8; "Project Dimension Code"; Code[20])
        {
            Caption = 'Project Dimension Code', Comment = 'DAN="Projektdimensionskode"';
            DataClassification = CustomerContent;
            TableRelation = Dimension;
        }
        field(10; "Sales Line Account"; Code[20])
        {
            Caption = 'Sales Line Account', comment = 'DAN="Salgsline finanskontonr."';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";
        }

        field(12; "Unit of Measure Code"; Text[50])
        {
            Caption = 'Salesline Unit of Measure Code', comment = 'DAN="Salgsenhedskode"';
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}