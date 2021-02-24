using Microsoft.EntityFrameworkCore.Migrations;

namespace madrasaty.Migrations
{
    public partial class AddPropertiesToAnnouncement : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "DisplayName",
                table: "Announcements",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "UserPhotoUrl",
                table: "Announcements",
                type: "nvarchar(max)",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "DisplayName",
                table: "Announcements");

            migrationBuilder.DropColumn(
                name: "UserPhotoUrl",
                table: "Announcements");
        }
    }
}
