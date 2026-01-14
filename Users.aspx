<%@ Page Title="User Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeFile="Users.aspx.cs" Inherits="MarineTravelAgency.UsersPage" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="container-fluid">
            <h2 class="mb-3"><i class="fas fa-users-cog me-2"></i>User Management</h2>

            <asp:Label ID="lblMsg" runat="server" CssClass="d-block mb-3 small"></asp:Label>

            <div class="row g-3">
                <!-- User Form -->
                <div class="col-xl-4 col-lg-5">
                    <div class="glass-card p-3 mb-3">
                        <h5 class="text-accent mb-3"><i class="fas fa-user-plus me-2"></i>
                            <asp:Literal ID="litFormTitle" runat="server" Text="Add New User"></asp:Literal>
                        </h5>
                        <asp:HiddenField ID="hdnUserId" runat="server" />

                        <div class="mb-2">
                            <label class="x-small d-block mb-1">Username</label>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control"
                                style="font-size: 0.85rem; padding: 0.4rem 0.6rem;"></asp:TextBox>
                        </div>

                        <div class="mb-2">
                            <label class="x-small d-block mb-1">Password (Empty to keep)</label>
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password"
                                style="font-size: 0.85rem; padding: 0.4rem 0.6rem;"></asp:TextBox>
                        </div>

                        <div class="row g-2 mb-2">
                            <div class="col-6">
                                <label class="x-small d-block mb-1">First Name</label>
                                <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control"
                                    style="font-size: 0.85rem; padding: 0.4rem 0.6rem;"></asp:TextBox>
                            </div>
                            <div class="col-6">
                                <label class="x-small d-block mb-1">Last Name</label>
                                <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control"
                                    style="font-size: 0.85rem; padding: 0.4rem 0.6rem;"></asp:TextBox>
                            </div>
                        </div>

                        <div class="mb-2">
                            <label class="x-small d-block mb-1">Email</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email"
                                style="font-size: 0.85rem; padding: 0.4rem 0.6rem;"></asp:TextBox>
                        </div>

                        <div class="mb-2">
                            <label class="x-small d-block mb-1">Phone</label>
                            <asp:TextBox ID="txtPhoneNumber" runat="server" CssClass="form-control"
                                style="font-size: 0.85rem; padding: 0.4rem 0.6rem;"></asp:TextBox>
                        </div>

                        <div class="mb-3">
                            <label class="x-small d-block mb-1">Role</label>
                            <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-select"
                                style="font-size: 0.85rem; padding: 0.4rem 0.6rem;">


                                <asp:ListItem Text="Admin" Value="Admin"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="d-grid gap-2">
                            <asp:Button ID="btnSave" runat="server" Text="Save User" CssClass="btn btn-primary"
                                style="font-size: 0.9rem;" OnClick="btnSave_Click" />
                            <asp:Button ID="btnClear" runat="server" Text="Cancel"
                                CssClass="btn btn-outline-light btn-sm" style="font-size: 0.8rem;"
                                OnClick="btnClear_Click" />
                        </div>
                    </div>
                </div>

                <!-- Users List -->
                <div class="col-xl-8 col-lg-7">
                    <div class="glass-card p-3 h-100">
                        <h5 class="text-accent mb-3"><i class="fas fa-list me-2"></i>Active Users</h5>
                        <div class="table-responsive" style="max-height: 550px; overflow-y: auto; overflow-x: hidden;">
                            <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False"
                                CssClass="table table-hover table-sm text-white mb-0"
                                style="font-size: 0.85rem; table-layout: fixed; width: 100%;" DataKeyNames="UserId"
                                OnRowCommand="gvUsers_RowCommand" GridLines="None">
                                <Columns>
                                    <asp:BoundField DataField="Username" HeaderText="User" ItemStyle-Width="15%" />
                                    <asp:TemplateField HeaderText="Name" ItemStyle-Width="30%">
                                        <ItemTemplate>
                                            <div class="text-truncate"
                                                title='<%# Eval("FirstName") + " " + Eval("LastName") %>'>
                                                <%# Eval("FirstName") %>
                                                    <%# Eval("LastName") %>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Role" HeaderText="Role" ItemStyle-Width="15%"
                                        ItemStyle-CssClass="x-small" />
                                    <asp:BoundField DataField="Email" HeaderText="Email" ItemStyle-Width="25%"
                                        ItemStyle-CssClass="text-truncate" />
                                    <asp:TemplateField HeaderText="Actions" ItemStyle-Width="15%"
                                        ItemStyle-CssClass="text-center">
                                        <ItemTemplate>
                                            <div class="d-flex justify-content-center gap-2">
                                                <asp:LinkButton ID="lnkEdit" runat="server" CommandName="EditUser"
                                                    CommandArgument='<%# Eval("UserId") %>' CssClass="icon-btn"
                                                    style="font-size: 0.92rem;">
                                                    <i class="fas fa-edit"></i>
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="lnkDelete" runat="server" CommandName="DeleteUser"
                                                    CommandArgument='<%# Eval("UserId") %>' CssClass="icon-btn delete"
                                                    style="font-size: 0.92rem;"
                                                    OnClientClick="return confirmAction(this, 'Are you sure?', 'This user will be permanently deleted!', 'warning');">
                                                    <i class="fas fa-trash"></i>
                                                </asp:LinkButton>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <EmptyDataTemplate>
                                    <div class="p-3 text-center text-white-50 small">No users found.</div>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </asp:Content>