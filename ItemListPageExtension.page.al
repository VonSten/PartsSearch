pageextension 84410 ItemListPageExtension extends "Item List"
{
    layout
    {
        addfirst(factboxes)
        {
            part(ItemReferenceCardPart; "Item Referenece Card EXT")
            {
                ApplicationArea = All;
                SubPageLink = "Item No." = FIELD("No.");
            }
        }
    }

}