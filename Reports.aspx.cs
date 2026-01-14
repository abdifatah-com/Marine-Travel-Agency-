using System;
using System.Data;
using MarineTravelAgency.App_Code;

namespace MarineTravelAgency
{
    public partial class Reports : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("~/Dashboard.aspx");
                return;
            }

            if (!IsPostBack)
            {
                BindReports();
            }
        }

        private void BindReports()
        {
            // Report: Revenue by Destination
            string sql = @"SELECT d.Name as Destination, COUNT(b.BookingId) as TotalBookings, SUM(b.TotalAmount) as TotalRevenue 
                           FROM Bookings b 
                           JOIN Trips t ON b.TripId = t.TripId 
                           JOIN Destinations d ON t.DestinationId = d.DestinationId 
                           GROUP BY d.Name";
            
            gvRevenue.DataSource = SqlHelper.ExecuteQuery(sql);
            gvRevenue.DataBind();
        }

        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=RevenueReport.xls");
            Response.Charset = "";
            Response.ContentType = "application/vnd.ms-excel";
            
            System.IO.StringWriter sw = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter hw = new System.Web.UI.HtmlTextWriter(sw);
            
            gvRevenue.RenderControl(hw);
            
            Response.Output.Write(sw.ToString());
            Response.Flush();
            Response.End();
        }

        protected void btnExportPDF_Click(object sender, EventArgs e)
        {
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=RevenueReport.html");
            Response.Charset = "";
            Response.ContentType = "text/html";
            
            System.IO.StringWriter sw = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter hw = new System.Web.UI.HtmlTextWriter(sw);
            
            hw.Write("<html><head><title>Revenue Report</title>");
            hw.Write("<style>table{border-collapse:collapse;width:100%;}th,td{border:1px solid #ddd;padding:8px;text-align:left;}th{background-color:#06b6d4;color:white;}</style>");
            hw.Write("</head><body><h2>Revenue by Destination Report</h2>");
            
            gvRevenue.RenderControl(hw);
            
            hw.Write("</body></html>");
            
            Response.Output.Write(sw.ToString());
            Response.Flush();
            Response.End();
        }

        public override void VerifyRenderingInServerForm(System.Web.UI.Control control)
        {
            // Required for GridView RenderControl
        }
    }
}
