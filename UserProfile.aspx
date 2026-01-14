<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeFile="UserProfile.aspx.cs" Inherits="MarineTravelAgency.UserProfile" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <h2 class="mb-3">User Profile</h2>
        <div class="col-md-10 mx-auto">
            <asp:Label ID="lblMsg" runat="server" CssClass="d-block mb-2"></asp:Label>

            <div class="text-center mb-3">
                <asp:Image ID="imgProfile" runat="server" CssClass="rounded-circle border border-2 border-info mb-2"
                    Width="110" Height="110" style="object-fit:cover;" ImageUrl="~/assets/img/default-avatar.png" />
                <div class="mt-1">
                    <label class="form-label text-white-50 x-small d-block mb-1">Change Profile Picture</label>
                    <asp:FileUpload ID="fuProfilePic" runat="server"
                        CssClass="form-control form-control-sm bg-transparent text-white w-50 mx-auto"
                        style="font-size: 0.8rem;" />
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label text-white-50 small">Username</label>
                    <asp:TextBox ID="txtUsernameDisplay" runat="server"
                        CssClass="form-control bg-transparent text-white" ReadOnly="true"></asp:TextBox>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label text-white-50 small">Role</label>
                    <asp:TextBox ID="txtRoleDisplay" runat="server" CssClass="form-control bg-transparent text-white"
                        ReadOnly="true"></asp:TextBox>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label text-white-50 small">First Name</label>
                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control bg-transparent text-white">
                    </asp:TextBox>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label text-white-50 small">Last Name</label>
                    <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control bg-transparent text-white">
                    </asp:TextBox>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label text-white-50 small">Phone Number</label>
                    <asp:TextBox ID="txtPhoneNumber" runat="server" CssClass="form-control bg-transparent text-white">
                    </asp:TextBox>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label text-white-50 small">Email Address</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control bg-transparent text-white">
                    </asp:TextBox>
                </div>
            </div>

            <div class="d-grid mt-3">
                <asp:Button ID="btnUpdate" runat="server" Text="Save Profile Changes" CssClass="btn btn-primary"
                    OnClick="btnUpdate_Click" />
            </div>
        </div>
    </asp:Content>