namespace DB.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Final2 : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.Students", "strpIdno", c => c.String());
            AlterColumn("dbo.Students", "typSpKey", c => c.String());
            AlterColumn("dbo.Students", "rocnik", c => c.String());
            AlterColumn("dbo.Students", "financovani", c => c.String());
            AlterColumn("dbo.Students", "oborIdnos", c => c.String());
        }
        
        public override void Down()
        {
            AlterColumn("dbo.Students", "oborIdnos", c => c.Int(nullable: false));
            AlterColumn("dbo.Students", "financovani", c => c.Int(nullable: false));
            AlterColumn("dbo.Students", "rocnik", c => c.Int(nullable: false));
            AlterColumn("dbo.Students", "typSpKey", c => c.Int(nullable: false));
            AlterColumn("dbo.Students", "strpIdno", c => c.Int(nullable: false));
        }
    }
}
