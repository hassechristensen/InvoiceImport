
Codeunit 63001 "CG Create Invoice Con"
{
    TableNo = "CG Invoice Import Ledger Con";

    trigger OnRun()
    begin
        InvoiceImportLedger.Copy(Rec);
        Code();
        Rec := InvoiceImportLedger;
    end;

    local procedure "Code"()
    // var
    //     InvoiceImportLedger2: Record "CG Invoice Import Ledger Con";
    //     FileFound: Text;
    //     Stop: Boolean;
    //     LastLineNo: Integer;
    begin
        // // Find all Invoices lines for same Customer and Project (Filename is set on first line)
        // InvoiceImportLedger2.reset();
        // InvoiceImportLedger2.SetCurrentKey("Line No.");
        // InvoiceImportLedger2.setfilter("Line No.", '>=%1', InvoiceImportLedger."Line No.");
        // InvoiceImportLedger2.setrange(AXID, InvoiceImportLedger.AXID);
        // InvoiceImportLedger.setrange(ProjectNo, InvoiceImportLedger.ProjectNo);
        // FileFound := '';
        // Stop := false;
        // LastLineNo := 0;
        // repeat
        //     if (InvoiceImportLedger2.Filename <> '') and (LastLineNo <> 0) then
        //         stop := true
        //     else
        //         LastLineNo := InvoiceImportLedger2."Line No.";
        // until (InvoiceImportLedger2.Next() = 0) or Stop;

        // Create Invoice & Invoice Lines
        InvoiceImportSetup.Get();
        // InvoiceImportSetup.TestField("Sales Line Account");

        InvoiceImportLedger.Reset();
        InvoiceImportLedger.setrange(AXID, InvoiceImportLedger.AXID);
        InvoiceImportLedger.SetRange("Internal Invoice No.", InvoiceImportLedger."Internal Invoice No.");
        // InvoiceImportLedger.setrange(ProjectNo, InvoiceImportLedger.ProjectNo);
        // InvoiceImportLedger.setrange("Line No.", InvoiceImportLedger."Line No.", LastLineNo);
        repeat
            // Create Sales Invoice Header
            if InvoiceImportLedger.Filename <> '' then
                CreateInvoiceHeader(InvoiceImportLedger);

            CreateInvoiceLine(invoiceImportLedger);
        until InvoiceImportLedger.Next() = 0;

        // if InvoiceImportsetup."Create and Post" then begin
        // end;        
    end;

    /// <summary>
    /// CreateInvoiceHeader.
    /// </summary>
    local procedure CreateInvoiceHeader(SalesInvoiceHeaderLedger: Record "CG Invoice Import Ledger Con")
    var
        SalesInvoiceHeaderLedger2: Record "CG Invoice Import Ledger Con";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        salesCreditMemoHeader: Record "Sales Cr.Memo Header";
        DimensionValue: Record "Dimension Value";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
        SalesPostInvoice: Codeunit "Sales Post Invoice";
        SalesDocumentExistTxt: Label 'Document %3 %1 already exists for Invoice %2', comment = 'DAN="Salgsdokument %3 %1 findes allerede med Externt Bilagsnr. %2"';
    begin
        // Check Invoice Type
        InvoiceSum := 0;
        SalesInvoiceHeaderLedger2.reset();
        SalesInvoiceHeaderLedger2.SetRange(AXID, SalesInvoiceHeaderLedger.AXID);
        SalesInvoiceHeaderLedger2.SetRange(ProjectNo, SalesInvoiceHeaderLedger.ProjectNo);
        SalesInvoiceHeaderLedger2.SetRange("Internal Invoice No.", SalesInvoiceHeaderLedger."Internal Invoice No.");
        if SalesInvoiceHeaderLedger2.FindSet() then
            repeat
                InvoiceSum := InvoiceSum + round(SalesInvoiceHeaderLedger2."Unit Price" * SalesInvoiceHeaderLedger2.Quantity);
            until SalesInvoiceHeaderLedger2.Next() = 0;

        SalesHeader.init();

        // Check for Document exists.
        IF InvoiceSum > 0 then begin
            SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
            SalesInvoiceHeader.Reset();
            SalesInvoiceHeader.setrange("External Document No.", SalesInvoiceHeaderLedger.Filename);
            if SalesInvoiceHeader.FindFirst() then
                Error(SalesDocumentExistTxt, SalesInvoiceHeader."No.", SalesInvoiceHeader."External Document No.", SalesHeader."Document Type"::Invoice);
        end else begin
            SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
            salesCreditMemoHeader.Reset();
            salesCreditMemoHeader.setrange("External Document No.", SalesInvoiceHeaderLedger.Filename);
            if salesCreditMemoHeader.FindFirst() then
                Error(SalesDocumentExistTxt, salesCreditMemoHeader."No.", salesCreditMemoHeader."External Document No.", SalesHeader."Document Type"::"Credit Memo");
        end;

        SalesHeader."No." := '';
        SalesHeader.insert(true);
        SalesHeader.SetHideValidationDialog(true);
        SalesHeader.Validate("Order Date", Today());
        SalesHeader.Validate("Posting Date", SalesInvoiceHeaderLedger.ToDate);
        SalesHeader.Validate("Sell-to Customer No.", SalesInvoiceHeaderLedger.AXID);
        SalesHeader."CG From Date Con" := SalesInvoiceHeaderLedger.FromDate;
        SalesHeader."CG To Date Con" := SalesInvoiceHeaderLedger.ToDate;
        SalesHeader."CG Service ID Con" := SalesInvoiceHeaderLedger.ServiceID;
        SalesHeader.ExternalID := SalesInvoiceHeaderLedger.ExternalID;

        if SalesInvoiceHeaderLedger.Filename <> '' then  // Fjern html tags og punktum
            SalesHeader.Validate("External Document No.", SalesInvoiceHeaderLedger.Filename);
        //SalesHeader.validate("CG Invoice Import Ledger Con", SalesInvoiceHeaderLedger.Filename); // Transfer Dimensions from Import

        // Insert Project Dimension on SalesHeader
        if SalesInvoiceHeaderLedger.ProjectNo <> '' then begin
            InvoiceImportsetup.Get();
            If InvoiceImportsetup."Project Dimension Code" <> '' then begin
                IF not DimensionValue.get(InvoiceImportsetup."Project Dimension Code", SalesInvoiceHeaderLedger.ProjectNo) then begin
                    DimensionValue.Init();
                    DimensionValue."Dimension Code" := InvoiceImportsetup."Project Dimension Code";
                    DimensionValue.validate(Code, SalesInvoiceHeaderLedger.ProjectNo);
                    DimensionValue.Insert(true);
                end;
                // Insert Dimensions
                DimMgt.GetDimensionSet(TempDimSetEntry, SalesHeader."Dimension Set ID");
                TempDimSetEntry.Init();
                TempDimSetEntry."Dimension Code" := InvoiceImportsetup."Project Dimension Code";
                TempDimSetEntry."Dimension Value Code" := SalesInvoiceHeaderLedger.ProjectNo;
                TempDimSetEntry.Insert(true);
                SalesHeader."Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
                DimMgt.UpdateGlobalDimFromDimSetID(SalesHeader."Dimension Set ID", SalesHeader."Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 2 Code");
            end;
        end;
        SalesHeader.Modify();

        // Move Attachment to Sales Invoice               
        if InvoiceImportsetup."Transfer Attachments" then
            CopyMyAttachments(SalesInvoiceHeaderLedger, SalesHeader);
    end;

    /// <summary>
    /// CreateInvoiceLine.
    /// </summary>
    local procedure CreateInvoiceLine(InvoiceImportLedger1: Record "CG Invoice Import Ledger Con");
    var
        InvoiceImportEntry: Record "CG Invoice Import Entry Con";
        InvoiceImportLedger2: Record "CG Invoice Import Ledger Con";
        TransferExtendedText: Codeunit "Transfer Extended Text";

    begin
        InitSalesLine(SalesLine);
        // 001: >>        
        // SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
        // SalesLine.Validate("No.", InvoiceImportSetup."Sales Line Account");
        SalesLine.Validate(Type, SalesLine.Type::Item);
        SalesLine.Validate("No.", InvoiceImportLedger1.ItemID);
        if SalesLine."Unit of Measure" = '' then
            SalesLine.validate("Unit of Measure Code", InvoiceImportSetup."Unit of Measure Code");
        // 001: <<
        SalesLine.Description := CopyStr(InvoiceImportLedger1.Description, 1, MaxStrLen(SalesLine.Description));
        SalesLine."Description 2" := CopyStr(InvoiceImportLedger1.Description, MaxStrLen(SalesLine."Description 2") + 1, MaxStrLen(SalesLine."Description 2"));
        if InvoiceSum > 0 then
            SalesLine.Validate(Quantity, (InvoiceImportLedger1.Quantity)) else
            SalesLine.Validate(Quantity, (-InvoiceImportLedger1.Quantity));  // Credit note Line
        SalesLine.Validate("Unit Price", (InvoiceImportLedger1."Unit Price"));
        SalesLine."CG From Date Con" := InvoiceImportLedger1.FromDate;
        SalesLine."CG To Date Con" := InvoiceImportLedger1.ToDate;
        SalesLine."CG Service ID Con" := InvoiceImportLedger1.ServiceID;
        SalesLine.ExternalID := InvoiceImportLedger1.ExternalID;
        SalesLine.Insert(true);

        if TransferExtendedText.SalesCheckIfAnyExtText(SalesLine, TRUE) then
            TransferExtendedText.InsertSalesExtText(SalesLine);

        // Move from Ledger to Entry
        invoiceImportEntry.Init();
        invoiceImportEntry.TransferFields(InvoiceImportLedger1);
        invoiceImportEntry."Invoice No." := SalesHeader."No.";
        invoiceImportEntry."Invoice Line No." := SalesLine."Line No.";
        invoiceImportEntry."Entry No." := 0;  // AutoIncrement
        invoiceImportEntry.Insert();

        // Delete InvoiceImportLedger
        invoiceImportLedger2 := InvoiceImportLedger1;
        InvoiceImportLedger2.Delete();
    end;

    /// <summary>
    /// InitSalesLine.
    /// </summary>
    /// <param name="SalesLine2">VAR Record "Sales Line".</param>
    local procedure InitSalesLine(var SalesLine2: Record "Sales Line");
    begin
        SalesLine2.INIT();
        SalesLine2."Document Type" := SalesHeader."Document Type";
        SalesLine2."Document No." := SalesHeader."No.";
        LineNo := LineNo + 1;
        SalesLine2."Line No." := LineNo * 10000;
    end;

    procedure CopyMyAttachments(var InvoiceImportLedgerFrom: Record "CG Invoice Import Ledger Con"; SalesHeaderTo: Record "Sales Header");
    var
        FromDocumentAttachment: Record "Document Attachment";
        ToDocumentAttachment: Record "Document Attachment";
    begin
        FromDocumentAttachment.SetRange("Table ID", Database::"CG Invoice Import Ledger Con");
        if FromDocumentAttachment.IsEmpty() then
            exit;
        FromDocumentAttachment.SetRange("No.", InvoiceImportLedgerFrom.Filename);
        if FromDocumentAttachment.FindSet() then
            repeat
                Clear(ToDocumentAttachment);
                ToDocumentAttachment.Init();
                ToDocumentAttachment.TransferFields(FromDocumentAttachment);
                ToDocumentAttachment.Validate("Table ID", Database::"Sales Header");
                ToDocumentAttachment.Validate("No.", SalesHeaderTo."No.");
                if InvoiceSum >= 0 then
                    ToDocumentAttachment.Validate("Document Type", Enum::"Attachment Document Type"::Invoice)
                else
                    ToDocumentAttachment.Validate("Document Type", Enum::"Attachment Document Type"::"Credit Memo");
                if not ToDocumentAttachment.Insert(true) then;
                ToDocumentAttachment."Attached Date" := FromDocumentAttachment."Attached Date";
                ToDocumentAttachment.Modify();
            until FromDocumentAttachment.Next() = 0;
    end;

    var
        InvoiceImportLedger: Record "CG Invoice Import Ledger Con";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        InvoiceImportSetup: Record "CG Invoice Import Setup Con";
        LineNo: Integer;
        InvoiceSum: Decimal;
}