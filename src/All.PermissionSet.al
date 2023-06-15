permissionset 50200 "All"
{
    Access = Internal;
    Assignable = true;
    Caption = 'All permissions', Locked = true;

    Permissions =
         page es2ShowRecordLinks = X,
         table es2ZetadocsMapping = X,
         xmlport es2ExportImportRecordLinks = X,
         tabledata es2ZetadocsMapping = RIMD;
}