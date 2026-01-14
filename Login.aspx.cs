using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Data;
using System.Data.SqlClient;
using MarineTravelAgency.App_Code;

namespace MarineTravelAgency
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/Dashboard.aspx");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text; // In real app, hash this before sending to DB

            SqlParameter[] p = {
                new SqlParameter("@Username", username),
                new SqlParameter("@PasswordHash", password) 
            };

            // Using stored procedure 'sp_LoginUser'
            DataTable users = SqlHelper.ExecuteQuery("sp_LoginUser", p, true);

            if (users.Rows.Count > 0)
            {
                DataRow userNum = users.Rows[0];
                string userId = userNum["UserId"].ToString();
                string role = userNum["Role"].ToString();

                // Create Authentication Ticket
                FormsAuthentication.RedirectFromLoginPage(username, false);
                
                // Store extra info in Session
                Session["UserID"] = userId;
                Session["Role"] = role;

                // Handle ProfileImageUrl with resilience in case SQL SP update hasn't been run yet
                if (userNum.Table.Columns.Contains("ProfileImageUrl"))
                {
                    Session["ProfilePic"] = userNum["ProfileImageUrl"] != null ? userNum["ProfileImageUrl"].ToString() : "";
                }
                else
                {
                    // Fallback to default if column missing
                    Session["ProfilePic"] = "~/assets/img/default-avatar.png";
                }
            }
            else
            {
                lblError.Text = "Invalid username or password.";
                lblError.Visible = true;
            }
        }
    }
}
