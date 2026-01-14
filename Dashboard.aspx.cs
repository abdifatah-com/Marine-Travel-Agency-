using System;
using System.Data;
using MarineTravelAgency.App_Code;

namespace MarineTravelAgency
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadStats();
            }
        }

        private void LoadStats()
        {
            string role = Session["Role"] != null ? Session["Role"].ToString() : "";
            string userId = Session["UserID"] != null ? Session["UserID"].ToString() : "";
            bool isAdmin = (role == "Admin");

            pnlAdminActions.Visible = isAdmin;
            pnlReportsLink.Visible = isAdmin;

            string sqlTrips, sqlBookings, sqlRevenue;
            System.Collections.Generic.List<System.Data.SqlClient.SqlParameter> p = new System.Collections.Generic.List<System.Data.SqlClient.SqlParameter>();

            if (isAdmin)
            {
                lblTripsTitle.Text = "Total Trips";
                lblBookingsTitle.Text = "Total Bookings";
                lblRevenueTitle.Text = "Total Revenue";

                lblChartTitle.Text = "System Revenue & Booking Trends";
                lblChartSubtitle.Text = "(Admin View: Revenue per trip and system-wide booking density analytics)";

                sqlTrips = "SELECT COUNT(*) FROM Trips";
                sqlBookings = "SELECT COUNT(*) FROM Bookings";
                sqlRevenue = "SELECT ISNULL(SUM(TotalAmount), 0) FROM Bookings";
            }
            else
            {
                lblTripsTitle.Text = "Available Trips";
                lblBookingsTitle.Text = "My Bookings";
                lblRevenueTitle.Text = "My Total Spend";

                lblChartTitle.Text = "My Travel Activity Trends";
                lblChartSubtitle.Text = "(User View: Your booking frequency and spending history analysis)";

                sqlTrips = "SELECT COUNT(*) FROM Trips WHERE Status='Scheduled'";
                sqlBookings = "SELECT COUNT(*) FROM Bookings WHERE UserId = @UID";
                sqlRevenue = "SELECT ISNULL(SUM(TotalAmount), 0) FROM Bookings WHERE UserId = @UID";
                p.Add(new System.Data.SqlClient.SqlParameter("@UID", userId));
            }

            lblTotalTrips.Text = SqlHelper.ExecuteScalar(sqlTrips, p.ToArray()).ToString();
            lblTotalBookings.Text = SqlHelper.ExecuteScalar(sqlBookings, p.ToArray()).ToString();
            
            decimal revenue = Convert.ToDecimal(SqlHelper.ExecuteScalar(sqlRevenue, p.ToArray()));
            lblRevenue.Text = revenue.ToString("C");
        }
    }
}
