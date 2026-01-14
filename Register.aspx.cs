using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using MarineTravelAgency.App_Code; // Fixed namespace

namespace MarineTravelAgency
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text; // In real app, hash this!
            string confirm = txtConfirmPass.Text;
            string email = txtEmail.Text.Trim();
            string firstName = txtFirstName.Text.Trim();
            string lastName = txtLastName.Text.Trim();
            string phoneNumber = txtPhoneNumber.Text.Trim();

            if (password != confirm)
            {
                ShowError("Passwords do not match.");
                return;
            }

            // Schema: @Username, @PasswordHash, @Email, @FullName, @Role
            SqlParameter[] p = {
                new SqlParameter("@Username", username),
                new SqlParameter("@PasswordHash", password),
                new SqlParameter("@Email", email),
                new SqlParameter("@FirstName", firstName),
                new SqlParameter("@LastName", lastName),
                new SqlParameter("@PhoneNumber", phoneNumber),
                new SqlParameter("@Role", "User") // Default role
            };

            try
            {
                SqlHelper.ExecuteNonQuery("sp_RegisterUser", p, true);
                
                lblMsg.Text = "Registration successful! Redirecting...";
                lblMsg.CssClass = "alert alert-success d-block mb-3";
                lblMsg.Visible = true;
                
                // Redirect after small delay effectively handled by user click usually, but here we can just auto-login or wait.
                // For better UX, let's redirect immediately or show success.
                Response.AddHeader("REFRESH", "2;URL=Login.aspx");
            }
            catch (SqlException ex)
            {
                // Handle custom errors from Stored Procedure
                if (ex.Number == 51001) ShowError("Username is already taken.");
                else if (ex.Number == 51002) ShowError("Email is already registered.");
                else if (ex.Number == 2627) ShowError("Account already exists.");
                else ShowError("Database Error: " + ex.Message);
            }
            catch (Exception ex)
            {
                ShowError("Error: " + ex.Message);
            }
        }

        private void ShowError(string message)
        {
            lblMsg.Text = message;
            lblMsg.CssClass = "alert alert-danger d-block mb-3";
            lblMsg.Visible = true;
        }
    }
}
