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
xmlport 50200 es2ExportImportRecordLinks
{
    Caption = 'Export/Import Record Links';
    UseRequestPage = false;

    schema
    {
        textelement(RecordLinks)
        {
            MaxOccurs = Once;
            MinOccurs = Zero;
            tableelement(RecordLink; "Record Link")
            {
                MinOccurs = Zero;
                XmlName = 'RecordLink';
                fieldelement(Link_Id; RecordLink."Link ID")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Company; RecordLink.Company)
                {
                    MinOccurs = Zero;
                }
                fieldelement(Created; RecordLink.Created)
                {
                    MinOccurs = Zero;
                }
                fieldelement(Description; RecordLink.Description)
                {
                    MinOccurs = Zero;
                }

                textelement(currRecordID)
                {
                    MinOccurs = Zero;
                }
                fieldelement(UserID; RecordLink."User ID")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Notify; RecordLink.Notify)
                {
                    MinOccurs = Zero;
                }
                fieldelement(ToUserID; RecordLink."To User ID")
                {
                    MinOccurs = Zero;
                }
                fieldelement(Type; RecordLink.Type)
                {
                    MinOccurs = Zero;
                }
                fieldelement(URI; RecordLink.URL1)
                {
                    MinOccurs = Zero;
                }
                textelement(NoteContent)
                {
                    MinOccurs = Zero;
                }

                trigger OnAfterGetRecord()
                begin
                    RecordLink.CalcFields(Note);
                    if RecordLink.Note.HasValue then
                        NoteContent := RecordLinkManagement.ReadNote(RecordLink)
                    else
                        NoteContent := '';
                    currRecordID := Format(RecordLink."Record ID", 0, 9);
                end;

                trigger OnBeforeInsertRecord()
                begin
                    If (NoteContent <> '') then
                        RecordLinkManagement.WriteNote(RecordLink, NoteContent);
                    If (currRecordID <> '') then
                        Evaluate(RecordLink."Record ID", currRecordID);
                end;
            }
        }
    }

    var
        RecordLinkManagement: Codeunit "Record Link Management";
}

