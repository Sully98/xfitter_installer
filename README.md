# xfitter_installer
automatically installs xfitter 2.2.0 in the current directory

Simply run the install_xfitter.sh script and it will install xfitter in the current directory.

You will need to point it to where to configure the dependencies as used in 
./configure --prefix=/installation/path

You will also need to point the script to the location where all the dependencies will be stored.

With LHAPDF, the pdf sets are no longer included and must be manually installed.
HOWEVER, if you list the pdf sets you want in the file pdfsetslist.txt and remove the ones you don't
it will properly install what you need automatically.

To run the example in the base xfitter package you need to pdf set NNPDF30_nlo_as_0118 at minimum.
