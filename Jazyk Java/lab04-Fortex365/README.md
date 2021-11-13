# lab04-template
Third homework template [2021/2022].

Pro následující situaci vhodně navrhněte třídy, rozhraní a vztahy mezi nimi, které splní požadovanou funkcionalitu a budou smysluplné.
V následujícím popisu si za slovo **typ** dosaďte  třída/rozhraní/abstraktní třída/záznam dle toho, co vám přijde nejvhodnější v daném případě.
Vaše řešení může obsahovat i další **typy** a zadané **typy** mohou obsahovat i další funkcionalitu, pokud vám to přijde vhodné.
Vyjmenovaná funkcionalita musí být veřejně dostupná (veřejné API balíčku). Přístupnost ostatní funkcionality záleží na vás, ale měla by dávat smysl.

Zde testy poskytnou jen základní kontrolu. Smysluplnost návrhu posoudí vyučující.

1. Typ **Human** (člověk) s funkcionalitou:
   - Human(...) - Konstruktor lidí s vhodnými argumenty
   - String getName() - vrátí jméno člověka
   - String getSurname() - vrátí příjmení člověka
   - String getFullName() - vrátí jméno a příjmení člověka oddělené mezerou
   - String getID() - vrátí identifikátor člověka - 6 místný String
   - void setID(String ID) - nastaví ID člověku - 6 místný String. Je-li zadané ID kratší doplní se zleva znaky '0'; je-li delší, bere se prvních 6 znaků.
   - int getAge() - vrátí věk člověka
   - boolean setAge(int age) - Pokud je age větší než dosavadní věk a pokud člověk ještě žije, tak nastaví věk na age a vrátí true, jinak neudělá nic a vrátí false.
   - isAlive() - je člověk naživu?
   - void die() - člověk umře (isAlive() bude nadále vracet false)
   - boolean receive(Message m) - přijme zprávu - vrátí true pokud přijal, jinak false
   - Message[] getMessages() - vrátí všechny zprávy, které člověk během své existence přijal setříděné vzestupně lexikograficky podle textu zprávy (ignorujte velikost písmen).
   - boolean sendMessage(String message, Receiver receiver) - odešle zprávu s textem message příjemci receiver; Vrátí true, pokud příjemce přijal a false pokud ne.
2. Typ **Animal** (zvíře) s funkcionalitou:
   - String getName() - vrátí jméno zvířete
   - int getAge() - vrátí věk zvířete
   - boolean setAge(int age) - Pokud je age větší než dosavadní věk a pokud zvíře ještě žije, tak nastaví věk na age a vrátí true, jinak neudělá nic a vrátí false.
   - isAlive() - je zvíře naživu?
   - void die() - zvíře umře (isAlive() bude nadále vracet false)
3. Typ **Sender** (odesílatel) s funkcionalitou:
   - boolean sendMessage(String message, Receiver receiver) - odešle zprávu message příjemci receiver; Vrátí true, pokud příjemce přijal a false pokud ne
4. Typ **Receiver** (příjemce) s funkcionalitou:
   - boolean receive(Message m) - příjme zprávu - vrátí true pokud přijal, jinak false
5. Typ **Message** (zpráva) s funkcionalitou:
   - Message(...) - konstruktor zpráv s vhodnými argumenty
   - String message() - vrátí obsah zprávy
   - Sender sender() - vrátí odesílatele zprávy
6. Typ **Dog** (pes) s funkcionalitou:
   - Dog (...) - konstruktor psů s vhodnými argumenty
   - String getName() - vrátí jméno psa
   - int getAge() - vrátí věk psa
   - boolean setAge(int age) - Pokud je age větší než dosavadní věk a pokud pes ještě žije, tak nastaví věk na age a vrátí true, jinak neudělá nic a vrátí false.
   - isAlive() - je pes naživu?
   - void die() - pes umře (isAlive() bude nadále vracet false)
   - Human getOwner() - vrátí páníčka
   - void setOwner(Human owner) - změní páníčka
   - boolean receive(Message m) - příjme povel od páníčka - vrátí true pokud povel dal páníček, jinak false
   - Message getLastMessage() - vrátí poslední obdržený povel od páníčka
7. Typ **Pigeon** (holub) s funkcionalitou:
   - Pigeon (...) - konstruktor holubů s vhodnými argumenty
   - String getName() - vrátí jméno holuba
   - int getAge() - vrátí věk holuba
   - boolean setAge(int age) - Pokud je age větší než dosavadní věk a pokud holub ještě žije, tak nastaví věk na age a vrátí true, jinak neudělá nic a vrátí false.
   - isAlive() - je holub naživu?
   - void die() - holub umře (isAlive() bude nadále vracet false)
   - Human getOwner() - vrátí majitele holuba
   - void setOwner(Human owner) - změní majitele holuba
   - boolean sendMessage(String message, Receiver receiver) - Předá zprávu s textem message příjemci receiver, vždy vrátí true
8. Typ **Snake** (had) s funkcionalitou:
   - Snake(...) - Konstruktor hadů s vhodnými argumenty
   - String getName() - vrátí jméno hada
   - int getAge() - vrátí věk hada
   - boolean setAge(int age) - Pokud je age větší než dosavadní věk a pokud had ještě žije, tak nastaví věk na age a vrátí true, jinak neudělá nic a vrátí false.
   - boolean bite(Mortal mortal) - zahubí živou bytost
   - isAlive() - je had naživu?
   - void die() - had umře (isAlive() bude nadále vracet false)
9. Typ **Mortal** (smrtelná bytost) s funkcionalitou:
   - boolean isAlive() - žije tato bytost?
   - void die() - bytost umře (isAlive() bude nadále vracet false)
   - int getAge() - vrátí věk smrtelníka
   - boolean setAge(int age) - Pokud je age větší než dosavadní věk a pokud smrtelník ještě žije, tak nastaví věk na age a vrátí true, jinak neudělá nic a vrátí false.
   - v programu by nemělo být možné vytvořit smrtelnou bytost bez konkrétnějšího typu
