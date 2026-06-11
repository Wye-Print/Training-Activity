table 50004 "Training Activity Detail"
{
    Caption = 'Training Activity Detail';
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
        }
        field(10; "Activity Date"; DateTime)
        {
            Caption = 'Date';
            DataClassification = SystemMetadata;
        }
        field(20; "Description"; Text[150])
        {
            Caption = 'Description';
            DataClassification = SystemMetadata;
        }
        field(30; "Table No."; Integer)
        {
            Caption = 'Table No.';
            DataClassification = SystemMetadata;
        }
        field(31; "Record ID"; RecordId)
        {
            Caption = 'Record ID';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(ByDate; "Activity Date") { }
    }
}
