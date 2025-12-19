namespace PartSearch;

permissionset 84400 PartSearch
{
    Assignable = true;
    Permissions = tabledata "Parts Code Retriever Setup" = RIMD,
        page "Item Reference List Part" = X,
        page "Part Search Card" = X,
        page "Part Search List Page" = X,
        page "Picked Items List" = X,
        tabledata SparePartItemGroup = RIMD,
        table "Request Error" = X,
        table SparePartItemGroup = X,
        tabledata "Picked Items Table" = RIMD,
        tabledata PickedItemsHeader = RIMD,
        table "Picked Items Table" = X,
        table PickedItemsHeader = X,
        page "Item Referenece Card" = X,
        page ItemReferences = X,
        page "Spare Part Items" = X,
        codeunit PartsUtil = X;
}