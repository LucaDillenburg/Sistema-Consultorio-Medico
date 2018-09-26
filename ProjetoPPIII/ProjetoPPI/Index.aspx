<%@ Page Title="" Language="C#" MasterPageFile="~/Menu.Master" AutoEventWireup="true" CodeBehind="IndexT.aspx.cs" Inherits="ProjetoPPI.IndexT" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <body>
       
    <div class="content">                  
        <div class="title">   
            <div class="btnOpen" style="color: #4286f4; font-size: 2.5em;"><span class="glyphicon glyphicon-th-list"></span></div>
            <h1>Viver Clin</h1>            
            <h2>A clínica médica para você</h2>
            <hr/>                        
        </div>
        <div class="section" id="medicos-sorrindo"></div>
        <div id="consultas" class="section">
            <h1 class="content-title"><i class="glyphicon glyphicon-plus"></i>Consultas</h1>
            <p class="content-paragraph">Nossas clínicas estão equipadas para atender à grande maioria
                das necessidades médicas. Com profissionais de mais de 30 especialidades, fazemos consultas
                pediátricas, cardiológicas, ortopédicas e quaisquer outras das quais você precisar.
            </p>
        </div>
        <div id="agendamento" class="section">
            <h1 class="content-title"><i class="glyphicon glyphicon-calendar"></i>Agendamento</h1>
            <p class="content-paragraph">O agendamento é rápido e fácil. Simplesmente cadastre-se no nosso site
                (ou faça login se você já tiver uma conta) e clique na aba "Pacientes" no menu. Você poderá escolher
                a data e o horário de acordo com suas necessidades.
            </p>
        </div>
        <div id="quem-somos" class="section">
            <h1 class="content-title"><i class="glyphicon glyphicon-heart"></i>Quem Somos</h1>
            <p class="content-paragraph">
                Nós da Viver Clin acreditamos na saúde da população e por isso oferecemos consultas e tratamentos
                com preços abaixo do normal, além de termos convênio com a Unimed. Se você deseja um atendimento
                de qualidade excepcional, conte conosco!
            </p>
        </div>
    </div>    
</body>
</asp:Content>
