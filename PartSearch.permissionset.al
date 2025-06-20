namespace PartSearch;

permissionset 84400 PartSearch
{
    Assignable = true;
    Permissions = tabledata "Parts Code Retriever Setup" = RIMD,
        tabledata "Picked Items Table" = RIMD,
        table "Parts Code Retriever Setup" = X,
        table "Picked Items Table" = X,
        report "Parts Code Retriever" = X,
        page "Item Reference List Part" = X,
        page "Part Search Card" = X,
        page "Part Search List Page" = X,
        page "Parts Code Retriever Setup" = X,
        page "Picked Items List" = X;
}