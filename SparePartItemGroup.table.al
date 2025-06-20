table 84403 SparePartItemGroup
{
    DataClassification = ToBeClassified;
    Caption = 'Spare Part Item Group';

    fields
    {
        field(1; Category; Code[20])
        {
            TableRelation = "Item Category";

        }
    }

    keys
    {
        key(Key1; Category)
        {
            Clustered = true;
        }
    }

    procedure CountParts()
    var
        _Item: Record Item;
        _Count: Integer;
    begin
        _Item.Reset();
        if Rec.FindSet() then begin
            repeat
                _Item.SetRange("Item Category Code", Rec.Category);
                _Count := _Count + _Item.Count();
            until Rec.Next() = 0;
        end;
        Message('Count: %1', _Count);
    end;

}