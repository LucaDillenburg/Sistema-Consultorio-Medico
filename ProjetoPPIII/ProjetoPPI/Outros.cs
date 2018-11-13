using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;

namespace ProjetoPPI
{
    //metodos de mais de um usuario (paciente, medico e secretaria)
    public class Usuario
    {
        public static void AuxAdicionarImagem(ExAtributos atributos, bool ehPaciente, FileUpload fileUpload, ConexaoBD conexaoBD)
        {
            //deletar todas as imagens armazenadas desse paciente
            string caminho = "~/Fotos/" + (ehPaciente?"ftPac":"ftMed") + atributos.Email;
            string camCompSem = System.Web.HttpContext.Current.Server.MapPath(caminho);
            for (int i = 0; i < 3; i++)
            {
                string tipo = null;
                switch (i)
                {
                    case 0: tipo = ".jpg"; break;
                    case 1: tipo = ".jpeg"; break;
                    case 2: tipo = ".png"; break;
                }
                if (File.Exists(camCompSem + tipo))
                    File.Delete(camCompSem + tipo);
            }

            caminho += fileUpload.FileName.Substring(fileUpload.FileName.LastIndexOf('.')); // o tipo da imagem

            //salvar imagem em pasta do servidor
            string path = System.Web.HttpContext.Current.Server.MapPath(caminho);
            File.WriteAllBytes(path, fileUpload.FileBytes);

            //guardar o caminho no banco
            conexaoBD.ExecuteInUpDel("update " + (ehPaciente?"paciente":"medico") + " set caminhoFoto = '" +
                caminho.Substring(1) + /*remove o caracter ~*/ "' " + "where email = '" + atributos.Email + "'");
            atributos.CaminhoFoto = caminho.Substring(1);
        }
    }
}