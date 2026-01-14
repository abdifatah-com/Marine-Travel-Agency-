<%@ Page Title="Manage Bookings" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeFile="Bookings.aspx.cs" Inherits="MarineTravelAgency.Bookings" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
        <script type="text/javascript">
            var searchTimeout;
            function triggerSearch() {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(function () {
                    var searchBox = document.getElementById('<%= txtSearch.ClientID %>');
                    if (searchBox && searchBox.value.length >= 3) {
                        __doPostBack('<%= txtSearch.UniqueID %>', '');
                    } else if (searchBox && searchBox.value.length === 0) {
                        __doPostBack('<%= txtSearch.UniqueID %>', '');
                    }
                }, 500);
            }
        </script>
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <h2 class="mb-2">Manage Bookings</h2>
        <asp:Label ID="lblMsg" runat="server" CssClass="d-block mb-2"></asp:Label>

        <div class="row g-3">
            <div class="col-md-5">
                <div class="glass-card p-2 mb-2">
                    <div class="card-header bg-primary text-white py-1 small">New Booking</div>
                    <div class="card-body p-2">
                        <div class="mb-1">
                            <label class="x-small">Select Trip</label>
                            <asp:DropDownList ID="ddlTrips" runat="server" CssClass="form-select form-select-sm"
                                style="font-size: 0.8rem;">
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvTrip" runat="server" ControlToValidate="ddlTrips"
                                InitialValue="" ErrorMessage="Select a trip" CssClass="text-danger x-small"
                                ValidationGroup="Book" />
                        </div>
                        <div class="mb-1">
                            <label class="x-small">Customer Name</label>
                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control form-control-sm"
                                style="font-size: 0.8rem;">
                            </asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
                                ErrorMessage="Name required" CssClass="text-danger x-small" ValidationGroup="Book" />
                        </div>
                        <div class="mb-1">
                            <label class="x-small">Email</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control form-control-sm"
                                TextMode="Email" style="font-size: 0.8rem;">
                            </asp:TextBox>
                        </div>
                        <div class="mb-1">
                            <label class="x-small">Phone</label>
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control form-control-sm"
                                style="font-size: 0.8rem;">
                            </asp:TextBox>
                        </div>
                        <div class="mb-2">
                            <label class="x-small">Guests</label>
                            <asp:TextBox ID="txtGuests" runat="server" CssClass="form-control form-control-sm"
                                TextMode="Number" Text="1" style="font-size: 0.8rem;"></asp:TextBox>
                        </div>
                        <div class="d-grid">
                            <asp:Button ID="btnBook" runat="server" Text="Confirm Booking"
                                CssClass="btn btn-primary btn-sm" OnClick="btnBook_Click" ValidationGroup="Book"
                                style="padding: 0.2rem;" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-7">
                <div class="glass-card p-2">
                    <div class="d-flex justify-content-between align-items-center mb-2 px-2">
                        <h5 class="mb-0 text-white">Booking List</h5>
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control form-control-sm w-50"
                            style="font-size: 0.8rem;" placeholder="Search..." AutoPostBack="true"
                            OnTextChanged="txtSearch_TextChanged" onkeyup="triggerSearch()"></asp:TextBox>
                    </div>

                    <div class="table-responsive" style="max-height: 420px; overflow-y: auto;">
                        <asp:GridView ID="gvBookings" runat="server"
                            CssClass="table table-hover table-sm text-white mb-0" style="font-size: 0.85rem;"
                            AutoGenerateColumns="False" DataKeyNames="BookingId" OnRowEditing="gvBookings_RowEditing"
                            OnRowUpdating="gvBookings_RowUpdating" OnRowCancelingEdit="gvBookings_RowCancelingEdit"
                            OnRowDeleting="gvBookings_RowDeleting">
                            <Columns>
                                <asp:BoundField DataField="BookingId" HeaderText="#" ReadOnly="True" />
                                <asp:TemplateField HeaderText="Customer">
                                    <ItemTemplate>
                                        <%# Eval("CustomerName") %>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtEditName" runat="server"
                                            CssClass="form-control form-control-sm" Text='<%# Bind("CustomerName") %>'>
                                        </asp:TextBox>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="ShipName" HeaderText="Trip" ReadOnly="True" />
                                <asp:TemplateField HeaderText="Guests">
                                    <ItemTemplate>
                                        <%# Eval("NumberOfGuests") %>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtEditGuests" runat="server"
                                            CssClass="form-control form-control-sm" TextMode="Number"
                                            Text='<%# Bind("NumberOfGuests") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="TotalAmount" HeaderText="Total" DataFormatString="{0:C}"
                                    ReadOnly="True" />
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <%# Eval("Status") %>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="ddlEditStatus" runat="server"
                                            CssClass="form-select form-select-sm" SelectedValue='<%# Bind("Status") %>'>
                                            <asp:ListItem>Confirmed</asp:ListItem>
                                            <asp:ListItem>Cancelled</asp:ListItem>
                                        </asp:DropDownList>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Actions">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit"
                                            CssClass="icon-btn" ToolTip="Edit">
                                            <i class="fas fa-edit"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete"
                                            CssClass="icon-btn delete" ToolTip="Delete"
                                            OnClientClick="return confirmAction(this, 'Are you sure?', 'This booking will be cancelled!', 'warning');">
                                            <i class="fas fa-trash"></i>
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update"
                                            CssClass="icon-btn text-success" ToolTip="Save">
                                            <i class="fas fa-check"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel"
                                            CssClass="icon-btn text-warning" ToolTip="Cancel">
                                            <i class="fas fa-times"></i>
                                        </asp:LinkButton>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
    </asp:Content>