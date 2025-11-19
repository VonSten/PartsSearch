table 84404 "Oem Numbers for Items"
{
    DataClassification = ToBeClassified;
    Caption = 'Oem Numbers for Items';

    fields
    {
        field(1; ItemNo; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item;
            Caption = 'Item No.';
        }
        field(2; OemNumber; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Oem Number';
        }
    }

    keys
    {
        key(Key1; ItemNo)
        {
            Clustered = true;
        }
    }
}