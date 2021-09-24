namespace DB.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Final : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Students",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        osCislo = c.String(),
                        jmeno = c.String(),
                        prijmeni = c.String(),
                        stav = c.String(),
                        userName = c.String(),
                        strpIdno = c.Int(nullable: false),
                        nazevSp = c.String(),
                        fakultaSp = c.String(),
                        kodSp = c.String(),
                        formaSp = c.String(),
                        typSp = c.String(),
                        typSpKey = c.Int(nullable: false),
                        mistoVyuky = c.String(),
                        rocnik = c.Int(nullable: false),
                        financovani = c.Int(nullable: false),
                        oborKomb = c.String(),
                        oborIdnos = c.Int(nullable: false),
                        email = c.String(),
                        cisloKarty = c.String(),
                        pohlavi = c.String(),
                        evidovanBankovniUcet = c.String(),
                        statutPredmetu = c.String(),
                        ZnamkyPredmetuId = c.Int(nullable: false),
                    })
                .PrimaryKey(t => t.Id)
                .ForeignKey("dbo.ZnamkyPredmetus", t => t.ZnamkyPredmetuId, cascadeDelete: true)
                .Index(t => t.ZnamkyPredmetuId);
            
            CreateTable(
                "dbo.ZnamkyPredmetus",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        znamka = c.String(),
                        nazevPredmetu = c.String(),
                    })
                .PrimaryKey(t => t.Id);
            
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.Students", "ZnamkyPredmetuId", "dbo.ZnamkyPredmetus");
            DropIndex("dbo.Students", new[] { "ZnamkyPredmetuId" });
            DropTable("dbo.ZnamkyPredmetus");
            DropTable("dbo.Students");
        }
    }
}
