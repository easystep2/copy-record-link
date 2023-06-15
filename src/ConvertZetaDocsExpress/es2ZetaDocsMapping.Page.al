// ------------------------------------------------------------------------------------------------
// Copyright 2019 (c) EasyStep2 BV. All rights reserved. 
// This file is part of EasyStep2 Copy Record Links extension.
//
//  EasyStep2 Copy Record Links is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  EasyStep2 software is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this EasyStep2 software. If not, see <https://www.gnu.org/licenses/>.
page 50201 es2ZetaDocsMapping
{
    ApplicationArea = All;
    Caption = 'es2ZetaDocsMapping';
    PageType = List;
    SourceTable = es2ZetadocsMapping;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Archived By"; Rec."Archived By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Archived By field.';
                }
                field("Archived Date"; Rec."Archived Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Archived Date field.';
                }
                field(DocumentType; Rec.DocumentType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DocumentType field.';
                }
                field(Filename; Rec.Filename)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Filename field.';
                }
                field(RecId; Rec.RecId)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RecId field.';
                }
                field(SubFolder; Rec.SubFolder)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SubFolder field.';
                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Title field.';
                }
                field(ZetadocsOrganization; Rec.ZetadocsOrganization)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ZetadocsOrganization field.';
                }
                field(ZetadocsRecordLink; Rec.ZetadocsRecordLink)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ZetadocsRecordLink field.';
                }
                field(ZetadocsRecordLinkType; Rec.ZetadocsRecordLinkType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ZetadocsRecordLinkType field.';
                }
                field(ZetadocsRecordNo; Rec.ZetadocsRecordNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ZetadocsRecordNo field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(GenRecordLink)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Generate Record Links';
                Image = ExportFile;
                ToolTip = 'Generate the record links of this Zetadocs reference.';

                trigger OnAction()
                var
                    ZetaDocsMapping: record es2ZetadocsMapping;
                begin
                    CurrPage.SetSelectionFilter(ZetaDocsMapping);
                    GenerateRecordLink(ZetaDocsMapping);
                end;
            }
        }
    }

    var
        RecordLink: record "Record Link";
        BlobstorageUriTok: Label 'https://wwbcstorage.blob.core.windows.net/zetadocs/Zetadocs%1Archive/%2/%3';


    local procedure GenerateRecordLink(var ZetaDocsMapping: record es2ZetadocsMapping)
    begin
        If ZetaDocsMapping.FindSet() then
            repeat
                RecordLink.Init();
                RecordLink."Link ID" := 0;
                RecordLink.Description := ZetaDocsMapping.Title;
                RecordLink.Company := CurrentCompany();
                RecordLink.Notify := false;
                RecordLink."Record ID" := GetRecordID(ZetaDocsMapping);
                RecordLink.Type := RecordLink.Type::Link;
                RecordLink.URL1 := StrSubstNo(BlobstorageUriTok, ' ', ZetaDocsMapping.SubFolder, ZetaDocsMapping.Filename);
                RecordLink.Insert();
            until ZetaDocsMapping.Next() = 0;
    end;

    local procedure GetRecordID(ZetaDocsMapping: record es2ZetadocsMapping) MyRecordID: RecordId
    var
        SalesHeader: Record "Sales Header";
        SalesHeaderArch: Record "Sales Header Archive";
        SalesInvHeader: Record "Sales Invoice Header";
        PurchHeader: Record "Purchase Header";
        PurchHeaderArch: Record "Purchase Header Archive";
        PurchInvHeader: Record "Purch. Inv. Header";
        RecRef: recordRef;
        SalesDocType: enum "Sales Document Type";
        PurchDocType: enum "Purchase Document Type";
        DocTypeInt: Integer;
        TableId: Integer;
        MyRecordIDText: Text;
    begin
        ZetaDocsMapping.ZetaDocsRecordLink := ConvertStr(ZetaDocsMapping.ZetaDocsRecordLink, '|', ',');
        Evaluate(TableId, SelectStr(2, ZetaDocsMapping.ZetaDocsRecordLink));
        Case TableId of
            Database::"Sales Header":
                begin
                    Evaluate(DocTypeInt, SelectStr(3, ZetaDocsMapping.ZetaDocsRecordLink));
                    SalesDocType := "Sales Document Type".FromInteger(DocTypeInt);
                    SalesHeader.SetRange("Document Type", SalesDocType);
                    SalesHeader.SetRange("No.", ZetaDocsMapping.ZetadocsRecordNo);
                    if SalesHeader.FindFirst() then begin
                        MyRecordID := SalesHeader.RecordId();
                        exit;
                    end
                    else begin
                        SalesHeaderArch.SetRange("Document Type", SalesDocType);
                        SalesHeaderArch.SetRange("No.", ZetaDocsMapping.ZetadocsRecordNo);
                        if SalesHeaderArch.FindLast() then begin
                            MyRecordID := SalesHeaderArch.RecordId();
                            exit;
                        end
                        else begin
                            SalesInvHeader.SetRange("Order No.", ZetaDocsMapping.ZetadocsRecordNo);
                            if SalesInvHeader.FindLast() then begin
                                MyRecordID := SalesInvHeader.RecordId();
                                exit;
                            end;
                        end;
                    end;
                end;
            Database::"Purchase Header":
                begin
                    Evaluate(DocTypeInt, SelectStr(3, ZetaDocsMapping.ZetaDocsRecordLink));
                    PurchDocType := "Purchase Document Type".FromInteger(DocTypeInt);
                    PurchHeader.SetRange("Document Type", PurchDocType);
                    PurchHeader.SetRange("No.", ZetaDocsMapping.ZetadocsRecordNo);
                    if PurchHeader.FindFirst() then begin
                        MyRecordID := PurchHeader.RecordId();
                        exit;
                    end
                    else begin
                        PurchHeaderArch.SetRange("Document Type", PurchDocType);
                        PurchHeaderArch.SetRange("No.", ZetaDocsMapping.ZetadocsRecordNo);
                        if PurchHeaderArch.FindLast() then begin
                            MyRecordID := PurchHeaderArch.RecordId();
                            exit;
                        end
                        else begin
                            PurchInvHeader.SetRange("Order No.", ZetaDocsMapping.ZetadocsRecordNo);
                            if PurchInvHeader.FindLast() then begin
                                MyRecordID := PurchInvHeader.RecordId();
                                exit;
                            end;
                        end;
                    end;
                end;
            else begin
                RecRef.Open(TableId);
                MyRecordIDText := RecRef.Name;
                // if ZetaDocsMapping.ZetadocsRecordNo = 'NULL' then
                    MyRecordIDText += ':' + SelectStr(3, ZetaDocsMapping.ZetaDocsRecordLink);
                // else
                //     MyRecordIDText += ':' + SelectStr(3, ZetaDocsMapping.ZetaDocsRecordLink) + ',' + SelectStr(4, ZetaDocsMapping.ZetaDocsRecordLink);
                Evaluate(MyRecordID, MyRecordIDText);
            end;
        end;
    end;
}