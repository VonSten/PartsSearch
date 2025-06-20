table 84402 "Request Error"
{
    DataClassification = ToBeClassified;
    Caption = 'Request Error';



    fields
    {
        field(1; Id; BigInteger)
        {
            AutoIncrement = true;
        }
        field(2; ErrorMessage; Text[250])
        {
            DataClassification = ToBeClassified;

        }
        field(3; Description; Text[250])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(Key1; Id, Description)
        {
            Clustered = true;
        }
    }

}