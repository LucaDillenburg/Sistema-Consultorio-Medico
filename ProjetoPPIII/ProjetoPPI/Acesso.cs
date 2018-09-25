using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ProjetoPPI
{
    public class Acesso
    {
        public static void AdicionarAcesso(string email, TipoUsuario tipoUsuario, ConexaoBD conexaoBD)
        {
            char tipo;
            switch (tipoUsuario)
            {
                case TipoUsuario.paciente:
                    tipo = 'p';
                    break;
                case TipoUsuario.medico:
                    tipo = 'm';
                    break;
                case TipoUsuario.secretaria:
                    tipo = 's';
                    break;
                default:
                    throw new Exception("Tipo de usuario invalido!");
            }

            conexaoBD.ExecuteInUpDel("insert into acesso values('" + DateTime.Now + "', '" + email + "', '" + tipo
                + "')");
        }
    }
}