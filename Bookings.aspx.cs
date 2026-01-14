using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using MarineTravelAgency.App_Code;

namespace MarineTravelAgency
{
    public partial class Bookings : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Only admins can see the search box
                txtSearch.Visible = (Session["Role"] != null && Session["Role"].ToString() == "Admin");

                BindTrips();
                BindBookings();
            }
        }

        private void BindTrips()
        {
            // Only show trips with available seats
            string sql = "SELECT TripId, ShipName + ' to ' + (SELECT Name FROM Destinations WHERE Destinations.DestinationId = Trips.DestinationId) + ' (' + CAST(DepartureDate AS NVARCHAR) + ')' as TripDesc FROM Trips WHERE Status='Scheduled' AND AvailableSeats > 0";
            DataTable dt = SqlHelper.ExecuteQuery(sql);
            ddlTrips.DataSource = dt;
            ddlTrips.DataTextField = "TripDesc";
            ddlTrips.DataValueField = "TripId";
            ddlTrips.DataBind();
            ddlTrips.Items.Insert(0, new ListItem("-- Select Trip --", ""));
        }

        private void BindBookings(string searchTerm = "")
        {
            string sql = @"SELECT b.BookingId, b.CustomerName, b.CustomerEmail, b.NumberOfGuests, b.TotalAmount, b.Status, t.ShipName 
                           FROM Bookings b 
                           JOIN Trips t ON b.TripId = t.TripId";
            
            string role = Session["Role"] != null ? Session["Role"].ToString() : "";
            string userId = Session["UserID"] != null ? Session["UserID"].ToString() : "";

            if (role == "User")
            {
                if (sql.Contains("WHERE")) sql += " AND b.UserId = @UID";
                else sql += " WHERE b.UserId = @UID";
            }
            
            sql += " ORDER BY b.BookingDate DESC";
            
            System.Collections.Generic.List<SqlParameter> paramList = new System.Collections.Generic.List<SqlParameter>();
            if (!string.IsNullOrWhiteSpace(searchTerm))
            {
                paramList.Add(new SqlParameter("@Search", "%" + searchTerm + "%"));
            }
            if (role == "User")
            {
                paramList.Add(new SqlParameter("@UID", userId));
            }

            gvBookings.DataSource = SqlHelper.ExecuteQuery(sql, paramList.ToArray());
            gvBookings.DataBind();

            // Hide actions for users (View ONLY requirement)
            if (role == "User" && gvBookings.Columns.Count > 6)
            {
                gvBookings.Columns[6].Visible = false;
            }
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            BindBookings(txtSearch.Text.Trim());
        }

        protected void btnBook_Click(object sender, EventArgs e)
        {
            try
            {
                SqlParameter[] p = {
                    new SqlParameter("@TripId", int.Parse(ddlTrips.SelectedValue)),
                    new SqlParameter("@UserId", Session["UserID"] ?? DBNull.Value),
                    new SqlParameter("@CustomerName", txtName.Text),
                    new SqlParameter("@CustomerEmail", txtEmail.Text),
                    new SqlParameter("@CustomerPhone", txtPhone.Text),
                    new SqlParameter("@NumberOfGuests", int.Parse(txtGuests.Text))
                };

                // Use the Stored Procedure 'sp_AddBooking' which handles seat deduction logic
                SqlHelper.ExecuteNonQuery("sp_AddBooking", p, true);

                // Reset
                txtName.Text = "";
                txtEmail.Text = "";
                txtPhone.Text = "";
                txtGuests.Text = "1";
                
                BindBookings();
                // Re-bind trips to update availability if we want, or just let it be
                lblMsg.Text = "Booking Confirmed!";
                lblMsg.CssClass = "text-success";
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Error: " + ex.Message;
                lblMsg.CssClass = "text-danger";
            }
        }
        protected void gvBookings_RowEditing(object sender, GridViewEditEventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin") return;
            gvBookings.EditIndex = e.NewEditIndex;
            BindBookings();
        }

        protected void gvBookings_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvBookings.EditIndex = -1;
            BindBookings();
        }

        protected void gvBookings_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin") return;
            int bookingId = Convert.ToInt32(gvBookings.DataKeys[e.RowIndex].Value);
            
            TextBox txtName = (TextBox)gvBookings.Rows[e.RowIndex].FindControl("txtEditName");
            TextBox txtGuests = (TextBox)gvBookings.Rows[e.RowIndex].FindControl("txtEditGuests");
            DropDownList ddlStatus = (DropDownList)gvBookings.Rows[e.RowIndex].FindControl("ddlEditStatus");

            // Recalculate price if guests changed? For simplicity, we stick to updating basic info.
            // In a real app, you'd re-fetch trip price and update TotalAmount.
            
            string sql = "UPDATE Bookings SET CustomerName=@Name, NumberOfGuests=@Guests, Status=@Status WHERE BookingId=@Id";
            SqlParameter[] p = {
                new SqlParameter("@Name", txtName.Text),
                new SqlParameter("@Guests", int.Parse(txtGuests.Text)),
                new SqlParameter("@Status", ddlStatus.SelectedValue),
                new SqlParameter("@Id", bookingId)
            };

            try
            {
                SqlHelper.ExecuteNonQuery(sql, p);
                gvBookings.EditIndex = -1;
                BindBookings();
                lblMsg.Text = "Booking updated.";
                lblMsg.CssClass = "text-success";
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Error: " + ex.Message;
                lblMsg.CssClass = "text-danger";
            }
        }

        protected void gvBookings_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin") return;
            int bookingId = Convert.ToInt32(gvBookings.DataKeys[e.RowIndex].Value);
            string sql = "DELETE FROM Bookings WHERE BookingId=@Id";
            SqlParameter[] p = { new SqlParameter("@Id", bookingId) };

            try
            {
                SqlHelper.ExecuteNonQuery(sql, p);
                BindBookings();
                lblMsg.Text = "Booking deleted.";
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
