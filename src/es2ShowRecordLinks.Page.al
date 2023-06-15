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
page 50200 es2ShowRecordLinks
{
    ApplicationArea = Basic, Suite;
    Caption = 'Easystep2 Show record Links';
    PageType = List;
    SourceTable = "Record Link";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Link ID"; Rec."Link ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Link Id as primary key created from autoindex.';
                }

                field(URL1; Rec.URL1)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'The hyperlink containing the location of the file or website referenced.';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'The description of the record link.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'The type of the record link, this could be either Link or Note.';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'The user who created the record link.';
                }
                field(Company; Rec.Company)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'The company the record link is created in.';
                }
                field(Notify; Rec.Notify)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Determines if an other user should be notified with this note.';
                }
                field("To User ID"; Rec."To User ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'The user who should be notified with this note.';
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(ExportUserGroups)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Export Record Links';
                Image = ExportFile;
                ToolTip = 'Export the existing record links to an XML file.';

                trigger OnAction()
                begin
                    ExportRecordLinks('');
                end;
            }
            action(ImportUserGroups)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Record Links';
                Image = Import;
                ToolTip = 'Import Record Links from an XML file.';

                trigger OnAction()
                begin
                    ImportRecordLinks('');
                end;
            }
        }
    }


    /// <summary> 
    /// Exports the record links tableto an xml file.
    /// </summary>
    /// <param name="FileName">Parameter of type Text.</param>
    /// <returns>Return variable "Text".</returns>
    procedure ExportRecordLinks(FileName: Text): Text
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        ExportImportRecordLinks: XMLport es2ExportImportRecordLinks;
        OutStr: OutStream;
    begin
        TempBlob.CreateOutStream(OutStr);
        ExportImportRecordLinks.SetTableView(Rec);
        ExportImportRecordLinks.SetDestination(OutStr);
        ExportImportRecordLinks.Export();
        if FileName = '' then
            exit(FileManagement.BLOBExport(TempBlob, Rec.TableCaption + '.xml', true));
        exit(FileManagement.BLOBExport(TempBlob, FileName, false));
    end;

    /// <summary> 
    /// Imports an XML-file into the Records link table
    /// </summary>
    /// <param name="FileName">Parameter of type Text.</param>
    procedure ImportRecordLinks(FileName: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        ExportImportRecordLinks: XMLport es2ExportImportRecordLinks;
        InStr: InStream;
    begin
        if FileManagement.BLOBImport(TempBlob, FileName) = '' then
            exit;
        TempBlob.CreateInStream(InStr);
        ExportImportRecordLinks.SetSource(InStr);
        ExportImportRecordLinks.Import();
    end;
}
