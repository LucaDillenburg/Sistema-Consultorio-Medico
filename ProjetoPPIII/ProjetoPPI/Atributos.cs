using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Net.Mail;
using System.Text.RegularExpressions;
using System.Web;

namespace ProjetoPPI
{
    //interseccao de atributos
    public class ExAtributos : ExAtributosSimples
    {
        protected string celular;
        protected string telefoneResidencial;
        const string celularPattern = @"^\(\d{2}\)\d{4,5}-\d{4}$";
        const string telefonePattern = @"^\(\d{2}\)\d{4}-\d{4}$";
        public static bool CelularValido(string celular)
        {
            return new Regex(celularPattern).Match(celular).Success;
        }
        public static bool TelefoneValido(string telefone)
        {
            return new Regex(telefonePattern).Match(telefone).Success;
        }
        public string Celular
        {
            get {return this.celular; }
            set
            {
                if (!ExAtributos.CelularValido(value))
                    throw new Exception("Celular invalido");
                this.celular = value;
            }
        }
        public string TelefoneResidencial
        {
            get { return this.telefoneResidencial; }
            set
            {
                if (!ExAtributos.TelefoneValido(value))
                    throw new Exception("Telefone invalido");
                this.telefoneResidencial = value;
            }
        }

        protected string caminhoFoto;
        public string CaminhoFoto
        {
            get { return this.caminhoFoto; }
            set { this.caminhoFoto = value; }
        }

        protected const string dataNascimentoPattern = @"^\d{2}/\d{2}/\d{4}$";
    }

    public class ExAtributosSimples
    {
        protected string email;
        protected string nomeCompleto;
        protected string endereco;
        protected string senhaCriptografada;

        protected ForcaSenha forcaSenha = ForcaSenha.Vazio;

        public static bool EmailValido(string email)
        {
            if (String.IsNullOrEmpty(email) || email.Length > 50)
                return false;

            try
            {
                MailAddress m = new MailAddress(email);
                return true;
            }
            catch (FormatException)
            {
                return false;
            }
        }
        public string Email
        {
            get { return this.email; }
            set
            {
                if (!ExAtributosSimples.EmailValido(value))
                    throw new Exception("Email invalido!");
                this.email = value;
            }
        }

        protected const string nomePattern = @"^\b[A-ZÀ-Ÿ][a-zà-ÿ']+(( [a-zà-ÿ']{1,3})* [A-ZÀ-Ÿ][a-zà-ÿ']+)+$";
        public static bool NomeCompletoValido(string nome)
        {
            return new Regex(nomePattern).Match(nome).Success;
        }
        public string NomeCompleto
        {
            get { return this.nomeCompleto; }
            set
            {
                if (value.Length > 50 || !ExAtributosSimples.NomeCompletoValido(value))
                    throw new Exception("Nome invalido!");
                this.nomeCompleto = value;
            }
        }

        public string Endereco
        {
            get { return this.endereco; }
            set
            {
                if (String.IsNullOrWhiteSpace(value) || value.Length > 100)
                    throw new Exception("Endereco invalido!");
                this.endereco = value;
            }
        }

        public ForcaSenha AdicionarSenha(string senha)
        {
            ForcaSenha forcaSenha = Senha.ForcaDessaSenha(senha);
            if (forcaSenha == ForcaSenha.Vazio || forcaSenha == ForcaSenha.MuitoFraca)
                return forcaSenha;

            this.senhaCriptografada = Senha.Criptografar(senha);

            if (this.senhaCriptografada.Length > 256)
            {
                this.senhaCriptografada = null;
                throw new Exception("Senha muito grande!");
            }

            this.forcaSenha = forcaSenha;
            return forcaSenha;
        }
        public ForcaSenha ForcaSenha
        {
            get
            {
                return this.forcaSenha;
            }
        }
        public string SenhaCriptografada
        {
            get
            {
                return this.senhaCriptografada;
            }
        }
    }


    //ATRIBUTOS USUARIOS
    public class AtributosMedico : ExAtributos
    {
        protected string crm;
        protected DateTime dataDeNascimento;

