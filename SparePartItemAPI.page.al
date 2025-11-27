page 84408 "Spare Part Items"
{
    APIPublisher = 'TLT';
    APIGroup = 'parts';
    EntityName = 'item';
    EntitySetName = 'items';
    PageType = API;
    APIVersion = 'v2.0';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    SourceTable = Item;
    ODataKeyFields = SystemId;
    Editable = false;
    DataAccessIntent = ReadOnly;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {

                }
                field(number; Rec."No.")
                {
                }
                field(description; Rec.Description)
                {

                }
                field(baseUnitOfMeasureId; Rec."Unit of Measure Id")
                {

                }
                field(baseUnitOfMeasureCode; Rec."Base Unit of Measure")
                {

                }
                field(itemCategoryId; Rec."Item Category Id")
                {

                }
                field(itemCategoryCode; Rec."Item Category Code")
                {

                }
                field(blocked; Rec.Blocked)
                {
                }
                field(modified; Rec.SystemModifiedAt)
                {

                }

                field(Inventory; Rec.Inventory)
                {
                }

                field(location; Rec."Location Filter")
                {

                }



            }
        }
    }



    Trigger OnOpenPage()
    var
        SparePartItemGroupRec: Record "SparePartItemGroup";
        CategoryFilter: Text;
    begin
        if SparePartItemGroupRec.FindSet() then begin
            repeat
                if CategoryFilter <> '' then
                    CategoryFilter += '|';
                CategoryFilter += SparePartItemGroupRec.Category;
            until SparePartItemGroupRec.Next() = 0;

            if CategoryFilter <> '' then
                Rec.SetFilter("Item Category Code", CategoryFilter);
        end;
    end;



}



