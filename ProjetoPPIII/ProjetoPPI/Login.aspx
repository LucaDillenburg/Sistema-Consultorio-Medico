﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="ProjetoPPI.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link rel="stylesheet" href="estilo.css" />
    <link href="https://fonts.googleapis.com/css?family=Baloo+Tammudu" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css?family=Comfortaa" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css?family=Pacifico" rel="stylesheet"/>    
    <style>
        body {
            background-image: url("Content/architecture-buildings-city-1139556.jpg");
            background-position: center;
            background-attachment:fixed;
            background-size: cover;
            background-repeat: no-repeat;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="formulario">
            <asp:Label ID="lbTitulo" CssClass="legenda" runat="server" Text="TITULO" ></asp:Label>
            <hr />
            <div class="campo">
                <asp:Label CssClass="asp_label" ID="Label1" runat="server" Text="Email: "></asp:Label>
                <asp:TextBox  CssClass="input_text"  ID="txtEmail" runat="server"></asp:TextBox>          
            </div>
            <div class="campo">
                <asp:Label CssClass="asp_label" ID="Label2" runat="server" Text="Senha: "></asp:Label>
                <asp:TextBox CssClass="input_text" ID="txtSenha" runat="server" TextMode="Password"></asp:TextBox>          
            </div>
            <div class="campo">
                <asp:Button CssClass="asp_button" ID="btnLogar" runat="server" Text="Logar" OnClick="btnLogar_Click" />
                <asp:Label CssClass="asp_label" ID="lbMsg" runat="server" Text="" Visible="true" style="color:red"></asp:Label>
            </div>
        </div>
    </form>
</body>
</html>
