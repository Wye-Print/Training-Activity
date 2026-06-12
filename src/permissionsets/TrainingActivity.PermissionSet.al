permissionset 50003 "Training Activity"
{
    Caption = 'Training Activity';
    Assignable = true;

    Permissions =
        tabledata "User" = R,
        tabledata Customer = R,
        tabledata Vendor = R,
        tabledata Item = R,
        tabledata "Sales Header" = R,
        tabledata "Purchase Header" = R,
        tabledata "Purch. Rcpt. Header" = R,
        tabledata "Item Ledger Entry" = R,
        tabledata "Capacity Ledger Entry" = R,
        tabledata "Production Order" = R,
        tabledata "PVS Case" = R,
        codeunit "Training Activity Mgt" = X,
        page "Training Activity" = X,
        page "Training Activity Detail" = X;
}
