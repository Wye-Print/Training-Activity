codeunit 50001 "Training Activity Mgt"
{
    // Builds a read-only, per-employee snapshot of training milestones.
    // Each milestone is proven by rows BC already stamps (SystemCreatedBy /
    // SystemCreatedAt, plus PVS Case datetime fields) - nothing is written.

    procedure Build(var Buf: Record "Training Activity Buf" temporary)
    begin
        Buf.Reset();
        Buf.DeleteAll();

        CollectCustomers(Buf);
        CollectVendors(Buf);
        CollectItems(Buf);
        CollectCaseEstimate(Buf);
        CollectQuoteToOrder(Buf);
        CollectSalesOrders(Buf);
        CollectSchedule(Buf);
        CollectPurchasing(Buf);
        CollectReceipts(Buf);
        CollectShopFloor(Buf);
        CollectReleased(Buf);

        Finalize(Buf);
    end;

    local procedure CollectCustomers(var Buf: Record "Training Activity Buf" temporary)
    var
        Customer: Record Customer;
    begin
        if Customer.FindSet() then
            repeat
                AddHit(Buf, Customer.SystemCreatedBy, 1, DT2Date(Customer.SystemCreatedAt));
            until Customer.Next() = 0;
    end;

    local procedure CollectVendors(var Buf: Record "Training Activity Buf" temporary)
    var
        Vendor: Record Vendor;
    begin
        if Vendor.FindSet() then
            repeat
                AddHit(Buf, Vendor.SystemCreatedBy, 2, DT2Date(Vendor.SystemCreatedAt));
            until Vendor.Next() = 0;
    end;

    local procedure CollectItems(var Buf: Record "Training Activity Buf" temporary)
    var
        Item: Record Item;
    begin
        if Item.FindSet() then
            repeat
                AddHit(Buf, Item.SystemCreatedBy, 3, DT2Date(Item.SystemCreatedAt));
            until Item.Next() = 0;
    end;

    local procedure CollectCaseEstimate(var Buf: Record "Training Activity Buf" temporary)
    var
        PVSCase: Record "PVS Case";
    begin
        PVSCase.SetFilter("Estimate Completed DateTime", '<>%1', 0DT);
        if PVSCase.FindSet() then
            repeat
                AddHit(Buf, PVSCase.SystemCreatedBy, 4, DT2Date(PVSCase."Estimate Completed DateTime"));
            until PVSCase.Next() = 0;
    end;

    local procedure CollectQuoteToOrder(var Buf: Record "Training Activity Buf" temporary)
    var
        PVSCase: Record "PVS Case";
        WhenDate: Date;
    begin
        PVSCase.SetFilter("Order No.", '<>%1', '');
        if PVSCase.FindSet() then
            repeat
                WhenDate := DT2Date(PVSCase."Order DateTime");
                if WhenDate = 0D then
                    WhenDate := PVSCase."Order Date";
                AddHit(Buf, PVSCase.SystemCreatedBy, 5, WhenDate);
            until PVSCase.Next() = 0;
    end;

    local procedure CollectSalesOrders(var Buf: Record "Training Activity Buf" temporary)
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        if SalesHeader.FindSet() then
            repeat
                AddHit(Buf, SalesHeader.SystemCreatedBy, 6, DT2Date(SalesHeader.SystemCreatedAt));
            until SalesHeader.Next() = 0;
    end;

    local procedure CollectSchedule(var Buf: Record "Training Activity Buf" temporary)
    var
        ProdOrder: Record "Production Order";
    begin
        if ProdOrder.FindSet() then
            repeat
                AddHit(Buf, ProdOrder.SystemCreatedBy, 7, DT2Date(ProdOrder.SystemCreatedAt));
            until ProdOrder.Next() = 0;
    end;

    local procedure CollectPurchasing(var Buf: Record "Training Activity Buf" temporary)
    var
        PurchHeader: Record "Purchase Header";
    begin
        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Order);
        if PurchHeader.FindSet() then
            repeat
                AddHit(Buf, PurchHeader.SystemCreatedBy, 8, DT2Date(PurchHeader.SystemCreatedAt));
            until PurchHeader.Next() = 0;
    end;

    local procedure CollectReceipts(var Buf: Record "Training Activity Buf" temporary)
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
    begin
        if PurchRcptHeader.FindSet() then
            repeat
                AddHit(Buf, PurchRcptHeader.SystemCreatedBy, 9, DT2Date(PurchRcptHeader.SystemCreatedAt));
            until PurchRcptHeader.Next() = 0;
    end;

    local procedure CollectShopFloor(var Buf: Record "Training Activity Buf" temporary)
    var
        CapLedgEntry: Record "Capacity Ledger Entry";
    begin
        if CapLedgEntry.FindSet() then
            repeat
                AddHit(Buf, CapLedgEntry.SystemCreatedBy, 10, DT2Date(CapLedgEntry.SystemCreatedAt));
            until CapLedgEntry.Next() = 0;
    end;

    local procedure CollectReleased(var Buf: Record "Training Activity Buf" temporary)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemLedgEntry.SetFilter(Quantity, '>%1', 0);
        if ItemLedgEntry.FindSet() then
            repeat
                AddHit(Buf, ItemLedgEntry.SystemCreatedBy, 11, DT2Date(ItemLedgEntry.SystemCreatedAt));
            until ItemLedgEntry.Next() = 0;
    end;

    local procedure AddHit(var Buf: Record "Training Activity Buf" temporary; UserSID: Guid; ItemNo: Integer; WhenDate: Date)
    begin
        if IsNullGuid(UserSID) then
            exit;
        if WhenDate = 0D then
            exit;

        if not Buf.Get(UserSID) then begin
            Buf.Init();
            Buf."User Security ID" := UserSID;
            ResolveUser(UserSID, Buf);
            Buf.Insert();
        end;

        case ItemNo of
            1:
                Bump(Buf."Customer Count", Buf."Customer Last", WhenDate);
            2:
                Bump(Buf."Vendor Count", Buf."Vendor Last", WhenDate);
            3:
                Bump(Buf."Item Count", Buf."Item Last", WhenDate);
            4:
                Bump(Buf."Estimate Count", Buf."Estimate Last", WhenDate);
            5:
                Bump(Buf."Order Count", Buf."Order Last", WhenDate);
            6:
                Bump(Buf."Sales Order Count", Buf."Sales Order Last", WhenDate);
            7:
                Bump(Buf."Schedule Count", Buf."Schedule Last", WhenDate);
            8:
                Bump(Buf."Purchase Count", Buf."Purchase Last", WhenDate);
            9:
                Bump(Buf."Receipt Count", Buf."Receipt Last", WhenDate);
            10:
                Bump(Buf."Shop Floor Count", Buf."Shop Floor Last", WhenDate);
            11:
                Bump(Buf."Released Count", Buf."Released Last", WhenDate);
        end;

        Buf.Modify();
    end;

    local procedure Bump(var "Count": Integer; var LastDate: Date; WhenDate: Date)
    begin
        "Count" := "Count" + 1;
        if WhenDate > LastDate then
            LastDate := WhenDate;
    end;

    local procedure ResolveUser(UserSID: Guid; var Buf: Record "Training Activity Buf" temporary)
    var
        User: Record User;
    begin
        User.SetRange("User Security ID", UserSID);
        if User.FindFirst() then begin
            Buf."User Name" := User."User Name";
            if User."Full Name" <> '' then
                Buf."Full Name" := User."Full Name"
            else
                Buf."Full Name" := User."User Name";
        end else
            Buf."Full Name" := CopyStr(Format(UserSID), 1, MaxStrLen(Buf."Full Name"));
    end;

    local procedure Finalize(var Buf: Record "Training Activity Buf" temporary)
    begin
        if Buf.FindSet() then
            repeat
                Buf."Customer" := Cell(Buf."Customer Count", Buf."Customer Last");
                Buf."Vendor" := Cell(Buf."Vendor Count", Buf."Vendor Last");
                Buf."Item" := Cell(Buf."Item Count", Buf."Item Last");
                Buf."Estimate" := Cell(Buf."Estimate Count", Buf."Estimate Last");
                Buf."Quote to Order" := Cell(Buf."Order Count", Buf."Order Last");
                Buf."Sales Order" := Cell(Buf."Sales Order Count", Buf."Sales Order Last");
                Buf."Schedule" := Cell(Buf."Schedule Count", Buf."Schedule Last");
                Buf."Purchasing" := Cell(Buf."Purchase Count", Buf."Purchase Last");
                Buf."Receipt" := Cell(Buf."Receipt Count", Buf."Receipt Last");
                Buf."Shop Floor" := Cell(Buf."Shop Floor Count", Buf."Shop Floor Last");
                Buf."Released" := Cell(Buf."Released Count", Buf."Released Last");

                Buf."Completed" := CountCompleted(Buf);
                Buf."Last Activity" := MaxLast(Buf);
                Buf.Modify();
            until Buf.Next() = 0;
    end;

    local procedure Cell("Count": Integer; LastDate: Date): Text[20]
    begin
        if "Count" <= 0 then
            exit('');
        exit(CopyStr(StrSubstNo('%1 %2 %3', "Count", '·', Format(LastDate, 0, '<Month,2>/<Day,2>')), 1, 20));
    end;

    local procedure CountCompleted(var Buf: Record "Training Activity Buf" temporary): Integer
    var
        Done: Integer;
    begin
        Done := 0;
        Done += DoneFlag(Buf."Customer Count");
        Done += DoneFlag(Buf."Vendor Count");
        Done += DoneFlag(Buf."Item Count");
        Done += DoneFlag(Buf."Estimate Count");
        Done += DoneFlag(Buf."Order Count");
        Done += DoneFlag(Buf."Sales Order Count");
        Done += DoneFlag(Buf."Schedule Count");
        Done += DoneFlag(Buf."Purchase Count");
        Done += DoneFlag(Buf."Receipt Count");
        Done += DoneFlag(Buf."Shop Floor Count");
        Done += DoneFlag(Buf."Released Count");
        exit(Done);
    end;

    local procedure DoneFlag("Count": Integer): Integer
    begin
        if "Count" > 0 then
            exit(1);
        exit(0);
    end;

    local procedure MaxLast(var Buf: Record "Training Activity Buf" temporary): Date
    var
        Latest: Date;
    begin
        Latest := 0D;
        Latest := Later(Latest, Buf."Customer Last");
        Latest := Later(Latest, Buf."Vendor Last");
        Latest := Later(Latest, Buf."Item Last");
        Latest := Later(Latest, Buf."Estimate Last");
        Latest := Later(Latest, Buf."Order Last");
        Latest := Later(Latest, Buf."Sales Order Last");
        Latest := Later(Latest, Buf."Schedule Last");
        Latest := Later(Latest, Buf."Purchase Last");
        Latest := Later(Latest, Buf."Receipt Last");
        Latest := Later(Latest, Buf."Shop Floor Last");
        Latest := Later(Latest, Buf."Released Last");
        exit(Latest);
    end;

    local procedure Later(A: Date; B: Date): Date
    begin
        if B > A then
            exit(B);
        exit(A);
    end;

    procedure BuildDetail(UserSID: Guid; ItemNo: Integer; var Detail: Record "Training Activity Detail" temporary)
    var
        NextNo: Integer;
    begin
        Detail.Reset();
        Detail.DeleteAll();
        NextNo := 0;
        if IsNullGuid(UserSID) then
            exit;

        case ItemNo of
            1:
                DetailCustomers(UserSID, Detail, NextNo);
            2:
                DetailVendors(UserSID, Detail, NextNo);
            3:
                DetailItems(UserSID, Detail, NextNo);
            4:
                DetailEstimate(UserSID, Detail, NextNo);
            5:
                DetailQuoteToOrder(UserSID, Detail, NextNo);
            6:
                DetailSalesOrders(UserSID, Detail, NextNo);
            7:
                DetailSchedule(UserSID, Detail, NextNo);
            8:
                DetailPurchasing(UserSID, Detail, NextNo);
            9:
                DetailReceipts(UserSID, Detail, NextNo);
            10:
                DetailShopFloor(UserSID, Detail, NextNo);
            11:
                DetailReleased(UserSID, Detail, NextNo);
        end;
    end;

    local procedure DetailCustomers(UserSID: Guid; var Detail: Record "Training Activity Detail" temporary; var NextNo: Integer)
    var
        Customer: Record Customer;
    begin
        Customer.SetRange(SystemCreatedBy, UserSID);
        if Customer.FindSet() then
            repeat
                AddDetail(Detail, NextNo, Customer.SystemCreatedAt, StrSubstNo('%1  %2', Customer."No.", Customer.Name), Customer.RecordId);
            until Customer.Next() = 0;
    end;

    local procedure DetailVendors(UserSID: Guid; var Detail: Record "Training Activity Detail" temporary; var NextNo: Integer)
    var
        Vendor: Record Vendor;
    begin
        Vendor.SetRange(SystemCreatedBy, UserSID);
        if Vendor.FindSet() then
            repeat
                AddDetail(Detail, NextNo, Vendor.SystemCreatedAt, StrSubstNo('%1  %2', Vendor."No.", Vendor.Name), Vendor.RecordId);
            until Vendor.Next() = 0;
    end;

    local procedure DetailItems(UserSID: Guid; var Detail: Record "Training Activity Detail" temporary; var NextNo: Integer)
    var
        Item: Record Item;
    begin
        Item.SetRange(SystemCreatedBy, UserSID);
        if Item.FindSet() then
            repeat
                AddDetail(Detail, NextNo, Item.SystemCreatedAt, StrSubstNo('%1  %2', Item."No.", Item.Description), Item.RecordId);
            until Item.Next() = 0;
    end;

    local procedure DetailEstimate(UserSID: Guid; var Detail: Record "Training Activity Detail" temporary; var NextNo: Integer)
    var
        PVSCase: Record "PVS Case";
    begin
        PVSCase.SetRange(SystemCreatedBy, UserSID);
        PVSCase.SetFilter("Estimate Completed DateTime", '<>%1', 0DT);
        if PVSCase.FindSet() then
            repeat
                AddDetail(Detail, NextNo, PVSCase."Estimate Completed DateTime", StrSubstNo('Case %1  %2', PVSCase.ID, PVSCase."Sell-To Name"), PVSCase.RecordId);
            until PVSCase.Next() = 0;
    end;

    local procedure DetailQuoteToOrder(UserSID: Guid; var Detail: Record "Training Activity Detail" temporary; var NextNo: Integer)
    var
        PVSCase: Record "PVS Case";
        WhenDT: DateTime;
    begin
        PVSCase.SetRange(SystemCreatedBy, UserSID);
        PVSCase.SetFilter("Order No.", '<>%1', '');
        if PVSCase.FindSet() then
            repeat
                WhenDT := PVSCase."Order DateTime";
                if WhenDT = 0DT then
                    WhenDT := CreateDateTime(PVSCase."Order Date", 0T);
                AddDetail(Detail, NextNo, WhenDT, StrSubstNo('Order %1  %2', PVSCase."Order No.", PVSCase."Sell-To Name"), PVSCase.RecordId);
            until PVSCase.Next() = 0;
    end;

    local procedure DetailSalesOrders(UserSID: Guid; var Detail: Record "Training Activity Detail" temporary; var NextNo: Integer)
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange(SystemCreatedBy, UserSID);
        if SalesHeader.FindSet() then
            repeat
                AddDetail(Detail, NextNo, SalesHeader.SystemCreatedAt, StrSubstNo('%1  %2', SalesHeader."No.", SalesHeader."Sell-to Customer Name"), SalesHeader.RecordId);
            until SalesHeader.Next() = 0;
    end;

    local procedure DetailSchedule(UserSID: Guid; var Detail: Record "Training Activity Detail" temporary; var NextNo: Integer)
    var
        ProdOrder: Record "Production Order";
    begin
        ProdOrder.SetRange(SystemCreatedBy, UserSID);
        if ProdOrder.FindSet() then
            repeat
                AddDetail(Detail, NextNo, ProdOrder.SystemCreatedAt, StrSubstNo('%1  %2', ProdOrder."No.", ProdOrder.Description), ProdOrder.RecordId);
            until ProdOrder.Next() = 0;
    end;

    local procedure DetailPurchasing(UserSID: Guid; var Detail: Record "Training Activity Detail" temporary; var NextNo: Integer)
    var
        PurchHeader: Record "Purchase Header";
    begin
        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Order);
        PurchHeader.SetRange(SystemCreatedBy, UserSID);
        if PurchHeader.FindSet() then
            repeat
                AddDetail(Detail, NextNo, PurchHeader.SystemCreatedAt, StrSubstNo('%1  %2', PurchHeader."No.", PurchHeader."Buy-from Vendor Name"), PurchHeader.RecordId);
            until PurchHeader.Next() = 0;
    end;

    local procedure DetailReceipts(UserSID: Guid; var Detail: Record "Training Activity Detail" temporary; var NextNo: Integer)
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
    begin
        PurchRcptHeader.SetRange(SystemCreatedBy, UserSID);
        if PurchRcptHeader.FindSet() then
            repeat
                AddDetail(Detail, NextNo, PurchRcptHeader.SystemCreatedAt, StrSubstNo('%1  %2', PurchRcptHeader."No.", PurchRcptHeader."Buy-from Vendor Name"), PurchRcptHeader.RecordId);
            until PurchRcptHeader.Next() = 0;
    end;

    local procedure DetailShopFloor(UserSID: Guid; var Detail: Record "Training Activity Detail" temporary; var NextNo: Integer)
    var
        CapLedgEntry: Record "Capacity Ledger Entry";
    begin
        CapLedgEntry.SetRange(SystemCreatedBy, UserSID);
        if CapLedgEntry.FindSet() then
            repeat
                AddDetail(Detail, NextNo, CapLedgEntry.SystemCreatedAt, StrSubstNo('Entry %1  Item %2', CapLedgEntry."Entry No.", CapLedgEntry."Item No."), CapLedgEntry.RecordId);
            until CapLedgEntry.Next() = 0;
    end;

    local procedure DetailReleased(UserSID: Guid; var Detail: Record "Training Activity Detail" temporary; var NextNo: Integer)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemLedgEntry.SetRange(SystemCreatedBy, UserSID);
        ItemLedgEntry.SetFilter(Quantity, '>%1', 0);
        if ItemLedgEntry.FindSet() then
            repeat
                AddDetail(Detail, NextNo, ItemLedgEntry.SystemCreatedAt, StrSubstNo('Entry %1  Item %2', ItemLedgEntry."Entry No.", ItemLedgEntry."Item No."), ItemLedgEntry.RecordId);
            until ItemLedgEntry.Next() = 0;
    end;

    local procedure AddDetail(var Detail: Record "Training Activity Detail" temporary; var NextNo: Integer; WhenDT: DateTime; Description: Text; RecID: RecordId)
    begin
        NextNo += 1;
        Detail.Init();
        Detail."Entry No." := NextNo;
        Detail."Activity Date" := WhenDT;
        Detail."Description" := CopyStr(Description, 1, MaxStrLen(Detail."Description"));
        Detail."Table No." := RecID.TableNo();
        Detail."Record ID" := RecID;
        Detail.Insert();
    end;

    procedure OpenRecord(RecID: RecordId)
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        Item: Record Item;
        PVSCase: Record "PVS Case";
        SalesHeader: Record "Sales Header";
        PurchHeader: Record "Purchase Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        ProdOrder: Record "Production Order";
        CapLedgEntry: Record "Capacity Ledger Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        RecRef: RecordRef;
    begin
        if RecID.TableNo() = 0 then
            exit;
        RecRef.Open(RecID.TableNo());
        if RecRef.Get(RecID) then
            case RecID.TableNo() of
                Database::Customer:
                    begin
                        RecRef.SetTable(Customer);
                        Page.Run(Page::"Customer Card", Customer);
                    end;
                Database::Vendor:
                    begin
                        RecRef.SetTable(Vendor);
                        Page.Run(Page::"Vendor Card", Vendor);
                    end;
                Database::Item:
                    begin
                        RecRef.SetTable(Item);
                        Page.Run(Page::"Item Card", Item);
                    end;
                Database::"PVS Case":
                    begin
                        RecRef.SetTable(PVSCase);
                        Page.Run(Page::"PVS Case Card", PVSCase);
                    end;
                Database::"Sales Header":
                    begin
                        RecRef.SetTable(SalesHeader);
                        Page.Run(Page::"Sales Order", SalesHeader);
                    end;
                Database::"Purchase Header":
                    begin
                        RecRef.SetTable(PurchHeader);
                        Page.Run(Page::"Purchase Order", PurchHeader);
                    end;
                Database::"Purch. Rcpt. Header":
                    begin
                        RecRef.SetTable(PurchRcptHeader);
                        Page.Run(Page::"Posted Purchase Receipt", PurchRcptHeader);
                    end;
                Database::"Production Order":
                    begin
                        RecRef.SetTable(ProdOrder);
                        Page.Run(0, ProdOrder);
                    end;
                Database::"Capacity Ledger Entry":
                    begin
                        RecRef.SetTable(CapLedgEntry);
                        Page.Run(0, CapLedgEntry);
                    end;
                Database::"Item Ledger Entry":
                    begin
                        RecRef.SetTable(ItemLedgEntry);
                        Page.Run(Page::"Item Ledger Entries", ItemLedgEntry);
                    end;
            end;
        RecRef.Close();
    end;
}
