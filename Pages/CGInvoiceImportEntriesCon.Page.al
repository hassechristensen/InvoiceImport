// Find SalesInvoiceHeader from what? Not from SalgsInvoiceNumber this is from SalesHeader and not salgsinvoiceheader

page 63003 "CG Invoice Import Entries Con"
{
    ApplicationArea = All;
    Caption = 'Invoice Import Entries', comment = 'DAN="Fakturaindlæsningsposter"';
    PageType = List;
    ModifyAllowed = false;
    DeleteAllowed = false;
    SourceTable = "CG Invoice Import Entry Con";
    UsageCategory = History;

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
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the LineNo field.';
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Invoice No.', Comment = 'DAN="Salgsfaktura nr."';
                }
                field("Invoice Line No."; Rec."Invoice Line No.")
                {
                    BlankZero = true;
                    ToolTip = 'Specifies the value of the Invoice Line No.', Comment = 'DAN="SalgsfakturaLinje nr."';
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
        area(navigation)
        {
            group("&Line")
            {
                action("&Show Invoice")
                {
                    ApplicationArea = All;
                    Caption = '&Show Invoice', comment = 'DAN="Vis salgsfaktura"';
                    Image = ImportDatabase;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Show Invoice', comment = 'DAN="Vis salgsfaktura"';
                    trigger OnAction()
                    var
                        SalesInvoiceHeader: Record "Sales Invoice Header";
                        SalesInvoice: Page "Sales Invoice";
                        NotFoundMsg: label 'Invoice %1 not found', comment = 'DAN="Salgsfaktura %1 ikke fundet"';
                    begin
                        if Rec.Filename <> '' then begin
                            SalesInvoiceHeader.SetRange("External Document No.", Rec.Filename);
                            if SalesInvoiceHeader.Findlast() then begin
                                SalesInvoice.SetTableView(SalesInvoiceHeader);
                                SalesInvoice.RunModal();
                            end else
                                Message(NotFoundMsg, rec."Invoice No.");
                        end;
                    end;
                }
            }
        }
    }
}