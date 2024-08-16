// Tjek for inline edditing
// Tjek Action, set in groups ect.

page 63002 "CG Invoice Import Ledger Con"

{
    ApplicationArea = All;
    Caption = 'Invoice Import Ledger', comment = 'DAN="Fakturaindlæsningskladde"';
    PageType = List;
    //ModifyAllowed = false;
    //DeleteAllowed = false;
    SourceTable = "CG Invoice Import Ledger Con";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {

                field(AXID; Rec.AXID)
                {
                    ToolTip = 'Specifies the value of the AXID field.', Comment = 'DAN="AXID"';
                }
                field(ProjectNo; Rec.ProjectNo)
                {
                    ToolTip = 'Specifies the value of the "Project No" field.', Comment = 'DAN="Projekt Nr."';
                }
                field(ItemID; Rec.ItemID)
                {
                    ToolTip = 'Specifies the value of the "Item ID" field.', Comment = 'DAN="Vare Nr."';
                }
                field(VariantID; Rec.VariantID)
                {
                    ToolTip = 'Specifies the value of the "Variant ID" field.', Comment = 'DAN="Variant ID"';
                }
                field(ProjectCategory; Rec.ProjectCategory)
                {
                    ToolTip = 'Specifies the value of the "ProjectCategory" field.', Comment = 'DAN="Projektkategori"';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = 'DAN="Beskrivelse"';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = 'DAN="Antal"';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Unit Price (LCY) field.', Comment = 'DAN="Salgspris (RV)"';
                }
                field(ServiceID; Rec.ServiceID)
                {
                    ToolTip = 'Specifies the value of the "Service ID" field.', Comment = 'DAN="Service ID"';
                }
                field(FromDate; Rec.FromDate)
                {
                    ToolTip = 'Specifies the value of the From Date field.', Comment = 'DAN="Fradato"';
                }
                field(ToDate; Rec.ToDate)
                {
                    ToolTip = 'Specifies the value of the To Date field.', Comment = 'DAN="Tildato"';
                }
                field(Filename; Rec.Filename)
                {
                    ToolTip = 'Specifies the value of the Filename field.', Comment = 'DAN="Filenavn"';
                }
                field(ExternalID; Rec.ExternalID)
                {
                    ToolTip = 'Specifies the value of the "External ID" field.', Comment = 'DAN="External ID"';
                }
                field("Internal Invoice No."; rec."Internal Invoice No.")
                {
                    ToolTip = 'Specifies the value of the LineNo field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the LineNo field.';
                }
                field(ErrorText; Rec.ErrorText)
                {
                    ToolTip = 'Specifies the value of the Error field.', Comment = 'DAN="Viser fejlbeskrivelse"';
                }
            }
        }

        area(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(Database::"CG Invoice Import Ledger Con"), "No." = field(Filename);
            }
        }
    }

    actions
    {
        area(processing)
        {
            // action("&Import")
            // {
            //     ApplicationArea = All;
            //     Caption = '&Import CSV-file', comment = 'DAN="Import CSV-fil"';
            //     Image = ImportDatabase;
            //     // Promoted = true;
            //     // PromotedCategory = Process;
            //     ToolTip = 'Import data from CSV', comment = 'DAN="Indlæs data fra CSV-fil"';

            //     trigger OnAction()
            //     begin
            //         ReadCSVdata();
            //         ImportCSVData();
            //     end;
            // }

            action(ImportZipFile)
            {
                Caption = 'Import Zip File', comment = 'DAN="Indlæs Zip-fil"';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Import;
                ToolTip = 'Import Attachments from Zip';
                trigger OnAction()
                begin
                    ImportAttachmentsFromZip();
                end;
            }

            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&ValidateLine")
                {
                    ApplicationArea = All;
                    Caption = 'Validate Lines', comment = 'DAN="Valider Linjer"';
                    Image = CheckJournal;
                    // Promoted = true;
                    // PromotedCategory = Process;
                    ToolTip = 'Validate Lines', comment = 'DAN="Valider Linjer"';

                    trigger OnAction()
                    var
                        InvoiceImportLedger: Record "CG Invoice Import Ledger Con";
                        Item: Record Item;
                        Customer: Record Customer;
                        InvoiceImportLedgerList: page "CG Invoice Import Ledger Con";
                        ErrorsFound: Boolean;
                        ErrortxtMsg: Label '%1 %2 do not exists', comment = 'DAN="%1 %2 eksistrer ikke"';
                    begin
                        InvoiceImportLedger.Reset();
                        InvoiceImportLedger.ModifyAll(ErrorText, '');
                        if InvoiceImportLedger.FindSet() then
                            repeat
                                if not item.get(InvoiceImportLedger.ItemID) then
                                    InvoiceImportLedger.ErrorText := StrSubstNo(ErrortxtMsg, item.TableName, InvoiceImportLedger.ItemID);

                                if not customer.get(InvoiceImportLedger.AXID) then
                                    InvoiceImportLedger.ErrorText := InvoiceImportLedger.ErrorText + '; ' + StrSubstNo(ErrortxtMsg, Customer.TableName, InvoiceImportLedger.AXID);

                                if InvoiceImportLedger.ErrorText <> '' then begin
                                    InvoiceImportLedger.Modify(false);
                                    ErrorsFound := true;
                                end;
                            until InvoiceImportLedger.next() = 0;

                        If ErrorsFound then begin
                            Commit();
                            InvoiceImportLedger.Setfilter(ErrorText, '<>%1', '');
                            InvoiceImportLedgerList.SetTableView(InvoiceImportLedger);
                            InvoiceImportLedgerList.RunModal();
                        end;
                    end;
                }

                action(CreateInvoice)
                {
                    ApplicationArea = All;
                    Caption = 'Create Invoice', Comment = 'DAN="Opret fakturaer/kreditnotaer"';
                    Image = Invoice;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    ToolTip = 'Create Invoices from CSV-data', comment = 'DAN="Opretter salgsdokumenter fra CSV-data"';
                    trigger OnAction()
                    var
                        InvoiceImportLedger: Record "CG Invoice Import Ledger Con";
                    begin
                        clear(InvoiceImportLedger);
                        if InvoiceImportLedger.FindFirst() then
                            Report.RunModal(Report::"CG Create Invoice Con", true, false, InvoiceImportLedger);
                    end;
                }
                action(Archive)
                {
                    ApplicationArea = All;
                    Caption = 'Archive', Comment = 'DAN="Se arkiverede indlæsninger"';
                    Image = "Invoicing-View";
                    Promoted = true;
                    PromotedIsBig = true;
                    // PromotedCategory = Process;
                    ToolTip = 'Show Archive', comment = 'DAN="Se arkiverede indlæsninger"';
                    RunObject = Page "CG Invoice Import Entries Con";
                }

                action("CreateCustomerItem")
                {
                    ApplicationArea = All;
                    Caption = 'Create Customer  & Item data (Test Only)', comment = 'DAN="Opret Kunder og Vare data (kun test)"';
                    Image = TestReport;
                    Promoted = true;
                    // PromotedCategory = Process;
                    ToolTip = 'Creates data from Ledger', comment = 'DAN="Opretter data fra kladden, der benyttes nederste skabelon ved oprettelse"';

                    trigger OnAction()
                    var
                        InvoiceImportLedger: Record "CG Invoice Import Ledger Con";
                        Item: Record Item;
                        Customer: Record Customer;
                        ItemTempl: Record "Item Templ.";
                        CustTempl: Record "Customer Templ.";
                        ItemTemplateMgt: Codeunit "Item Templ. Mgt.";
                        CusTemplateMgt: Codeunit "Customer Templ. Mgt.";
                    begin
                        InvoiceImportLedger.Reset();
                        if InvoiceImportLedger.FindSet() then
                            repeat
                                if not item.get(InvoiceImportLedger.ItemID) then begin
                                    Item.init();
                                    Item.Validate("No.", InvoiceImportLedger.ItemID);
                                    Item.Description := CopyStr(InvoiceImportLedger.Description, 1, MaxStrLen(Item.Description));
                                    Item.Insert(true);
                                    ItemTempl.FindLast();
                                    ItemTemplateMgt.ApplyItemTemplate(Item, ItemTempl, true);
                                    Item.Modify(true);
                                end;

                                if not customer.get(InvoiceImportLedger.AXID) then begin
                                    Customer.Init();
                                    Customer.Validate("No.", InvoiceImportLedger.AXID);
                                    Customer.Name := 'Created from Invoice Import Ledger';
                                    Customer.Insert(true);
                                    CustTempl.FindLast();
                                    CusTemplateMgt.ApplyCustomerTemplate(Customer, CustTempl, true);
                                    Customer.Modify(true);
                                end;
                            until InvoiceImportLedger.next() = 0;
                    end;
                }
            }
        }
    }

    local procedure ReadCSVdata()
    var
        // FileManagement: Codeunit "File Management";
        Instream: InStream;
        ImportFileName: Text;
    begin
        //ImportFileName := FileManagement.GetFileName(ImportFileName);
        //        if ImportFilename = '' then
        //            Error(NoFileMsg);

        UploadIntoStream(UploadMsg, '', '', ImportFileName, Instream);
        TempCSVBuffer.Reset();
        TempCSVBuffer.DeleteAll();
        TempCSVBuffer.LoadDataFromStream(Instream, ';');
        TempCSVBuffer.GetNumberOfLines();
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        TempCSVBuffer.Reset();
        if TempCSVBuffer.Get(RowNo, ColNo) then
            exit(TempCSVBuffer.Value)
        else
            exit('');
    end;

    local procedure GetDecValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        TempCSVBuffer.Reset();
        if TempCSVBuffer.Get(RowNo, ColNo) then
            exit(TempCSVBuffer.Value.Replace('.', ','))
        else
            exit('');
    end;


    local procedure ImportCSVData()
    var
        CGInvoiceImportLedgerCon: Record "CG Invoice Import Ledger Con";
        RowNo: Integer;
        MaxRow: Integer;
        LastLineNo: Integer;
        LastFileName: Text[100];
    begin
        RowNo := 0;
        MaxRow := 0;
        LastFileName := '';
        CGInvoiceImportLedgerCon.Reset();
        if CGInvoiceImportLedgerCon.FindLast() then
            LastLineNo := CGInvoiceImportLedgerCon."Line No.";
        MaxRow := TempCSVBuffer.GetNumberOfLines();

        for RowNo := 2 to MaxRow do begin
            CGInvoiceImportLedgerCon.Init();
            //Evaluate(InvoiceImportEntry."Transaction Name", TransName);            
            LastLineNo := LastLineNo + 10000;
            CGInvoiceImportLedgerCon."Line No." := LastLineNo;
            Evaluate(CGInvoiceImportLedgerCon.AXID, GetValueAtCell(RowNo, 1));
            Evaluate(CGInvoiceImportLedgerCon.ProjectNo, GetValueAtCell(RowNo, 2));
            Evaluate(CGInvoiceImportLedgerCon.ItemID, GetValueAtCell(RowNo, 3));
            Evaluate(CGInvoiceImportLedgerCon.VariantID, GetValueAtCell(RowNo, 4));
            Evaluate(CGInvoiceImportLedgerCon.ProjectCategory, GetValueAtCell(RowNo, 5));
            Evaluate(CGInvoiceImportLedgerCon.Description, GetValueAtCell(RowNo, 6));
            Evaluate(CGInvoiceImportLedgerCon.Quantity, GetDecValueAtCell(RowNo, 7));
            Evaluate(CGInvoiceImportLedgerCon."Unit Price", GetDecValueAtCell(RowNo, 8));
            Evaluate(CGInvoiceImportLedgerCon.ServiceID, GetValueAtCell(RowNo, 9));
            Evaluate(CGInvoiceImportLedgerCon.FromDate, GetValueAtCell(RowNo, 10));
            Evaluate(CGInvoiceImportLedgerCon.ToDate, GetValueAtCell(RowNo, 11));
            Evaluate(CGInvoiceImportLedgerCon.Filename, GetValueAtCell(RowNo, 12));
            CGInvoiceImportLedgerCon.Filename := DelChr(CGInvoiceImportLedgerCon.Filename, '<', 'invoice-'); // Remove Invoice prefix
            If CGInvoiceImportLedgerCon.Filename <> '' then begin // Update with Invoice No on lines
                LastFileName := CGInvoiceImportLedgerCon.Filename;
                CGInvoiceImportLedgerCon."Internal Invoice No." := CGInvoiceImportLedgerCon.Filename;
            end else
                CGInvoiceImportLedgerCon."Internal Invoice No." := LastFileName;
            Evaluate(CGInvoiceImportLedgerCon.ExternalID, GetValueAtCell(RowNo, 13));
            CGInvoiceImportLedgerCon.Insert();
        end;
    end;

    local procedure ImportAttachmentsFromZip()
    var
        DocumentAttachment: Record "Document Attachment";
        FileMgt: Codeunit "File Management";
        DataCompression: Codeunit "Data Compression";
        TempBlob: Codeunit "Temp Blob";
        EntryList: List of [Text];
        EntryListKey: Text;
        ZipFileName: Text;
        FileNameFull: Text;
        FileExtension: Text;
        InStream: InStream;
        EntryOutStream: OutStream;
        EntryInStream: InStream;
        Length: Integer;
        FileCount: Integer;
        CsvCount: Integer;
        SelectZIPFileMsg: Label 'Select ZIP File', comment = 'DAN="Vælg Zip file"';
        CSVImportSuccessMsg: Label '%1 CSV files imported successfully', comment = 'DAN="%1 CSV-fil(er) er indlæst"';
        ImportedMsg: Label '%1 attachments Imported successfully.', comment = 'DAN="%1 filer er importeret succefuldt"';
    begin
        //Upload zip file
        if not UploadIntoStream(SelectZIPFileMsg, '', 'Zip Files|*.zip', ZipFileName, InStream) then
            Error('');

        //Extract zip file and store files to list type
        DataCompression.OpenZipArchive(InStream, false);
        DataCompression.GetEntryList(EntryList);
        FileCount := 0;
        CsvCount := 0;

        //Loop files from the list type
        foreach EntryListKey in EntryList do begin
            FileNameFull := CopyStr(FileMgt.GetFileName(EntryListKey), 1, MaxStrLen(FileNameFull));
            FileExtension := CopyStr(FileMgt.GetExtension(EntryListKey), 1, MaxStrLen(FileExtension));

            Clear(TempBlob);
            TempBlob.CreateOutStream(EntryOutStream);
            DataCompression.ExtractEntry(EntryListKey, EntryOutStream, Length);
            TempBlob.CreateInStream(EntryInStream);

            //Import each file where you want
            if FileExtension = 'csv' then begin
                TempCSVBuffer.Reset();
                TempCSVBuffer.DeleteAll();
                TempCSVBuffer.LoadDataFromStream(EntryInStream, ';');
                TempCSVBuffer.GetNumberOfLines();
                ImportCSVData();
                CsvCount := CsvCount + 1;
            end;

            if FileExtension = 'html' then begin
                DocumentAttachment.Init();
                DocumentAttachment.Validate("Table ID", Database::"CG Invoice Import Ledger Con");
                DocumentAttachment.Validate("No.", DelChr(FileNameFull, '<', 'invoice-')); // Remove Invoice prefix
                DocumentAttachment.Validate("File Name", FileNameFull);
                DocumentAttachment.Validate("File Extension", FileExtension);
                DocumentAttachment."Document Reference ID".ImportStream(EntryInStream, FileNameFull);
                DocumentAttachment."Document Flow Sales" := true;
                DocumentAttachment.Insert(true);
            end;
            FileCount := FileCount + 1;
        end;

        //Close the zip file
        DataCompression.CloseZipArchive();

        if CsvCount > 0 then
            Message(CSVImportSuccessMsg, CsvCount);

        if FileCount > 0 then
            Message(ImportedMsg, FileCount);
    end;

    var
        TempCSVBuffer: Record "CSV Buffer" temporary;
        UploadMsg: Label 'Please choose the CSV file', comment = 'DAN="Vælg CSV-fil til indlæsning"';
}