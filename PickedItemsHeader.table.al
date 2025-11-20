table 84405 PickedItemsHeader

{
    Caption = 'Picked Item Header';


    fields
    {
        field(1; SellToCustomerNo; Code[20])
        {
            Caption = 'Kliendi kood';
            TableRelation = Customer;

        }
        field(2; LocationCode; Code[10])
        {
            Caption = 'Lao kood';
            TableRelation = Location;
        }

        field(3; UserID; Code[50])
        {
            Caption = 'Kasutaja ID';
        }
    }
    keys
    {
        key(Key1; UserID)
        {
            Clustered = true;
        }
    }
}