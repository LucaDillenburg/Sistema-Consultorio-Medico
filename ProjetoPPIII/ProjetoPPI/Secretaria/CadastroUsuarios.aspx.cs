using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjetoPPI
{
    public partial class CadastroUsuarios : System.Web.UI.Page
    {
        protected TipoUsuario tipoUsCadastrar;

        protected void Page_Load(object sender, EventArgs e)
        {
            //tudo no .aspx
        }

        //cadastrar
        protected void btnCadastrar_Click(object sender, EventArgs e)
        {
            //ADICIONAR ATRIBUTOS AO MEDICO VERIFICANDO SE ELES SAO VALIDOS
            bool tudoCerto = true;

            ExAtributosSimples atributos;
            if (this.tipoUsCadastrar == TipoUsuario.medico)
                atributos = new AtributosMedico();
            else
            if (this.tipoUsCadastrar == TipoUsuario.paciente)
                atributos = new AtributosPaciente();
            else
                atributos = new AtributosSecretaria();

            //ATRIBUTOS COMUNS AOS 3 TIPOS DE USUARIO:

            //email
            try
            {
                atributos.Email = this.txtEmail.Text;
                this.ProcEmailValidoOuNao(true);
            }
            catch (Exception err)
            {
                this.ProcEmailValidoOuNao(false);
                tudoCerto = false;
            }

            //nome
            try
            {
                atributos.NomeCompleto = this.txtNome.Text;
                this.ProcNomeValidoOuNao(true);
            }
            catch (Exception err)
            {
                this.ProcNomeValidoOuNao(false);
                tudoCerto = false;
            }

            //endereco
            try
            {
                ((ExAtributos)atributos).Endereco = this.txtEndereco.Text;
            }
            catch (Exception err)
            {
                tudoCerto = false;
                this.lbMsgEndereco.Text = "Digite seu endereço!";
            }

            //confirmacao senha
            if (this.txtSenha.Text == this.txtConfirmacaoSenha.Text)
                this.ProcConfSenhaValidaOuNao(true);
            else
            {
                this.ProcConfSenhaValidaOuNao(false);
                tudoCerto = false;
            }

            //senha
            ForcaSenha forcaSenha = atributos.AdicionarSenha(this.txtSenha.Text);
            if (forcaSenha == ForcaSenha.Vazio || forcaSenha == ForcaSenha.MuitoFraca)
            {
                this.ProcSenhaValidaOuNao(forcaSenha, false);
                tudoCerto = false;
            }
            else
                this.ProcSenhaValidaOuNao(forcaSenha, true);

            if (this.tipoUsCadastrar == TipoUsuario.secretaria)
            {
                if (tudoCerto)
                {
                    try
                    {
                        ((Secretaria)Session["usuario"]).CadastrarSecretaria((AtributosSecretaria)atributos);
                    }
                    catch(Exception err)
                    {
                        this.lbMsg.Attributes["style"] = "color: red";
                        this.lbMsg.Text = "Erro ao adicionar secretária no banco...";
                        tudoCerto = false;
                    }
                }
            }else
            {
                //DAQUI PRA BAIXO NAO EH CADASTRO DE SECRETARIA
                //celular
                try
                {
                    ((ExAtributos)atributos).Celular = this.txtCelular.Text;
                    this.ProcCelularValidoOuNao(true);
                }
                catch (Exception err)
                {
                    this.ProcCelularValidoOuNao(false);
                    tudoCerto = false;
                }

                //telefone
                try
                {
                    ((ExAtributos)atributos).TelefoneResidencial = this.txtTelefone.Text;
                    this.ProcTelefoneValidoOuNao(true);
                }
                catch (Exception err)
                {
                    this.ProcTelefoneValidoOuNao(false);
                    tudoCerto = false;
                }

                //data nascimento
                try
                {
                    if (this.tipoUsCadastrar == TipoUsuario.medico)
                        ((AtributosMedico)atributos).DataNascimento = this.DataNascimentoAtual();
                    else
                        ((AtributosPaciente)atributos).DataNascimento = this.DataNascimentoAtual();
                    this.ProcNascimentoValidaOuNao(true);
                }
                catch (Exception err)
                {
                    this.ProcNascimentoValidaOuNao(false);
                    tudoCerto = false;
                }

                if (this.tipoUsCadastrar == TipoUsuario.medico)
                    //CRM
                    try
                    {
                        ((AtributosMedico)atributos).CRM = this.txtCRM.Text;
                        this.ProcCRMValidoOuNao(true);
                    }
                    catch (Exception err)
                    {
                        this.ProcCRMValidoOuNao(false);
                        tudoCerto = false;
                    }

                if (tudoCerto)
                //ADICIONAR MEDICO AO BANCO
                {
                    this.lbMsg.Text = "";

                    try
                    {
                        if (this.tipoUsCadastrar == TipoUsuario.medico)
                            ((Secretaria)Session["usuario"]).CadastrarMedico((AtributosMedico)atributos);
                        else
                            ((Secretaria)Session["usuario"]).CadastrarPaciente((AtributosPaciente)atributos);
                    }
                    catch (Exception err)
                    {
                        this.lbMsg.Attributes["style"] = "color: red";
                        this.lbMsg.Text = "Erro ao adicionar "+ ((this.tipoUsCadastrar == TipoUsuario.medico)?"médico":"paciente") + " no banco...";
                        tudoCerto = false;
                    }
                }
            }

            if (tudoCerto)
            //ADICIONAR MEDICO AO BANCO
            {
                this.txtEmail.Text = "";
                this.lbMsgEmail.Text = "";
                this.txtNome.Text = "";
                this.lbMsgNome.Text = "";
                this.txtCRM.Text = "";
                this.lbMsgCRM.Text = "";
                this.txtCelular.Text = "";
                this.lbMsgCelular.Text = "";
                this.txtTelefone.Text = "";
                this.lbMsgTelefone.Text = "";
                this.txtEndereco.Text = "";
                this.lbMsgEndereco.Text = "";
                this.txtDataNascimento.Text = "";
                this.lbMsgDataNascimento.Text = "";
                this.txtSenha.Text = "";
                this.lbMsgSenha.Text = "";
                this.txtConfirmacaoSenha.Text = "";
                this.lbMsgConfSenha.Text = "";
                this.txtSenha.Attributes.Add("value", "");
                this.txtConfirmacaoSenha.Attributes.Add("value", "");

                this.lbMsg.Attributes["style"] = "color: green";
                this.lbMsg.Text = "Médico adicionado ao banco!";
            }
            else
            {
                this.txtSenha.Attributes.Add("value", this.txtSenha.Text);
                this.txtConfirmacaoSenha.Attributes.Add("value", this.txtConfirmacaoSenha.Text);
            }
        }


        // CHANGED (ver se esta certo enquanto usuario digita)
        protected void txtSenha_TextChanged(object sender, EventArgs e)
        {
            ForcaSenha forcaSenha = Senha.ForcaDessaSenha(this.txtSenha.Text);
            this.ProcSenhaValidaOuNao(forcaSenha, forcaSenha == ForcaSenha.Vazio || forcaSenha == ForcaSenha.MuitoFraca);
            //this.txtSenha.Attributes.Add("value", this.txtSenha.Text);
        }

        protected void ProcSenhaValidaOuNao(ForcaSenha forcaSenha, bool valida)
        {
            if (!valida)
            {
                this.lbMsgSenha.Attributes["style"] = "color: red";
                this.lbMsgSenha.Text = forcaSenha.ToString();
            }
            else
            {
                this.lbMsgSenha.Attributes["style"] = "color: green";
                this.lbMsgSenha.Text = forcaSenha.ToString();
            }

        }

        protected void txtConfirmacaoSenha_TextChanged(object sender, EventArgs e)
        {
            this.ProcConfSenhaValidaOuNao(this.txtConfirmacaoSenha.Text != this.txtSenha.Text);
            //this.txtConfirmacaoSenha.Attributes.Add("value", this.txtConfirmacaoSenha.Text);
        }

        protected void ProcConfSenhaValidaOuNao(bool valida)
        {
            if (!valida)
                this.lbMsgConfSenha.Text = "As senhas não correspondem!";
            else
                this.lbMsgConfSenha.Text = "";
        }
        
        protected DateTime DataNascimentoAtual()
        {
            return DateTime.ParseExact(this.txtDataNascimento.Text, "dd/MM/yyyy", System.Globalization.CultureInfo.InvariantCulture);
        }

        protected void txtDataNascimento_TextChanged(object sender, EventArgs e)
        {
            if (this.tipoUsCadastrar == TipoUsuario.medico)
                this.ProcNascimentoValidaOuNao(AtributosMedico.DataNascimentoValida(this.DataNascimentoAtual()));
            else
                this.ProcNascimentoValidaOuNao(AtributosPaciente.DataNascimentoValida(this.DataNascimentoAtual()));
        }

        protected void ProcNascimentoValidaOuNao(bool valido)
        {
            if (!valido)
            {
                if (this.tipoUsCadastrar == TipoUsuario.medico)
                    this.lbMsgDataNascimento.Text = "Essa não é uma data de nascimento válida! Um médico precisa ser maior de idade.";
                else
                    this.lbMsgDataNascimento.Text = "Essa não é uma data de nascimento válida! O paciente já precisa ter nascido.";
            }
            else
                this.lbMsgDataNascimento.Text = "";
        }

        protected void txtTelefone_TextChanged(object sender, EventArgs e)
        {
            this.ProcTelefoneValidoOuNao(ExAtributos.TelefoneValido(this.txtTelefone.Text));
        }

        protected void ProcTelefoneValidoOuNao(bool valido)
        {
            if (valido)
                this.lbMsgTelefone.Text = "";
            else
                this.lbMsgTelefone.Text = "Telefone inválido! Exemplo: (13)3300-1792 (os dois primeiros dígitos são o DDD)";
        }

        protected void txtCelular_TextChanged(object sender, EventArgs e)
        {
            this.ProcCelularValidoOuNao(ExAtributos.CelularValido(this.txtCelular.Text));
        }

        protected void ProcCelularValidoOuNao(bool valido)
        {
            if (valido)
                this.lbMsgCelular.Text = "";
            else
                this.lbMsgCelular.Text = "Celular inválido! Exemplo: (17)97530-2342 (os dois primeiros dígitos são o DDD).";
        }

        protected void txtEmail_TextChanged(object sender, EventArgs e)
        {
            this.ProcEmailValidoOuNao(ExAtributos.EmailValido(this.txtEmail.Text));
        }

        protected void ProcEmailValidoOuNao(bool valido)
        {
            if (valido)
                this.lbMsgEmail.Text = "";
            else
                this.lbMsgEmail.Text = "Email inválido!";
        }

        protected void txtNome_TextChanged(object sender, EventArgs e)
        {
            this.ProcNomeValidoOuNao(ExAtributos.NomeCompletoValido(this.txtNome.Text));
        }

        protected void ProcNomeValidoOuNao(bool valido)
        {
            if (valido)
                this.lbMsgNome.Text = "";
            else
                this.lbMsgNome.Text = "Nome inválido! Escreva seu nome com as iniciais maiúsculas e o resto minúscula...";
        }

        protected void txtCRM_TextChanged(object sender, EventArgs e)
        {
            if (this.tipoUsCadastrar != TipoUsuario.medico)
                return;
            this.ProcCRMValidoOuNao(AtributosMedico.CRMValido(this.txtCRM.Text));
        }

        protected void ProcCRMValidoOuNao(bool valido)
        {
            if (this.tipoUsCadastrar != TipoUsuario.medico)
                return;
            if (valido)
                this.lbMsgCRM.Text = "";
            else
                this.lbMsgCRM.Text = "CRM inválido! Padrão: 00000000-0/AA sendo AA a sigla do estado.";
        }

        protected void txtEndereco_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrWhiteSpace(this.txtEndereco.Text))
                this.lbMsgCRM.Text = "";
        }
    }
}