<%@ Page Title="Reports" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Reports.aspx.cs"
    Inherits="MarineTravelAgency.Reports" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <h2 class="mb-3">Reports & Analytics</h2>

        <div class="glass-card p-3">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="mb-0 text-white">Revenue by Destination</h4>
                <div>
                    <asp:Button ID="btnExportExcel" runat="server" Text="Export Excel"
                        CssClass="btn btn-sm btn-success me-2" OnClick="btnExportExcel_Click" />
                    <asp:Button ID="btnExportPDF" runat="server" Text="Export PDF" CssClass="btn btn-sm btn-danger"
                        OnClick="btnExportPDF_Click" />
                </div>
            </div>
            <div class="table-responsive">
                <asp:GridView ID="gvRevenue" runat="server" CssClass="table table-hover table-sm text-white mb-0"
                    AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="Destination" HeaderText="Destination" />
                        <asp:BoundField DataField="TotalBookings" HeaderText="Total Bookings" />
                        <asp:BoundField DataField="TotalRevenue" HeaderText="Total Revenue" DataFormatString="{0:C}" />
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="p-3 text-center text-white-50">No data available to display.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </asp:Content>