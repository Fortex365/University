#KMI/JJ1 Sixth homework 2021/2022

1. Využijte třídu OrdersDataStream, která simuluje vstupní datový proud objednávek.
+ Třída má implementované metody readInt(), readUTF(), readFloat()
+ Data objednávek jsou uspořádána v tomto pořadí: id (int), customer (String), product (String), price (float), quantity (int)
+ Objednávku reprezentujte pomocí záznamu

2. Vytvořte třídu OrdersDatabase, která reprezentuje persistentní databázi objednávek.
+ Konstruktor OrdersDatabase(String filename)
+ OrdersDataStream getOrdersDataStream() - vrátí datový proud, na které je databáze napojená
+ void setOrdersDataStream(OrdersDataStream ordersDataStream) - nastaví datový proud objednávek
+ Order loadOrder(DataInput di) - načte objednávku z datového vstupu "di", ale neukládá ji.
+ void loadNextOrder() - načte další objednávku z datového proudu a uloží ji do databáze (soubor)
+ void writeOrders(List\<Order\> orders, boolean append) - zapíše objednávky do databáze (append false databázi přepíše)
+ List\<Order\> readOrders() - načte objednávky z databáze
+ boolean removeOrder(int id) - odstraní objednávku z databáze a uloží databázi
+ String toString() - překryjite metodu toString, aby vracela výpis všech objednávek v databázi
+ Databáze musí být persistetní, tzn. po restartu programu v ní data zůstávají

3. Vytvořte třídu Client, která reprezentuje konzolové rozhraní nad databází.
+ OrdersDatabase getDatabase() - vrátí databázi
+ void loop() - smyčka pro interakci s uživatelem
+ uživatel zadá číslo akce: 0 (exit), 1 (connect), 2 (print), 3 (load next order), 4 (remove order)
+ Akce 0 (exit) smyčku ukončí
+ Akce 1 (connect) od uživatele načte jméno databáze a připojí se k ní
+ Akce 2 (print) vypíše databázi
+ Akce 3 (load next order) načte do databáze další objednávku z datového proudu
+ Akce 4 (remove order) od uživatele načete id objednávky a objednávku z databáze odstraní
+ Viz. obrázek
+ ![Konzole](console.png?raw=true)
