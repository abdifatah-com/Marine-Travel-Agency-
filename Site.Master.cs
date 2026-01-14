using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;

namespace MarineTravelAgency
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Context.User.Identity.IsAuthenticated)
                {
                    // Strengthening: Ensure Session is still active (not expired)
                    if (Session["Role"] == null)
                    {
                        FormsAuthentication.SignOut();
                        Response.Redirect("~/Login.aspx");
                        return;
                    }

                    string role = Session["Role"].ToString();
                    lblUser.Text = string.Format("Welcome, {0} ({1})", Context.User.Identity.Name, role);
                    lnkLogin.Visible = false;
                    lnkLogout.Visible = true;

                    // Show Admin-only nav
                    bool isAdmin = (role == "Admin");
                    pnlAdminNav.Visible = isAdmin;
                    litBookings.Text = isAdmin ? "Bookings" : "My Bookings";
                    
                    if (isAdmin)
                    {
                        litAdminUser.Text = "Users";
                        lnkAdminUser.Visible = true;
                    }

                    string profilePic = Session["ProfilePic"] != null ? Session["ProfilePic"].ToString() : "";
                    if (!string.IsNullOrEmpty(profilePic))
                    {
                        imgNavProfile.ImageUrl = ResolveUrl(profilePic);
                        imgNavProfile.Visible = true;
                    }
                    else
                    {
                        imgNavProfile.Visible = false;
                    }
                }
                else
                {
                    lblUser.Text = "";
                    lnkLogin.Visible = true;
                    lnkLogout.Visible = false;
                    pnlAdminNav.Visible = false;
                }
            }
        }

        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            Session.Abandon();
            Response.Redirect("~/Login.aspx");
        }
    }
}
