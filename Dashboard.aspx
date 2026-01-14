<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeFile="Dashboard.aspx.cs" Inherits="MarineTravelAgency.Dashboard" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <h2 class="fw-bold text-white mb-0">Dashboard</h2>
                <p class="text-white-50 small mb-0">Welcome back, <span class="text-info">
                        <%= Session["Role"] %>
                    </span></p>
            </div>
            <div class="d-flex gap-2">
                <asp:Panel ID="pnlAdminActions" runat="server">
                    <a href="Trips.aspx" class="btn btn-primary btn-sm"><i class="fas fa-ship me-1"></i> Manage
                        Trips</a>
                </asp:Panel>
                <a href="Bookings.aspx" class="btn btn-outline-light btn-sm"><i class="fas fa-plus me-1"></i> New
                    Booking</a>
                <asp:Panel ID="pnlReportsLink" runat="server">
                    <a href="Reports.aspx" class="btn btn-secondary btn-sm"><i class="fas fa-chart-bar me-1"></i>
                        Reports</a>
                </asp:Panel>
            </div>
        </div>

        <div class="row g-3">
            <!-- Card 1 -->
            <div class="col-md-4">
                <div class="glass-card h-100 p-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="text-white mb-1">
                                <asp:Label ID="lblTripsTitle" runat="server" Text="Total Trips"></asp:Label>
                            </p>
                            <h2 class="fw-bold text-white mb-0">
                                <asp:Label ID="lblTotalTrips" runat="server" Text="0"></asp:Label>
                            </h2>
                        </div>
                        <div class="display-6 text-info"><i class="fas fa-ship"></i></div>
                    </div>
                </div>
            </div>

            <!-- Card 2 -->
            <div class="col-md-4">
                <div class="glass-card h-100 p-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="text-white mb-1">
                                <asp:Label ID="lblBookingsTitle" runat="server" Text="Bookings"></asp:Label>
                            </p>
                            <h2 class="fw-bold text-white mb-0">
                                <asp:Label ID="lblTotalBookings" runat="server" Text="0"></asp:Label>
                            </h2>
                        </div>
                        <div class="display-6 text-success"><i class="fas fa-ticket-alt"></i></div>
                    </div>
                </div>
            </div>

            <!-- Card 3 -->
            <div class="col-md-4">
                <div class="glass-card h-100 p-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <p class="text-white mb-1">
                                <asp:Label ID="lblRevenueTitle" runat="server" Text="Revenue"></asp:Label>
                            </p>
                            <h2 class="fw-bold text-white mb-0">
                                <asp:Label ID="lblRevenue" runat="server" Text="$0.00"></asp:Label>
                            </h2>
                        </div>
                        <div class="display-6 text-warning"><i class="fas fa-coins"></i></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Activity Placeholder or Chart -->
        <div class="row mt-3">
            <div class="col-md-12">
                <div class="glass-card p-3"
                    style="min-height: 250px; display: flex; align-items: center; justify-content: center;">
                    <div class="text-center text-white">
                        <i class="fas fa-chart-area fa-2x mb-2 opacity-50"></i>
                        <p class="mb-1">
                            <asp:Label ID="lblChartTitle" runat="server" Text="Activity Overview Chart"></asp:Label>
                        </p>
                        <small>
                            <asp:Label ID="lblChartSubtitle" runat="server" Text="(Placeholder for Future Analytics)">
                            </asp:Label>
                        </small>
                    </div>
                </div>
            </div>
        </div>

    </asp:Content>