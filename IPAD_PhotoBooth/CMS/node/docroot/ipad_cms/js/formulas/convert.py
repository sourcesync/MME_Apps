import os.path
import sys

INFILE = sys.argv[1]

OUTFILE = os.path.basename( INFILE ).split(".")[0] + ".js"
f = open(INFILE,'r')
content = f.read()
f.close()

#
# write the pde as html...
#
OUT_PDE_HTML = INFILE + ".html"
html = "<html><body><pre><code>" + content + "</code></pre></body></html>"
f = open( OUT_PDE_HTML, 'w')
f.write(html)
f.close();

#
# convert pde to javascript...
#
str = content

# replace println with console.log
str = str.replace("println","console.log")

# replace void with function
str = str.replace("void", "function");

# replace float with var...
str = str.replace("float","var")

# replace float with var...
str = str.replace("int","var")

# replace the string 'round'
str = str.replace("round","")

# replace the setup with a unique name...
if INFILE == "Laser_cal.pde":
	str = str.replace("setup","lsc_price_func" )
	
elif INFILE == "sketch_3dscan.pde":
	str = str.replace("setup","tds_price_func" )

elif INFILE == "print_cal.pde":
	str = str.replace("setup","wide_price_func" )

elif INFILE == "Connex_cal.pde":
	str = str.replace("setup","connex_price_func" )

elif INFILE == "PoyJet_cal.pde":
	str = str.replace("setup","projet_price_func" )

elif INFILE == "zprinter.pde":
        str = str.replace("setup","zprinter_price_func" )

f = open(OUTFILE,'w')
f.write( str )
f.close()

#
# write an html version of it...
#
OUTHTML = os.path.basename( INFILE ).split(".")[0] + ".html"
html = "<html><body><pre><code>" + str + "</code></pre></body></html>"

f = open(OUTHTML,'w')
f.write( html )
f.close()


