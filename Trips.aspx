<%@ Page Title="Manage Trips" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeFile="Trips.aspx.cs" Inherits="MarineTravelAgency.Trips" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <h2 class="mb-3">Manage Trips</h2>
        <asp:Label ID="lblMsg" runat="server" CssClass="d-block mb-2"></asp:Label>

        <div class="row g-3">
            <!-- Left Side: Data Input & Filters -->
            <div class="col-md-4">
                <div class="glass-card p-3 mb-3">
                    <h5 class="text-accent mb-2"><i class="fas fa-filter me-2"></i>Filter Trips</h5>
                    <label class="x-small d-block mb-1">Destination:</label>
                    <asp:DropDownList ID="ddlFilterDest" runat="server" CssClass="form-select form-select-sm"
                        AutoPostBack="true" OnSelectedIndexChanged="ddlFilterDest_SelectedIndexChanged"
                        style="font-size: 0.8rem;"></asp:DropDownList>
                </div>

                <asp:Panel ID="pnlAddTrip" runat="server">
                    <div class="glass-card p-3">
                        <h5 class="text-accent mb-3"><i class="fas fa-plus-circle me-2"></i>Add New Trip</h5>

                        <div class="mb-2">
                            <label class="x-small d-block mb-1">Destination</label>
                            <asp:DropDownList ID="ddlDestination" runat="server" CssClass="form-select form-select-sm"
                                style="font-size: 0.8rem;"></asp:DropDownList>
                        </div>

                        <div class="mb-2">
                            <label class="x-small d-block mb-1">Ship Name</label>
                            <asp:TextBox ID="txtShipName" runat="server" CssClass="form-control form-control-sm"
                                style="font-size: 0.8rem;"></asp:TextBox>
                        </div>

                        <div class="row g-2 mb-2">
                            <div class="col-6">
                                <label class="x-small d-block mb-1">Departure</label>
                                <asp:TextBox ID="txtDeparture" runat="server" CssClass="form-control form-control-sm"
                                    TextMode="Date" style="font-size: 0.8rem;"></asp:TextBox>
                            </div>
                            <div class="col-6">
                                <label class="x-small d-block mb-1">Return</label>
                                <asp:TextBox ID="txtReturn" runat="server" CssClass="form-control form-control-sm"
                                    TextMode="Date" style="font-size: 0.8rem;"></asp:TextBox>
                            </div>
                        </div>

                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <label class="x-small d-block mb-1">Capacity</label>
                                <asp:TextBox ID="txtCapacity" runat="server" CssClass="form-control form-control-sm"
                                    TextMode="Number" style="font-size: 0.8rem;"></asp:TextBox>
                            </div>
                            <div class="col-6">
                                <label class="x-small d-block mb-1">Price</label>
                                <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control form-control-sm"
                                    style="font-size: 0.8rem;"></asp:TextBox>
                            </div>
                        </div>

                        <div class="text-end">
                            <asp:LinkButton ID="btnAddTrip" runat="server" CssClass="btn btn-primary btn-sm w-100"
                                OnClick="btnAddTrip_Click">
                                <i class="fas fa-plus me-1"></i> Create Trip
                            </asp:LinkButton>
                        </div>
                    </div>
                </asp:Panel>
            </div>

            <!-- Right Side: Data Viewer -->
            <div class="col-md-8">
                <div class="glass-card p-3 h-100">
                    <h5 class="text-accent mb-3"><i class="fas fa-list me-2"></i>Trip Directory</h5>
                    <div class="table-responsive" style="max-height: 600px; overflow-y: auto;">
                        <asp:GridView ID="gvTrips" runat="server" CssClass="table table-hover table-sm text-white mb-0"
                            style="font-size: 0.85rem;" AutoGenerateColumns="False" DataKeyNames="TripId"
                            OnRowDeleting="gvTrips_RowDeleting" OnRowEditing="gvTrips_RowEditing"
                            OnRowUpdating="gvTrips_RowUpdating" OnRowCancelingEdit="gvTrips_RowCancelingEdit">
                            <Columns>
                                <asp:BoundField DataField="TripId" HeaderText="ID" ReadOnly="True"
                                    ItemStyle-Width="40px" />
                                <asp:TemplateField HeaderText="Ship">
                                    <ItemTemplate>
                                        <%# Eval("ShipName") %>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtEditShip" runat="server"
                                            CssClass="form-control form-control-sm" Text='<%# Bind("ShipName") %>'>
                                        </asp:TextBox>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Status" HeaderText="Status" ReadOnly="True"
                                    ItemStyle-CssClass="x-small" />
                                <asp:TemplateField HeaderText="Actions" ItemStyle-Width="80px">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit"
                                            CssClass="icon-btn"><i class="fas fa-edit"></i></asp:LinkButton>
                                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete"
                                            CssClass="icon-btn delete"
                                            OnClientClick="return confirmAction(this, 'Are you sure?', 'This trip will be deleted!', 'warning');">
                                            <i class="fas fa-trash"></i>
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update"
                                            CssClass="icon-btn text-success"><i class="fas fa-check"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel"
                                            CssClass="icon-btn text-warning"><i class="fas fa-times"></i>
                                        </asp:LinkButton>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <EmptyDataTemplate>
                                <div class="p-3 text-center text-white-50">No trips found.</div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>


    </asp:Content>