        //getters e setters
        const string crmPattern = @"^\d{8}-\d/[A-Z]{2}$";
        public static bool CRMValido(string crm)
        {
            return new Regex(crmPattern).Match(crm).Success;
        }
        public string CRM
        {
            get { return this.crm; }
            set
            {
                if (!AtributosMedico.CRMValido(value))
                    throw new Exception("CRM invalido!");
                this.crm = value;
            }
        }
        
        public static bool DataNascimentoValida(DateTime dataNascimento)
        {
            if (dataNascimento == null)
                return false;
            DateTime data18Anos = new DateTime(dataNascimento.Year + 18, dataNascimento.Month, 
                dataNascimento.Day);
            //verifica se medico eh maior que 18 anos
            return data18Anos.CompareTo(DateTime.Now) <= 0;
        }
        public DateTime DataNascimento
        {
            get { return this.dataDeNascimento; }
            set
            {
                if (!AtributosMedico.DataNascimentoValida(value))
                    throw new Exception("Data de nascimento invalido!");
                this.dataDeNascimento = value;
            }
        }
    }

    public class AtributosPaciente : ExAtributos
    {
        protected DateTime dataDeNascimento;

        //getters e setters
        public static bool DataNascimentoValida(DateTime dataNascimento)
        {
            //paciente pode nao ter nascido ainda, mas nao se pode cadastrar um paciente que vai nascer soh daqui a mais de um ano
            DateTime auxAgora = DateTime.Now;
            DateTime daquiUmAno = new DateTime(auxAgora.Year + 1, auxAgora.Month, auxAgora.Day);
            return (dataNascimento.CompareTo(daquiUmAno) <= 0);
        }
        public DateTime DataNascimento
        {
            get { return this.dataDeNascimento; }
            set
            {
                if (!AtributosPaciente.DataNascimentoValida(value))
                    throw new Exception("Data de nascimento invalido!");
                this.dataDeNascimento = value;
            }
        }

    }

    public class AtributosSecretaria : ExAtributosSimples
    {

    }


    //ATRIBUTOS CONSULTAS
    public class AtributosConsulta
    {
        protected string proposito;
        protected DateTime horario;
        protected string observacoes = "";
        protected char status = 'n'; //'n': ainda nao ocorrido, 's': ocorrido, 'c': cancelado
        protected bool umaHora = false;
        //duração de 30 minutos a 1h, no máximo!
        protected string emailMedico;
        protected string emailPaciente;
        //comentario
        protected int satisfacao = -1;
        protected string comentario;
        protected DateTime horarioSatisfacao;
        protected bool medicoJahViuSatisfacao = false;

        public string Proposito
        {
            get { return this.proposito; }
            set
            {
                if (String.IsNullOrEmpty(value) || String.IsNullOrWhiteSpace(value) || value.Length > 50)
                    throw new Exception("Propósito inválido!");
                //colocar primeira letra maiuscula
                this.proposito = char.ToUpper(value[0]) + value.Substring(1);
            }
        }
        
