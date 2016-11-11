
 ~/my-bin/meme/bin/meme -dna -mod oops -pal  crp0.fna 

## Download and install blat
cd ~/biosoft
mkdir MEMEsuite &&  cd MEMEsuite
## http://meme-suite.org/doc/download.html
wget  http://meme-suite.org/meme-software/4.11.2/meme_4.11.2_1.tar.gz
tar zxvf meme_4.11.2_1.tar.gz 
cd meme_4.11.2/
./configure --prefix=$HOME/my-bin/meme --with-url="http://meme-suite.org"
make 
make install   
 
## ~/my-bin/meme/bin/ 
## http://meme-suite.org/doc/meme.html?man_type=web

# MEME discovers novel, ungapped motifs (recurring, fixed-length patterns) in your sequences 
# sequences		http://meme-suite.org/meme-software/example-datasets/crp0.fna
# sample output	http://meme-suite.org/doc/examples/meme_example_output_files/meme.html
# MEME splits variable-length patterns into two or more separate motifs. 

# meme crp0.s -dna -mod oops -pal
# meme crp0.s -dna -mod oops -revcomp
# meme crp0.s -dna -mod oops -revcomp -w 20
