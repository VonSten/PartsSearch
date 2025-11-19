

page 84409 ItemAvailabilityByLocation
{ /*
    APIPublisher = 'TLT';
    APIGroup = 'parts';
    EntityName = 'itemAvailabilityByLocation';
    EntitySetName = 'itemsAvailabilityByLocation';
    PageType = API;
    APIVersion = 'v2.0';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    SourceTable = Item;
    ODataKeyFields = SystemId;
    SourceTableTemporary = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {


        area(Content)
        {
            repeater(ItemLocations)
            {
                field(id; Rec.SystemId)
                {

                }
                field(itemNo; Rec."No.")
                {

                }
                field(itemDescription; Rec.Description)
                {

                }
                field(locationCode; LocationCode)
                {

                }
                field(locationName; LocationName)
                {

                }

                field(availableInventory; AvailableInventory)
                {

                }

            }
        }
    }
    var
        LocationCode: Code[20];
        LocationName: Text[100];
        AvailableInventory: Decimal;

        ItemsByLocationMatrix: Page "Items by Location Matrix"; // remove
*/

}