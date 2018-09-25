<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="ProjetoPPI.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
<form id="form1" runat="server">
<div><center>
    <asp:Label ID="lbTitulo" runat="server" Text="TITULO" Font-Overline="False" Font-Size="XX-Large" Font-Underline="True"></asp:Label>
    <table>
      <tr>
        <td><asp:Label ID="Label1" runat="server" Text="Email: "></asp:Label></td>
        <td><asp:TextBox ID="txtEmail" runat="server"></asp:TextBox></td>
      </tr>

      <tr>
        <td><asp:Label ID="Label2" runat="server" Text="Senha: "></asp:Label></td>
        <td><asp:TextBox ID="txtSenha" runat="server" TextMode="Password"></asp:TextBox></td>
      </tr>
    </table>
    <br />
    <asp:Button ID="btnLogar" runat="server" Text="Logar" OnClick="btnLogar_Click" />
    <br />
    <asp:Label ID="lbMsg" runat="server" Text="" Visible="true" style="color:red"></asp:Label>
</center></div>
</form>
</body>
</html>
