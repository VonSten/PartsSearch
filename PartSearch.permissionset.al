namespace PartSearch;

permissionset 84400 PartSearch
{
    Assignable = true;
    Permissions = tabledata "Parts Code Retriever Setup" = RIMD,
        //tabledata "Picked Items Table" = RIMD,
        table "Parts Code Retriever Setup" = X,
        //table "Picked Items Table" = X,
        report "Parts Code Retriever" = X,
        page "Item Reference List Part" = X,
        page "Part Search Card" = X,
        page "Part Search List Page" = X,
        page "Parts Code Retriever Setup" = X,
        page "Picked Items List" = X,
        tabledata "Oem Numbers for Items" = RIMD,
        tabledata "Request Error" = RIMD,
        tabledata SparePartItemGroup = RIMD,
        table "Oem Numbers for Items" = X,
        table "Request Error" = X,
        table SparePartItemGroup = X,
        page "Oem Numbers for Items" = X,
        page "Request Error" = X,
        page SparePartItemGroup = X;
}