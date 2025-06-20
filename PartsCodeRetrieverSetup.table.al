table 84400 "Parts Code Retriever Setup"
{
    Caption = 'Parts Code Retriever Setup';

    fields
    {

        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Main url"; Text[250])
        {
            Caption = 'Main url';
        }
        field(3; "Sub url"; Text[250])
        {
            Caption = 'Sub url';
        }
        field(4; "API Key"; Text[250])
        {
            Caption = 'API Key';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}

