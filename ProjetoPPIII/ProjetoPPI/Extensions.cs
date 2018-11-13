using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;

namespace ProjetoPPI
{
    public class ImageMethods
    {
        //extensao para poder conseguir 
        public static Image ImageFromBytes(byte[] blob)
        {
            MemoryStream mStream = new MemoryStream();
            byte[] pData = blob;
            mStream.Write(pData, 0, Convert.ToInt32(pData.Length));
            Bitmap bm = new Bitmap(mStream, false);
            mStream.Dispose();
            return bm;
        }

        public static bool EhImagem(string caminhoArq)
        {
            int index = caminhoArq.LastIndexOf('.');
            if (index < 0)
                return false;
            string tipoImg = caminhoArq.Substring(index);
            return tipoImg.Equals(".JPG", StringComparison.InvariantCultureIgnoreCase)
                || tipoImg.Equals(".JPEG", StringComparison.InvariantCultureIgnoreCase)
                || tipoImg.Equals(".PNG", StringComparison.InvariantCultureIgnoreCase);
        }
    }
}