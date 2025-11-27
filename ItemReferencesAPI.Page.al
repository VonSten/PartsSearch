

page 84409 ItemReferences
{
    APIPublisher = 'TLT';
    APIGroup = 'parts';
    EntityName = 'itemReferences';
    EntitySetName = 'itemReferences';
    PageType = API;
    APIVersion = 'v2.0';
    ChangeTrackingAllowed = true;
    SourceTable = "Item Reference";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(ItemNo; Rec."Item No.")
                {
                    Caption = 'itemNo';
                }

                field(ReferenceNo; Rec."Reference No.")
                {
                    Caption = 'referenceNo';
                }
                field(ReferenceType; Rec."Reference Type")
                {
                    Caption = 'referenceType';
                }
                field(id; Rec.SystemId)
                {
                    Caption = 'id';
                }
            }

        }
    }



}