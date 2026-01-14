<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeFile="Register.aspx.cs" Inherits="MarineTravelAgency.Register" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
        <style>
            .login-container {
                min-height: 80vh;
                display: flex;
                align-items: flex-start;
                justify-content: center;
                padding-top: 5rem;
                padding-bottom: 2rem;
            }

            .login-card {
                width: 100%;
                max-width: 600px;
                /* Slightly wider for register */
                padding: 2rem;
            }

            .glass-card:hover {
                transform: none !important;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06) !important;
                border-color: var(--glass-border) !important;
            }

            .login-icon {
                font-size: 2.5rem;
                color: var(--accent);
                margin-bottom: 1rem;
            }

            /* Navbar hidden on register/login pages typically, but here we render inside Master with Sidebar hidden? 
           Actually, the Master page has a fixed sidebar now. For Login/Register, we might want a clean slate.
           However, they inherit Site.Master. We might need to handle hiding sidebar for these pages or use a different Master.
           For now, let's assume they use Site.Master and we might see the sidebar. 
           Wait, Login.aspx uses Site.Master. 
           If I want a clean full-screen Login/Register, I should ideally use a separate layout or hide sidebar via CSS on this page.
        */
            .sidebar {
                display: none;
            }

            /* Hide sidebar for auth pages */
            .main-content {
                margin-left: 0;
                padding: 0;
            }

            /* Custom tooltip style if browser supports it or just let native handle */
            input:invalid {
                border-color: rgba(255, 255, 255, 0.2);
            }

            input:focus:invalid {
                box-shadow: 0 0 0 0.25rem rgba(255, 255, 255, 0.1);
            }
        </style>
        <script type="text/javascript">
            function checkPasswordMatch(input) {
                if (input.value != document.getElementById('<%= txtPassword.ClientID %>').value) {
                    input.setCustomValidity('Passwords must match.');
                } else {
                    input.setCustomValidity('');
                }
            }
        </script>
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
        <div class="login-container">
            <div class="glass-card login-card text-center">
                <div class="login-icon">
                    <i class="fas fa-user-plus"></i>
                </div>
                <h2 class="text-white mb-4 fw-bold">Create Account</h2>

                <asp:Label ID="lblMsg" runat="server" CssClass="d-block mb-3" Visible="false"></asp:Label>


                <div class="row">
                    <div class="col-md-6">
                        <div class="form-floating mb-3 text-start">
                            <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control"
                                placeholder="First Name" required="required" pattern="[A-Za-z]+"></asp:TextBox>
                            <label for="<%= txtFirstName.ClientID %>" class="text-muted">First Name</label>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-floating mb-3 text-start">
                            <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" placeholder="Last Name"
                                required="required" pattern="[A-Za-z]+"></asp:TextBox>
                            <label for="<%= txtLastName.ClientID %>" class="text-muted">Last Name</label>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="form-floating mb-3 text-start">
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Username"
                                required="required">
                            </asp:TextBox>
                            <label for="<%= txtUsername.ClientID %>" class="text-muted">Username</label>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-floating mb-3 text-start">
                            <asp:TextBox ID="txtPhoneNumber" runat="server" CssClass="form-control"
                                placeholder="Phone Number" required="required" pattern="[0-9]+">
                            </asp:TextBox>
                            <label for="<%= txtPhoneNumber.ClientID %>" class="text-muted">Phone Number</label>
                        </div>
                    </div>
                </div>

                <div class="form-floating mb-3 text-start">
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email"
                        placeholder="Email" required="required"></asp:TextBox>
                    <label for="<%= txtEmail.ClientID %>" class="text-muted">Email Address</label>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="form-floating mb-3 text-start">
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password"
                                placeholder="Password" required="required"
                                pattern="^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{5,}$"></asp:TextBox>
                            <label for="<%= txtPassword.ClientID %>" class="text-muted">Password</label>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-floating mb-4 text-start">
                            <asp:TextBox ID="txtConfirmPass" runat="server" CssClass="form-control" TextMode="Password"
                                placeholder="Confirm" required="required" oninput="checkPasswordMatch(this);">
                            </asp:TextBox>
                            <label for="<%= txtConfirmPass.ClientID %>" class="text-muted">Confirm</label>
                        </div>
                    </div>
                </div>

                <div class="d-grid gap-2">
                    <asp:Button ID="btnRegister" runat="server" Text="Sign Up" CssClass="btn btn-primary btn-lg"
                        OnClick="btnRegister_Click" />
                </div>

                <div class="mt-4 text-white">
                    Already have an account? <a href="Login.aspx" class="text-info text-decoration-none">Sign In</a>
                </div>
            </div>
        </div>
    </asp:Content>