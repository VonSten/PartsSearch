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
                field("Text to correct"; Rec.TextReplaceValues)
                {

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
            action(CorrectItemDesctiptions)
            {
                ApplicationArea = All;
                Caption = 'Correct item descriptions';

                trigger OnAction()
                var
                    ConfirmLabel: Label 'Do you want to correct item descriptions?';
                    PartsUtil: Codeunit PartsUtil;
                begin
                    If Confirm(ConfirmLabel) then begin
                        PartsUtil.CorrectItemDescriptions();
                    end;
                end;
            }

            action(CreateItemRefWithoutPunctuation)
            {
                ApplicationArea = All;
                Caption = 'Create item references without punctuation';

                trigger OnAction()
                var
                    ConfirmLabel: Label 'Do you want to create item references?';
                    PartsUtil: Codeunit PartsUtil;
                begin
                    If Confirm(ConfirmLabel) then begin
                        PartsUtil.CreateItemReferencesWithoutPunctuation();
                    end;
                end;
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

