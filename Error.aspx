<%@ Page Title="Error" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="alert alert-danger mt-5">
            <h4 class="alert-heading">An Error Occurred</h4>
            <p>Sorry, an unexpected error has occurred. Please try again later or contact support.</p>
            <hr>
            <p class="mb-0"><a href="Dashboard.aspx" class="alert-link">Return to Dashboard</a></p>
        </div>
    </asp:Content>