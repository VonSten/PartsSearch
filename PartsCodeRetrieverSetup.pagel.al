page 84401 "Parts Code Retriever Setup"
{
    PageType = Card;
    SourceTable = "Parts Code Retriever Setup";
    Editable = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    Caption = 'Parts Code Retriever Setup';
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Main url"; Rec."Main url")
                {
                    ApplicationArea = All;
                }
                field("Sub url"; Rec."Sub url")
                {
                    ApplicationArea = All;
                }
                field("API Key"; Rec."API Key")
                {
                    ApplicationArea = All;
                }
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action(GetSparePartCodes)
            {
                ApplicationArea = All;
                Caption = 'Get Spare Part Codes';
                RunObject = report "Parts Code Retriever";
            }

        }
    }
    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;


}

