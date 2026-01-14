using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using MarineTravelAgency.App_Code;

namespace MarineTravelAgency
{
    public partial class UsersPage : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Security Check
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("~/Dashboard.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUsers();
            }
        }

        private void LoadUsers()
        {
            try
            {
                DataTable dt = SqlHelper.ExecuteQuery("sp_GetAllUsers", null, true);
                gvUsers.DataSource = dt;
                gvUsers.DataBind();
            }
            catch (Exception ex)
            {
                ShowMessage("Error loading users: " + ex.Message, false);
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text; // In a real app, hash this!
            string firstName = txtFirstName.Text.Trim();
            string lastName = txtLastName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string phone = txtPhoneNumber.Text.Trim();
            string role = ddlRole.SelectedValue;

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(email))
            {
                ShowMessage("Username and Email are required.", false);
                return;
            }

            try
            {
                if (string.IsNullOrEmpty(hdnUserId.Value))
                {
                    // Add User
                    if (string.IsNullOrEmpty(password))
                    {
                        ShowMessage("Password is required for new users.", false);
                        return;
                    }

                    SqlParameter[] p = {
                        new SqlParameter("@Username", username),
                        new SqlParameter("@PasswordHash", password),
                        new SqlParameter("@Email", email),
                        new SqlParameter("@FirstName", firstName),
                        new SqlParameter("@LastName", lastName),
                        new SqlParameter("@PhoneNumber", phone),
                        new SqlParameter("@Role", role)
                    };

                    SqlHelper.ExecuteNonQuery("sp_RegisterUser", p, true);
                    ShowMessage("User added successfully!", true);
                }
                else
                {
                    // Update User
                    int userId = int.Parse(hdnUserId.Value);
                    SqlParameter[] p = {
                        new SqlParameter("@UserId", userId),
                        new SqlParameter("@Username", username),
                        new SqlParameter("@PasswordHash", string.IsNullOrEmpty(password) ? (object)DBNull.Value : password),
                        new SqlParameter("@Email", email),
                        new SqlParameter("@FirstName", firstName),
                        new SqlParameter("@LastName", lastName),
                        new SqlParameter("@PhoneNumber", phone),
                        new SqlParameter("@Role", role)
                    };

                    SqlHelper.ExecuteNonQuery("sp_UpdateUser", p, true);
                    ShowMessage("User updated successfully!", true);
                }

                ClearForm();
                LoadUsers();
            }
            catch (SqlException ex)
            {
                if (ex.Number == 51001) ShowMessage("Username is already taken.", false);
                else if (ex.Number == 51002) ShowMessage("Email is already registered.", false);
                else ShowMessage("Database error: " + ex.Message, false);
            }
            catch (Exception ex)
            {
                ShowMessage("Error saving user: " + ex.Message, false);
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            hdnUserId.Value = "";
            txtUsername.Text = "";
            txtPassword.Text = "";
            txtFirstName.Text = "";
            txtLastName.Text = "";
            txtEmail.Text = "";
            txtPhoneNumber.Text = "";
            ddlRole.SelectedIndex = 0;
            litFormTitle.Text = "Add New User";
            btnSave.Text = "Save User";
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int userId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditUser")
            {
                EditUser(userId);
            }
            else if (e.CommandName == "DeleteUser")
            {
                DeleteUser(userId);
            }
        }

        private void EditUser(int userId)
        {
            try
            {
                DataTable dt = SqlHelper.ExecuteQuery("SELECT * FROM Users WHERE UserId = " + userId);
                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    hdnUserId.Value = userId.ToString();
                    txtUsername.Text = row["Username"].ToString();
                    txtFirstName.Text = row["FirstName"].ToString();
                    txtLastName.Text = row["LastName"].ToString();
                    txtEmail.Text = row["Email"].ToString();
                    txtPhoneNumber.Text = row["PhoneNumber"].ToString();
                    ddlRole.SelectedValue = row["Role"].ToString();
                    
                    litFormTitle.Text = "Edit User: " + txtUsername.Text;
                    btnSave.Text = "Update User";
                    lblMsg.Visible = false;
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error fetching user details: " + ex.Message, false);
            }
        }

        private void DeleteUser(int userId)
        {
            // Optional: Prevent deleting self
            if (Session["UserID"] != null && userId.ToString() == Session["UserID"].ToString())
            {
                ShowMessage("You cannot delete your own account.", false);
                return;
            }

            try
            {
                SqlParameter[] p = { new SqlParameter("@UserId", userId) };
                SqlHelper.ExecuteNonQuery("sp_DeleteUser", p, true);
                ShowMessage("User deleted successfully!", true);
                LoadUsers();
            }
            catch (Exception ex)
            {
                ShowMessage("Error deleting user: " + ex.Message, false);
            }
        }

        private void ShowMessage(string msg, bool isSuccess)
        {
            lblMsg.Text = msg;
            lblMsg.CssClass = isSuccess ? "alert alert-success d-block mb-3" : "alert alert-danger d-block mb-3";
            lblMsg.Visible = true;
        }
    }
}
