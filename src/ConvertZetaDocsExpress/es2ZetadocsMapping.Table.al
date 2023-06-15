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
table 50200 es2ZetadocsMapping
{
    Caption = 'es2ZetadocsMapping';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; RecId; Guid)
        {
            Caption = 'RecId';
            DataClassification = SystemMetadata;
        }
        field(20; Title; Text[250])
        {
            Caption = 'Title';
            DataClassification = CustomerContent;
        }
        field(30; "Archived Date"; DateTime)
        {
            Caption = 'Archived Date';
            DataClassification = CustomerContent;
        }
        field(40; "Archived By"; Text[50])
        {
            Caption = 'Archived By';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(50; SubFolder; Text[100])
        {
            Caption = 'SubFolder';
            DataClassification = CustomerContent;
        }
        field(60; Filename; Text[1024])
        {
            Caption = 'Filename';
            DataClassification = CustomerContent;
        }
        field(70; DocumentType; Text[50])
        {
            Caption = 'DocumentType';
            DataClassification = CustomerContent;
        }
        field(80; ZetadocsRecordLink; Text[100])
        {
            Caption = 'ZetadocsRecordLink';
            DataClassification = SystemMetadata;
        }
        field(90; ZetadocsRecordLinkType; Code[20])
        {
            Caption = 'ZetadocsRecordLinkType';
            DataClassification = SystemMetadata;
        }
        field(100; ZetadocsRecordNo; Code[20])
        {
            Caption = 'ZetadocsRecordNo';
            DataClassification = SystemMetadata;
        }
        field(110; ZetadocsOrganization; Text[100])
        {
            Caption = 'ZetadocsOrganization';
            DataClassification = OrganizationIdentifiableInformation;
        }
    }
    keys
    {
        key(PK; RecId)
        {
            Clustered = true;
        }
    }
}