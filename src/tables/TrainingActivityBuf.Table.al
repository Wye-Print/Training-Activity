table 50000 "Training Activity Buf"
{
    Caption = 'Training Activity Buffer';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "User Security ID"; Guid)
        {
            Caption = 'User Security ID';
            DataClassification = SystemMetadata;
        }
        field(2; "User Name"; Code[50])
        {
            Caption = 'User Name';
            DataClassification = SystemMetadata;
        }
        field(3; "Full Name"; Text[80])
        {
            Caption = 'Employee';
            DataClassification = SystemMetadata;
        }

        field(10; "Customer Count"; Integer) { Caption = 'Customer Count'; DataClassification = SystemMetadata; }
        field(11; "Vendor Count"; Integer) { Caption = 'Vendor Count'; DataClassification = SystemMetadata; }
        field(12; "Item Count"; Integer) { Caption = 'Item Count'; DataClassification = SystemMetadata; }
        field(13; "Estimate Count"; Integer) { Caption = 'Estimate Count'; DataClassification = SystemMetadata; }
        field(14; "Order Count"; Integer) { Caption = 'Quote to Order Count'; DataClassification = SystemMetadata; }
        field(15; "Sales Order Count"; Integer) { Caption = 'Sales Order Count'; DataClassification = SystemMetadata; }
        field(16; "Schedule Count"; Integer) { Caption = 'Schedule Count'; DataClassification = SystemMetadata; }
        field(17; "Purchase Count"; Integer) { Caption = 'Purchasing Count'; DataClassification = SystemMetadata; }
        field(18; "Receipt Count"; Integer) { Caption = 'Receipt Count'; DataClassification = SystemMetadata; }
        field(19; "Shop Floor Count"; Integer) { Caption = 'Shop Floor Count'; DataClassification = SystemMetadata; }
        field(20; "Released Count"; Integer) { Caption = 'Released Count'; DataClassification = SystemMetadata; }

        field(30; "Customer Last"; Date) { Caption = 'Customer Last'; DataClassification = SystemMetadata; }
        field(31; "Vendor Last"; Date) { Caption = 'Vendor Last'; DataClassification = SystemMetadata; }
        field(32; "Item Last"; Date) { Caption = 'Item Last'; DataClassification = SystemMetadata; }
        field(33; "Estimate Last"; Date) { Caption = 'Estimate Last'; DataClassification = SystemMetadata; }
        field(34; "Order Last"; Date) { Caption = 'Quote to Order Last'; DataClassification = SystemMetadata; }
        field(35; "Sales Order Last"; Date) { Caption = 'Sales Order Last'; DataClassification = SystemMetadata; }
        field(36; "Schedule Last"; Date) { Caption = 'Schedule Last'; DataClassification = SystemMetadata; }
        field(37; "Purchase Last"; Date) { Caption = 'Purchasing Last'; DataClassification = SystemMetadata; }
        field(38; "Receipt Last"; Date) { Caption = 'Receipt Last'; DataClassification = SystemMetadata; }
        field(39; "Shop Floor Last"; Date) { Caption = 'Shop Floor Last'; DataClassification = SystemMetadata; }
        field(40; "Released Last"; Date) { Caption = 'Released Last'; DataClassification = SystemMetadata; }

        field(50; "Customer"; Text[20]) { Caption = 'Customer'; DataClassification = SystemMetadata; }
        field(51; "Vendor"; Text[20]) { Caption = 'Vendor'; DataClassification = SystemMetadata; }
        field(52; "Item"; Text[20]) { Caption = 'Item'; DataClassification = SystemMetadata; }
        field(53; "Estimate"; Text[20]) { Caption = 'Estimate'; DataClassification = SystemMetadata; }
        field(54; "Quote to Order"; Text[20]) { Caption = 'Quote to Order'; DataClassification = SystemMetadata; }
        field(55; "Sales Order"; Text[20]) { Caption = 'Sales Order'; DataClassification = SystemMetadata; }
        field(56; "Schedule"; Text[20]) { Caption = 'Schedule'; DataClassification = SystemMetadata; }
        field(57; "Purchasing"; Text[20]) { Caption = 'Purchasing'; DataClassification = SystemMetadata; }
        field(58; "Receipt"; Text[20]) { Caption = 'Receipt'; DataClassification = SystemMetadata; }
        field(59; "Shop Floor"; Text[20]) { Caption = 'Shop Floor'; DataClassification = SystemMetadata; }
        field(60; "Released"; Text[20]) { Caption = 'Released'; DataClassification = SystemMetadata; }

        field(90; "Completed"; Integer) { Caption = 'Completed (of 11)'; DataClassification = SystemMetadata; }
        field(91; "Last Activity"; Date) { Caption = 'Last Activity'; DataClassification = SystemMetadata; }
    }

    keys
    {
        key(PK; "User Security ID") { Clustered = true; }
        key(Progress; "Completed", "Last Activity") { }
    }
}
