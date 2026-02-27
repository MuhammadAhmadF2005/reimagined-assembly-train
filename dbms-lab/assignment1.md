erDiagram
    REGION ||--o{ NATION : Contains
    NATION ||--o{ CUSTOMER : Resides_In
    NATION ||--o{ SUPPLIER : Located_In
    CUSTOMER ||--o{ ORDER : Places
    ORDER ||--|{ LINE_ITEM : Has_Item
    
    %% M:N Relationship with attributes is often resolved as an associative entity in modern tools
    SUPPLIER ||--o{ SUPPLIER_PART : "Supplies (M:N)"
    PART ||--o{ SUPPLIER_PART : "Supplied_By (M:N)"
    
    LINE_ITEM }|--|| PART : Item_Part
    LINE_ITEM }|--|| SUPPLIER : Item_Supplier

    REGION {
        string Region_ID PK
        string Region_Name
        string Comment
    }
    NATION {
        string Nation_ID PK
        string Nation_Name
        string Comment
    }
    CUSTOMER {
        string Customer_ID PK
        string Name
        string Address
        string Phone
        float Account_Balance
        string Market_Segment
        string Comment
    }
    SUPPLIER {
        string Supplier_ID PK
        string Name
        string Address
        string Phone
        float Account_Balance
        string Comment
    }
    PART {
        string Part_ID PK
        string Part_Name
        string Manufacturer
        string Brand
        string Type
        string Size
        string Container_Type
        float Retail_Price
        string Comment
    }
    ORDER {
        string Order_ID PK
        date Order_Date
        string Order_Status
        float Total_Price
        string Order_Priority
        string Clerk_Name
        string Shipping_Priority
        string Comment
    }
    LINE_ITEM {
        int Quantity
        float Extended_Price
        float Discount
        float Tax
        string Return_Flag
        string Line_Status
        date Ship_Date
        date Commit_Date
        date Receipt_Date
        string Ship_Instructions
        string Ship_Mode
        string Comment
    }
    SUPPLIER_PART {
        int Available_Quantity
        float Supply_Cost
        string Comment
    }