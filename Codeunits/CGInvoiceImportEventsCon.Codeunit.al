
Codeunit 63000 "CG Invoice Import Events Con"
{

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        InvoiceImportLedger: Record "CG Invoice Import Ledger Con";
    begin
        case DocumentAttachment."Table ID" of
            DATABASE::"CG Invoice Import Ledger Con":
                begin
                    RecRef.Open(DATABASE::"CG Invoice Import Ledger Con");
                    InvoiceImportLedger.Setfilter(Filename, '%1', '@' + DocumentAttachment."No.");
                    if InvoiceImportLedger.FindFirst() then
                        RecRef.GetTable(InvoiceImportLedger);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::"CG Invoice Import Ledger Con":
                begin
                    FieldRef := RecRef.Field(31);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::"CG Invoice Import Ledger Con":
                begin
                    FieldRef := RecRef.Field(31);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"CG Invoice Import Ledger Con", 'OnAfterDeleteEvent', '', false, false)]
    local procedure DeleteAttachedDocumentsOnAfterDeleteLedger(var Rec: Record "CG Invoice Import Ledger Con"; RunTrigger: Boolean)
    var
        DocumentAttachment: Record "Document Attachment";
    begin
        if rec.Filename = '' then
            exit;
        DocumentAttachment.SetRange("Table ID", Database::"CG Invoice Import Ledger Con");
        DocumentAttachment.SetRange("No.", Rec.Filename);
        DocumentAttachment.DeleteAll();
    end;
}