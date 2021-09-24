using System;

namespace XML_JSON
{
    class Nakaza
    {
        public class Root
        {
            public DailyInf[] Data { get; set; }
            public DateTime Changed { get; set; }
            public string Source { get; set; }
        }

        public class DailyInf
        {
            public int prirustkovy_pocet_nakazenych { get; set; }
            public int kumulativni_pocet_nakazenych { get; set; }
            public string datum { get; set; }
        }
    }
}
