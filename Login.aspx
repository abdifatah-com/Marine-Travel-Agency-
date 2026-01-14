<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="MarineTravelAgency.Login" %>

    <!DOCTYPE html>
    <html lang="en">

    <head runat="server">
        <title>Login - Marine Travel</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
        <!-- Custom Premium Styles -->
        <link href="assets/css/styles.css" rel="stylesheet" />
        <!-- FontAwesome Icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
        <style>
            .login-container {
                min-height: 80vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .login-card {
                width: 100%;
                max-width: 350px;
                padding: 1.5rem;
            }

            .glass-card:hover {
                transform: none !important;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06) !important;
                border-color: var(--glass-border) !important;
            }

            .login-icon {
                font-size: 3rem;
                color: var(--accent);
                margin-bottom: 1rem;
            }
        </style>
    </head>

    <body>
        <form id="form1" runat="server">
            <div class="container">
                <div class="login-container">
                    <div class="glass-card login-card text-center">
                        <div class="login-icon">
                            <i class="fas fa-anchor"></i>
                        </div>
                        <h2 class="text-white mb-4 fw-bold">Welcome Back</h2>

                        <asp:Label ID="lblError" runat="server" CssClass="alert alert-danger d-block mb-3"
                            Visible="false"></asp:Label>


                        <div class="form-floating mb-3 text-start">
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Username"
                                required="required">
                            </asp:TextBox>
                            <label for="<%= txtUsername.ClientID %>" class="text-muted">Username</label>
                        </div>

                        <div class="form-floating mb-4 text-start">
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password"
                                placeholder="Password" required="required"></asp:TextBox>
                            <label for="<%= txtPassword.ClientID %>" class="text-muted">Password</label>
                        </div>

                        <div class="d-grid gap-2">
                            <asp:Button ID="btnLogin" runat="server" Text="Sign In" CssClass="btn btn-primary btn-lg"
                                OnClick="btnLogin_Click" />
                        </div>

                        <div class="mt-4 text-white small">
                            <p>Don't have an account? <a href="Register.aspx"
                                    class="text-info text-decoration-none">Sign Up</a></p>
                            Marine Travel System &copy; <%= DateTime.Now.Year %>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </body>

    </html>