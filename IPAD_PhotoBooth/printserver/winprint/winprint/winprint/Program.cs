using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Printing;
using System.Drawing;
using System.Drawing.Printing;
using System.Net;
using System.IO;

namespace winprint
{
    class Program
    {
        static int port = 80;
        static String path = "";
        static int x = 0;
        static int y = 0;
        static int width = 0;
        static int height = 0;
        static int copies = 0;
        static bool test = false;
        
        static void GetAddresses()
        {
            IPHostEntry host = Dns.GetHostEntry( Dns.GetHostName() );
            foreach ( IPAddress ip in host.AddressList)
            {
                if (ip.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork)
                {
                    Console.WriteLine("Possible Machine Server Address: " + ip.ToString() );
                }
            }
        }

        static void Main(string[] args)
        {
            try
            {
               
                String port_or_file = args[0];
                if (System.IO.File.Exists(port_or_file))
                {
                    Console.WriteLine("Got test file->" + port_or_file);
                    test = true;
                    path = port_or_file;
                }
                else
                {
                    port = int.Parse(port_or_file);
                    Console.WriteLine("Got server port->" + port);
                    GetAddresses();
                }

                x = int.Parse(args[1]);

                y = int.Parse(args[2]);

                width = int.Parse(args[3]);

                height = int.Parse(args[4]);

                copies = int.Parse(args[5]);

                if (test)
                {
                    PrintPhotos();
                }
                else
                {
                    RunServer();
                }
            }
            catch (System.Exception e)
            {
                Console.WriteLine("ERROR:" + e.ToString());
                System.Environment.Exit(1);
            }
        }

        public static void RunServer()
            {
                var prefix = "http://*:" + port +"/";
                HttpListener listener = new HttpListener();
                listener.Prefixes.Add(prefix);
                try
                {
                    Console.WriteLine("Going to listen for print requests at->" + prefix + "...");
                    listener.Start();
                }
                catch (HttpListenerException hlex)
                {
                    Console.WriteLine("ERROR:" + hlex.ToString());
                    System.Environment.Exit(1);
                    return;
                }
    
                while (listener.IsListening)
                {
                    var context = listener.GetContext();
                    ProcessRequest(context);
                }
                listener.Close();
            }
        

        private static void ProcessRequest(HttpListenerContext context) 
        {
            Console.WriteLine("Got request...");

            StreamReader body = new StreamReader(context.Request.InputStream); //.ReadToEnd();

            Console.WriteLine("Parsing body of request for the image...");

            //var parser = new HttpMultipartParser.MultipartFormDataParser(context.Request.InputStream);
            //var file =  parser.Files.First();
            //var fname = file.FileName;

            AntsCode.Util.MultipartParser parser = new AntsCode.Util.MultipartParser(
                context.Request.InputStream);
            //Console.WriteLine(parser.Filename);
            //Console.WriteLine("Converting to image...");
            
            MemoryStream mems = new MemoryStream(parser.FileContents);

            Console.WriteLine("Saving jpeg...");
            Image img = Image.FromStream( mems);
            if (img.Width > img.Height)
                img.RotateFlip(RotateFlipType.Rotate90FlipNone);

            img.Save("print.jpg");

            Console.WriteLine("image size=" + img.Width + "x" + img.Height );

            /*
            Form1 frm = new Form1();
            frm.pictureBox1.Image = img;
            frm.ShowDialog();
            */

            /*
            MemoryStream mems = new MemoryStream();
            context.Request.InputStream.CopyTo(mems);

            byte[] bytes = mems.ToArray();
            Console.WriteLine(bytes.Length);

            
            BinaryWriter w = new BinaryWriter(
            

            //Image img = Image.FromStream(mems);
            
            img.Save("served.jpg", System.Drawing.Imaging.ImageFormat.Jpeg);

             * */


            byte[] b = Encoding.UTF8.GetBytes("ACK");
            context.Response.StatusCode = 200;
            context.Response.KeepAlive = false;
            context.Response.ContentLength64 = b.Length;

            var output = context.Response.OutputStream;
            output.Write(b, 0, b.Length);
            context.Response.Close();

            path = "print.jpg";
            PrintPhotos();
        }


        private static void PrintPhotos()
        {
            Console.WriteLine("Setting up print page...");

            PrintDocument printDoc = new PrintDocument();
            printDoc.PrintController = new System.Drawing.Printing.StandardPrintController();
            printDoc.PrintPage += new PrintPageEventHandler(printDoc_PrintPage);
            printDoc.DefaultPageSettings.Landscape = false;

            //gw if (ConfigUtility.MaxCopies > 1)
            //if (currentSession.MaxCopies >= 1)
            {
                printDoc.PrinterSettings.Copies = (short)copies; // (short)currentSession.MaxCopies;
                //gw (short)ConfigUtility.MaxCopies;
            }


            printDoc.Print();
        }

        private static void printDoc_PrintPage(object sender, PrintPageEventArgs e)
        {

            Console.WriteLine("Printing...");

            Image photo = Image.FromFile(path);//Image.FromFile(this.currentSession.PhotoPath + "\\print.jpg");
            //e.Graphics.DrawImage(photo, 0, 0, 400, 600);
            e.Graphics.DrawImage(photo, x, y, width, height);
            photo.Dispose();
        }

    }
}
