<%@ Page Title="" Language="C#" MasterPageFile="~/Menu.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="ProjetoPPI.Login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <html>
        <head>
            <title>Viver Clin | Login</title>
        </head>
        <body>
            <div class="content">
                <div class="section">
                    <h1>LOGIN</h1>
                    <h2>Faça aqui o login para acessar o sistema</h2>
                </div>                      
                    <div class="formulario">
                        <label>LOGIN</label>
                    <div class="campo">
                        <label>E-mail: </label>
                        <input type="text" name="e-mail">
                    </div>
                    <div class="campo">
                        <label>Senha: </label>
                        <input type="text" name="e-mail" />
                    </div>
                    <div class="campo">
                        <input type="button" value="Entrar"/>
                    </div>
                    </div>                
            </div>
        </body>
    </html>
</asp:Content>
