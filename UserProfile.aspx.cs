using System;
using System.Data;
using System.Data.SqlClient;
using MarineTravelAgency.App_Code;

namespace MarineTravelAgency
{
    public partial class UserProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProfile();
            }
        }

        private void LoadProfile()
        {
            string username = User.Identity.Name;
            string sql = "SELECT * FROM Users WHERE Username = @User";
            SqlParameter[] p = { new SqlParameter("@User", username) };
            
            DataTable dt = SqlHelper.ExecuteQuery(sql, p);
            if (dt.Rows.Count > 0)
            {
                DataRow r = dt.Rows[0];
                txtFirstName.Text = r["FirstName"].ToString();
                txtLastName.Text = r["LastName"].ToString();
                txtPhoneNumber.Text = r["PhoneNumber"].ToString();
                txtEmail.Text = r["Email"].ToString();
                txtUsernameDisplay.Text = r["Username"].ToString();
                txtRoleDisplay.Text = r["Role"].ToString();

                string imgUrl = r["ProfileImageUrl"] != null ? r["ProfileImageUrl"].ToString() : "";
                if (!string.IsNullOrEmpty(imgUrl))
                {
                    imgProfile.ImageUrl = ResolveUrl(imgUrl);
                }
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try 
            {
                string userId = Session["UserID"] != null ? Session["UserID"].ToString() : "";
                string profilePicPath = "";

                if (fuProfilePic.HasFile)
                {
                    string extension = System.IO.Path.GetExtension(fuProfilePic.FileName).ToLower();
                    if (extension == ".jpg" || extension == ".jpeg" || extension == ".png" || extension == ".gif")
                    {
                        string folderPath = Server.MapPath("~/assets/img/profiles/");
                        if (!System.IO.Directory.Exists(folderPath))
                        {
                            System.IO.Directory.CreateDirectory(folderPath);
                        }

                        string fileName = userId + "_" + DateTime.Now.Ticks + extension;
                        string savePath = folderPath + fileName;
                        fuProfilePic.SaveAs(savePath);
                        profilePicPath = "~/assets/img/profiles/" + fileName;
                    }
                    else
                    {
                        lblMsg.Text = "Only image files (.jpg, .png, .gif) are allowed.";
                        lblMsg.CssClass = "text-danger";
                        return;
                    }
                }

                string sql = "UPDATE Users SET FirstName = @FirstName, LastName = @LastName, PhoneNumber = @PhoneNumber, Email = @Email";
                
                System.Collections.Generic.List<SqlParameter> paramList = new System.Collections.Generic.List<SqlParameter>();
                paramList.Add(new SqlParameter("@FirstName", txtFirstName.Text));
                paramList.Add(new SqlParameter("@LastName", txtLastName.Text));
                paramList.Add(new SqlParameter("@PhoneNumber", txtPhoneNumber.Text));
                paramList.Add(new SqlParameter("@Email", txtEmail.Text));
                paramList.Add(new SqlParameter("@Username", User.Identity.Name));

                if (!string.IsNullOrEmpty(profilePicPath))
                {
                    sql += ", ProfileImageUrl = @ProfilePic";
                    paramList.Add(new SqlParameter("@ProfilePic", profilePicPath));
                    Session["ProfilePic"] = profilePicPath; // Update session for sidebar
                }

                sql += " WHERE Username = @Username";
                
                SqlHelper.ExecuteNonQuery(sql, paramList.ToArray());
                
                LoadProfile(); // Refresh UI
                lblMsg.Text = "Profile updated successfully.";
                lblMsg.CssClass = "text-success";
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Error: " + ex.Message;
                lblMsg.CssClass = "text-danger";
            }
        }
    }
}
