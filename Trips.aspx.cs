using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using MarineTravelAgency.App_Code;

namespace MarineTravelAgency
{
    public partial class Trips : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                bool isAdmin = Session["Role"] != null && Session["Role"].ToString() == "Admin";
                pnlAddTrip.Visible = isAdmin;

                BindGrid();
                BindDestinations();
            }
        }

        private void BindGrid(string destinationId = "")
        {
            string query = @"SELECT t.TripId, t.ShipName, t.DepartureDate, t.ReturnDate, t.PricePerPerson, t.Status, d.Name as DestinationName 
                             FROM Trips t 
                             JOIN Destinations d ON t.DestinationId = d.DestinationId";
            
            if (!string.IsNullOrEmpty(destinationId))
            {
                query += " WHERE t.DestinationId = @DestId";
            }
            
            query += " ORDER BY t.DepartureDate DESC";

            System.Collections.Generic.List<SqlParameter> p = new System.Collections.Generic.List<SqlParameter>();
            if (!string.IsNullOrEmpty(destinationId))
            {
                p.Add(new SqlParameter("@DestId", destinationId));
            }

            gvTrips.DataSource = SqlHelper.ExecuteQuery(query, p.ToArray());
            gvTrips.DataBind();

            // Hide Actions column for non-admins
            bool isAdmin = Session["Role"] != null && Session["Role"].ToString() == "Admin";
            if (gvTrips.Columns.Count > 6)
            {
                gvTrips.Columns[6].Visible = isAdmin;
            }
        }

        private void BindDestinations()
        {
            DataTable dt = SqlHelper.ExecuteQuery("SELECT DestinationId, Name FROM Destinations ORDER BY Name");
            
            // For Add Form
            ddlDestination.DataSource = dt;
            ddlDestination.DataTextField = "Name";
            ddlDestination.DataValueField = "DestinationId";
            ddlDestination.DataBind();
            ddlDestination.Items.Insert(0, new ListItem("-- Select Destination --", ""));

            // For Filter
            ddlFilterDest.DataSource = dt;
            ddlFilterDest.DataTextField = "Name";
            ddlFilterDest.DataValueField = "DestinationId";
            ddlFilterDest.DataBind();
            ddlFilterDest.Items.Insert(0, new ListItem("All Destinations", ""));
        }
        
        protected void ddlFilterDest_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindGrid(ddlFilterDest.SelectedValue);
        }

        protected void btnAddTrip_Click(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin") return;
            try
            {
                string sql = @"INSERT INTO Trips (DestinationId, ShipName, DepartureDate, ReturnDate, PricePerPerson, MaxCapacity, AvailableSeats, Status)
                               VALUES (@DestId, @Ship, @Dep, @Ret, @Price, @Cap, @Cap, 'Scheduled')";
                
                SqlParameter[] p = {
                    new SqlParameter("@DestId", ddlDestination.SelectedValue),
                    new SqlParameter("@Ship", txtShipName.Text),
                    new SqlParameter("@Dep", DateTime.Parse(txtDeparture.Text)),
                    new SqlParameter("@Ret", DateTime.Parse(txtReturn.Text)),
                    new SqlParameter("@Price", decimal.Parse(txtPrice.Text)),
                    new SqlParameter("@Cap", int.Parse(txtCapacity.Text))
                };

                SqlHelper.ExecuteNonQuery(sql, p);
                
                // Reset and Refresh
                txtShipName.Text = "";
                txtPrice.Text = "";
                txtCapacity.Text = "";
                txtDeparture.Text = "";
                txtReturn.Text = "";
                BindGrid();
                lblMsg.Text = "Trip added successfully!";
                lblMsg.CssClass = "text-success";
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Error: " + ex.Message;
                lblMsg.CssClass = "text-danger";
            }
        }

        protected void gvTrips_RowEditing(object sender, GridViewEditEventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin") return;
            gvTrips.EditIndex = e.NewEditIndex;
            BindGrid(ddlFilterDest.SelectedValue);
        }

        protected void gvTrips_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvTrips.EditIndex = -1;
            BindGrid(ddlFilterDest.SelectedValue);
        }

        protected void gvTrips_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin") return;
            int tripId = Convert.ToInt32(gvTrips.DataKeys[e.RowIndex].Value);
            
            // Find controls
            TextBox txtShip = (TextBox)gvTrips.Rows[e.RowIndex].FindControl("txtEditShip");
            TextBox txtDep = (TextBox)gvTrips.Rows[e.RowIndex].FindControl("txtEditDep");
            TextBox txtPrice = (TextBox)gvTrips.Rows[e.RowIndex].FindControl("txtEditPrice");
            DropDownList ddlStatus = (DropDownList)gvTrips.Rows[e.RowIndex].FindControl("ddlEditStatus");

            string sql = "UPDATE Trips SET ShipName=@Ship, DepartureDate=@Dep, PricePerPerson=@Price, Status=@Status WHERE TripId=@Id";
            
            SqlParameter[] p = {
                new SqlParameter("@Ship", txtShip.Text),
                new SqlParameter("@Dep", DateTime.Parse(txtDep.Text)),
                new SqlParameter("@Price", decimal.Parse(txtPrice.Text)),
                new SqlParameter("@Status", ddlStatus.SelectedValue),
                new SqlParameter("@Id", tripId)
            };

            try
            {
                SqlHelper.ExecuteNonQuery(sql, p);
                gvTrips.EditIndex = -1;
                BindGrid(ddlFilterDest.SelectedValue);
                lblMsg.Text = "Trip updated successfully.";
                lblMsg.CssClass = "text-success";
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Update Error: " + ex.Message;
                lblMsg.CssClass = "text-danger";
            }
        }

        protected void gvTrips_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin") return;
            int tripId = Convert.ToInt32(gvTrips.DataKeys[e.RowIndex].Value);
            string sql = "DELETE FROM Trips WHERE TripId = @Id";
            SqlParameter[] p = { new SqlParameter("@Id", tripId) };
            
            try 
            {
                SqlHelper.ExecuteNonQuery(sql, p);
                BindGrid(ddlFilterDest.SelectedValue);
                lblMsg.Text = "Trip deleted successfully.";
                lblMsg.CssClass = "text-success";
            }
            catch(Exception ex) 
            {
                 lblMsg.Text = "Error: Cannot delete trip with existing bookings.";
                 lblMsg.CssClass = "text-danger";
            }
        }
    }
}
