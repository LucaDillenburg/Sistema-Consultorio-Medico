using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
//to criptografar e descriptografar
using System.Security.Cryptography;
using System.Text.RegularExpressions;

namespace ProjetoPPI
{
    public enum ForcaSenha
    {
        Vazio = 0,
        MuitoFraca = 1,
        Fraca = 2,
        Medio = 3,
        Forte = 4,
        MuitoForte = 5
    }

    public class Senha
    {
        public static ForcaSenha ForcaDessaSenha(string password)
        {
            if (password.Length < 1)
                return ForcaSenha.Vazio;
            if (password.Length < 8)
                return ForcaSenha.MuitoFraca;

            int score = 2;
            if (password.Length >= 12)
                score++;
            //se ha numeros
            if (Regex.Match(password, @"\d+").Success)
                score++;
            //letras maiusculas e minusculas
            if (Regex.Match(password, @"[a-z]").Success &&
                Regex.Match(password, @"[A-Z]").Success)
                score++;

            if (score == 5)
                return ForcaSenha.MuitoForte;
            
            //caracteres especiais
            if (Regex.Match(password, @"[^\w\s]").Success)
                score++;
            
            return (ForcaSenha)score;
        }


        //CRIPTOGRAFIA
        public static string Criptografar(string entrada)
        {
            TripleDESCryptoServiceProvider tripledescryptoserviceprovider = new TripleDESCryptoServiceProvider();
            MD5CryptoServiceProvider md5cryptoserviceprovider = new MD5CryptoServiceProvider();

            try
            {
                if (entrada.Trim() != "")
                {
                    string myKey = "1563712";
                    tripledescryptoserviceprovider.Key = md5cryptoserviceprovider.ComputeHash(ASCIIEncoding.ASCII.GetBytes(myKey));
                    tripledescryptoserviceprovider.Mode = CipherMode.ECB;
                    ICryptoTransform desdencrypt = tripledescryptoserviceprovider.CreateEncryptor();
                    ASCIIEncoding MyASCIIEncoding = new ASCIIEncoding();
                    byte[] buff = Encoding.ASCII.GetBytes(entrada);

                    return Convert.ToBase64String(desdencrypt.TransformFinalBlock(buff, 0, buff.Length));

                }
                else
                {
                    return "";
                }
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                tripledescryptoserviceprovider = null;
                md5cryptoserviceprovider = null;
            }

        }

        public static string Descriptografar(string entrada)
        {
            TripleDESCryptoServiceProvider tripledescryptoserviceprovider = new TripleDESCryptoServiceProvider();
            MD5CryptoServiceProvider md5cryptoserviceprovider = new MD5CryptoServiceProvider();

            try
            {
                if (entrada.Trim() != "")
                {
                    string myKey = "1563712";
                    tripledescryptoserviceprovider.Key = md5cryptoserviceprovider.ComputeHash(ASCIIEncoding.ASCII.GetBytes(myKey));
                    tripledescryptoserviceprovider.Mode = CipherMode.ECB;
                    ICryptoTransform desdencrypt = tripledescryptoserviceprovider.CreateDecryptor();
                    byte[] buff = Convert.FromBase64String(entrada);

                    return ASCIIEncoding.ASCII.GetString(desdencrypt.TransformFinalBlock(buff, 0, buff.Length));
                }
                else
                {
                    return "";
                }
            }
            catch (Exception exception)
            {
                return "";
            }
            finally
            {
                tripledescryptoserviceprovider = null;
                md5cryptoserviceprovider = null;
            }

        }
    }
}