using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DB
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
}