        public const string FORMATO_HORARIO = "dd/MM/yyyy  HH:mm:ss";
        public DateTime Horario
        {
            get { return this.horario; }
        }
        public void SetHorario (DateTime value, ConexaoBD conexaoBD)
        {
            //Horario de atendimento: 9h-12h e 14h-17h
            if (!((value.Hour >= 9 && value.Hour < 12) || (value.Hour >= 14 && value.Hour < 17)))
                throw new Exception("Horario de atendimento dos medicos eh de 9h-12h e 14h-17h!");

            //30min ou 0min
            if (value.Minute != 0 && value.Minute != 30)
                throw new Exception("Só pode haver consultas em horas cheias ou metades de horas.");

            if (value.Second != 0)
                throw new Exception("Só pode haver consultas em horas cheias ou metades de horas.");

            DateTime aux = this.horario;
            this.horario = value;
            //verificar se paciente jah teria nascido nessa data (se o paciente jah foi adicionado)
            if (!String.IsNullOrEmpty(this.emailPaciente) && !this.PacienteJahNasceuAtehConsulta(conexaoBD))
            {
                this.horario = aux;
                throw new Exception("O paciente ainda não vai ter nascido até a data da consulta...");
            }
        }
       /* public string SegundoHorario
        {
            get
            {
                if (!this.umaHora)
                    throw new Exception("Não há segundo horário nessa consulta.");
                if (this.horario == null)
                    throw new Exception("O horário principal ainda não foi adicionado!");

                if (horario.Minute == 0)
                    return new DateTime(this.horario.Year, this.horario.Month, this.horario.Day, this.horario.Hour, 30, 0).ToString("dd/MM/yyyy");
                else
                    return new DateTime(this.horario.Year, this.horario.Month, this.horario.Day, this.horario.Hour + 1, 0, 0).ToString("dd/MM/yyyy");
            }
        } */
        public string Observacoes
        {
            get { return this.observacoes; }
            set { this.observacoes = value; }
        }
        public char Status
        {
            get { return this.status; }
            set { this.status = value; }
        }
        public bool UmaHora
        {
            get { return this.umaHora; }
            set {  this.umaHora = value; }
        }

        public string EmailMedico
        {
            get { return this.emailMedico; }
        }
        public void SetEmailMedico (string value, ConexaoBD conexaoBD)
        {
            if (!ExAtributosSimples.EmailValido(value))
                throw new Exception("Email invalido!");
            if (!Medico.Existe(value, conexaoBD))
                throw new Exception("Esse médico não existe!");
            this.emailMedico = value;
        }
        public string EmailPaciente
        {
            get { return this.emailPaciente; }
        }
        public void SetEmailPaciente(string value, ConexaoBD conexaoBD)
        {
            if (!ExAtributosSimples.EmailValido(value))
                throw new Exception("Email invalido!");
            AtributosPaciente atrPaciente = Paciente.DeEmail(value, conexaoBD);
            if (atrPaciente == null)
                throw new Exception("Esse paciente não existe!");
            if (this.horario != new DateTime() && !this.PacienteJahNasceuAtehConsulta(atrPaciente))
                throw new Exception("O paciente ainda não vai ter nascido até a data da consulta...");
            this.emailPaciente = value;
        }

        public string Comentario
        {
            get { return this.comentario; }
            set
            {
                if (String.IsNullOrEmpty(value))
                    this.comentario = "";
                if (String.IsNullOrWhiteSpace(value) || value.Length < 6)
                    throw new Exception("Comentario invalido!");
                this.comentario = Char.ToUpper(value[0]) + (value.Length > 1 ? value.Substring(1) : "");
            }
        }
        public int Satisfacao
        {
            get { return this.satisfacao; }
            set
            {
                if (value < -1 || value > 5)
                    throw new Exception("Satisfacao invalida!");
                this.satisfacao = value;
            }
        }
        public DateTime HorarioSatisfacao
        {
            get { return this.horarioSatisfacao; }
            set { this.horarioSatisfacao = value; }
        }
        public bool MedicoJahViuSatisfacao
        {
            get { return this.medicoJahViuSatisfacao;  }
            set { this.medicoJahViuSatisfacao = value; }
        }

        protected bool PacienteJahNasceuAtehConsulta(ConexaoBD conexaoBD)
        { return this.PacienteJahNasceuAtehConsulta(Paciente.DeEmail(this.emailPaciente, conexaoBD)); }

        protected bool PacienteJahNasceuAtehConsulta(AtributosPaciente atrPaciente)
        {
            return atrPaciente.DataNascimento.CompareTo(this.horario) < 0;
        }
    }


    public class AtributosConsultaCod : AtributosConsulta
    {
        protected int codConsulta;

        public int CodConsulta
        {
            get { return this.codConsulta; }
            set
            {
                if (value <= 0)
                    throw new Exception("Codigo invalido!");
                this.codConsulta = value;
            }
        }
    }

}