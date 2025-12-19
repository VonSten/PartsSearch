permissionset 84401 "Part Search Admin"
{
    Assignable = true;
    Permissions = tabledata "Oem Numbers for Items" = RIMD,
        tabledata "Parts Code Retriever Setup" = RIMD,
        tabledata "Picked Items Table" = RIMD,
        tabledata PickedItemsHeader = RIMD,
        tabledata "Request Error" = RIMD,
        tabledata SparePartItemGroup = RIMD,
        table "Oem Numbers for Items" = X,
        table "Parts Code Retriever Setup" = X,
        table "Picked Items Table" = X,
        table PickedItemsHeader = X,
        table "Request Error" = X,
        table SparePartItemGroup = X,
        report "Parts Code Retriever" = X,
        codeunit PartsUtil = X,
        page "Item Reference List Part" = X,
        page "Item Referenece Card" = X,
        page ItemReferences = X,
        page "Oem Numbers for Items" = X,
        page "Part Search Card" = X,
        page "Part Search List Page" = X,
        page "Parts Code Retriever Setup" = X,
        page "Picked Items List" = X,
        page "Request Error" = X,
        page "Spare Part Items" = X,
        page SparePartItemGroup = X;
}