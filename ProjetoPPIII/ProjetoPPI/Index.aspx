<%@ Page Title="" Language="C#" MasterPageFile="~/Menu.Master" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="ProjetoPPI.Index" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <body id="bodyIndex">        
        <div class="banner" id="index-1">
            <h1 class="text-shadow-drop-center">Bem-Vindo</h1>
        </div>
        
        <div id="gradient-1"></div>

        <div class="section">
            <h1>Quem Somos Nós</h1>
            <p>
                Nós somos a clínica médica mais evoluída de Campinas. Oferecemos um serviço de primeira com o luxo e conforto que você e sua família merece. Se é perfeição que procura,
                veio ao lugar certo. Nossa tecnologia de ponta, top de linha no mercado, assegura aos nossos clientes o melhor atendimento possível. Além disso, nosso incrível sistema
                de administração online faz tudo rodar como uma máquina bem lubrificada.
            </p>
        </div>

        <div class ="section" id="section-esquerda-index">
            <h1>Nossos Profissionais</h1>
            <p>Queremos que nossos clientes tenham o melhor atendimento possível, por isso contratamos somente os melhores dos melhores. Seja na administração, na clínica ou até na
                informática, nossos profissionais tiveram o melhor desempenho durante suas carreiras. São os mais confiáveis disponíveis no mercado, garantindo a você conforto e segurança
                durante sua experiência aqui.
            </p>
        </div>

        <div class="section">
            <div class="polaroid">
                <img src="assistant-beard-boss-630836.jpg" />
                <div class="container">
                    <p>Agendamento Flexível</p>
                </div>
            </div>   
            <div class="polaroid">
                <img src="medico-paciente.jpg" />
                <div class="container">
                    <p>Atendimento Amigável</p>
                </div>
            </div> 
        </div>

        <footer class="footer">
            <h3>Autores: </h3>
            <p>
                Fábio Minguini Faúndes & Luca Dillenburg
            </p>
        </footer>
    </body>
</asp:Content>
