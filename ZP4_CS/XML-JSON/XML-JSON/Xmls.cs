using System;

namespace XML_JSON
{
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false)]
    public partial class studentiPredmetu
    {

        private studentiPredmetuStudentPredmetu[] studentPredmetuField;

        [System.Xml.Serialization.XmlElementAttribute("studentPredmetu")]
        public studentiPredmetuStudentPredmetu[] studentPredmetu
        {
            get
            {
                return this.studentPredmetuField;
            }
            set
            {
                this.studentPredmetuField = value;
            }
        }
    }

    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
    public partial class studentiPredmetuStudentPredmetu
    {

        private string osCisloField;

        private string jmenoField;

        private string prijmeniField;

        private string stavField;

        private string userNameField;

        private ushort stprIdnoField;

        private string nazevSpField;

        private string fakultaSpField;

        private string kodSpField;

        private string formaSpField;

        private string typSpField;

        private byte typSpKeyField;

        private string mistoVyukyField;

        private byte rocnikField;

        private byte financovaniField;

        private string oborKombField;

        private string oborIdnosField;

        private string emailField;

        private string cisloKartyField;

        private string pohlaviField;

        private string evidovanBankovniUcetField;

        private string statutPredmetuField;

        public string osCislo
        {
            get
            {
                return this.osCisloField;
            }
            set
            {
                this.osCisloField = value;
            }
        }

        public string jmeno
        {
            get
            {
                return this.jmenoField;
            }
            set
            {
                this.jmenoField = value;
            }
        }

        public string prijmeni
        {
            get
            {
                return this.prijmeniField;
            }
            set
            {
                this.prijmeniField = value;
            }
        }

        public string stav
        {
            get
            {
                return this.stavField;
            }
            set
            {
                this.stavField = value;
            }
        }

        public string userName
        {
            get
            {
                return this.userNameField;
            }
            set
            {
                this.userNameField = value;
            }
        }

        public ushort stprIdno
        {
            get
            {
                return this.stprIdnoField;
            }
            set
            {
                this.stprIdnoField = value;
            }
        }

        public string nazevSp
        {
            get
            {
                return this.nazevSpField;
            }
            set
            {
                this.nazevSpField = value;
            }
        }

        public string fakultaSp
        {
            get
            {
                return this.fakultaSpField;
            }
            set
            {
                this.fakultaSpField = value;
            }
        }

        public string kodSp
        {
            get
            {
                return this.kodSpField;
            }
            set
            {
                this.kodSpField = value;
            }
        }

        public string formaSp
        {
            get
            {
                return this.formaSpField;
            }
            set
            {
                this.formaSpField = value;
            }
        }

        public string typSp
        {
            get
            {
                return this.typSpField;
            }
            set
            {
                this.typSpField = value;
            }
        }

        public byte typSpKey
        {
            get
            {
                return this.typSpKeyField;
            }
            set
            {
                this.typSpKeyField = value;
            }
        }

        public string mistoVyuky
        {
            get
            {
                return this.mistoVyukyField;
            }
            set
            {
                this.mistoVyukyField = value;
            }
        }

        public byte rocnik
        {
            get
            {
                return this.rocnikField;
            }
            set
            {
                this.rocnikField = value;
            }
        }

        public byte financovani
        {
            get
            {
                return this.financovaniField;
            }
            set
            {
                this.financovaniField = value;
            }
        }

        public string oborKomb
        {
            get
            {
                return this.oborKombField;
            }
            set
            {
                this.oborKombField = value;
            }
        }

        public string oborIdnos
        {
            get
            {
                return this.oborIdnosField;
            }
            set
            {
                this.oborIdnosField = value;
            }
        }

        public string email
        {
            get
            {
                return this.emailField;
            }
            set
            {
                this.emailField = value;
            }
        }

        public string cisloKarty
        {
            get
            {
                return this.cisloKartyField;
            }
            set
            {
                this.cisloKartyField = value;
            }
        }

        public string pohlavi
        {
            get
            {
                return this.pohlaviField;
            }
            set
            {
                this.pohlaviField = value;
            }
        }

        public string evidovanBankovniUcet
        {
            get
            {
                return this.evidovanBankovniUcetField;
            }
            set
            {
                this.evidovanBankovniUcetField = value;
            }
        }

        public string statutPredmetu
        {
            get
            {
                return this.statutPredmetuField;
            }
            set
            {
                this.statutPredmetuField = value;
            }
        }
    }


    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false)]
    public partial class predmetyKatedry
    {

        private predmetyKatedryPredmetKatedry[] predmetKatedryField;

        [System.Xml.Serialization.XmlElementAttribute("predmetKatedry")]
        public predmetyKatedryPredmetKatedry[] predmetKatedry
        {
            get
            {
                return this.predmetKatedryField;
            }
            set
            {
                this.predmetKatedryField = value;
            }
        }
    }

    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
    public partial class predmetyKatedryPredmetKatedry
    {

        private string katedraField;

        private string zkratkaField;

        private ushort rokField;

        private string nazevField;

        private string semestrField;

        private string maVyukuField;

        private string vyukaZSField;

        private string vyukaLSField;

        private string jazyk1Field;

        private string jazyk2Field;

        private string nabizetPrijezdyEctsField;

        private byte pocetStudentuField;

        private byte aMaxField;

        private bool aMaxFieldSpecified;

        private byte bMaxField;

        private bool bMaxFieldSpecified;

        private byte cMaxField;

        private bool cMaxFieldSpecified;

        private byte aSkutField;

        private byte bSkutField;

        private byte cSkutField;

        public string katedra
        {
            get
            {
                return this.katedraField;
            }
            set
            {
                this.katedraField = value;
            }
        }

        public string zkratka
        {
            get
            {
                return this.zkratkaField;
            }
            set
            {
                this.zkratkaField = value;
            }
        }

        public ushort rok
        {
            get
            {
                return this.rokField;
            }
            set
            {
                this.rokField = value;
            }
        }

        public string nazev
        {
            get
            {
                return this.nazevField;
            }
            set
            {
                this.nazevField = value;
            }
        }

        public string semestr
        {
            get
            {
                return this.semestrField;
            }
            set
            {
                this.semestrField = value;
            }
        }

        public string maVyuku
        {
            get
            {
                return this.maVyukuField;
            }
            set
            {
                this.maVyukuField = value;
            }
        }

        public string vyukaZS
        {
            get
            {
                return this.vyukaZSField;
            }
            set
            {
                this.vyukaZSField = value;
            }
        }

        public string vyukaLS
        {
            get
            {
                return this.vyukaLSField;
            }
            set
            {
                this.vyukaLSField = value;
            }
        }

        public string jazyk1
        {
            get
            {
                return this.jazyk1Field;
            }
            set
            {
                this.jazyk1Field = value;
            }
        }

        public string jazyk2
        {
            get
            {
                return this.jazyk2Field;
            }
            set
            {
                this.jazyk2Field = value;
            }
        }

        public string nabizetPrijezdyEcts
        {
            get
            {
                return this.nabizetPrijezdyEctsField;
            }
            set
            {
                this.nabizetPrijezdyEctsField = value;
            }
        }

        public byte pocetStudentu
        {
            get
            {
                return this.pocetStudentuField;
            }
            set
            {
                this.pocetStudentuField = value;
            }
        }

        public byte aMax
        {
            get
            {
                return this.aMaxField;
            }
            set
            {
                this.aMaxField = value;
            }
        }

        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public bool aMaxSpecified
        {
            get
            {
                return this.aMaxFieldSpecified;
            }
            set
            {
                this.aMaxFieldSpecified = value;
            }
        }

        public byte bMax
        {
            get
            {
                return this.bMaxField;
            }
            set
            {
                this.bMaxField = value;
            }
        }

        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public bool bMaxSpecified
        {
            get
            {
                return this.bMaxFieldSpecified;
            }
            set
            {
                this.bMaxFieldSpecified = value;
            }
        }

        public byte cMax
        {
            get
            {
                return this.cMaxField;
            }
            set
            {
                this.cMaxField = value;
            }
        }

        [System.Xml.Serialization.XmlIgnoreAttribute()]
        public bool cMaxSpecified
        {
            get
            {
                return this.cMaxFieldSpecified;
            }
            set
            {
                this.cMaxFieldSpecified = value;
            }
        }

        public byte aSkut
        {
            get
            {
                return this.aSkutField;
            }
            set
            {
                this.aSkutField = value;
            }
        }

        public byte bSkut
        {
            get
            {
                return this.bSkutField;
            }
            set
            {
                this.bSkutField = value;
            }
        }

        public byte cSkut
        {
            get
            {
                return this.cSkutField;
            }
            set
            {
                this.cSkutField = value;
            }
        }
    }
}
