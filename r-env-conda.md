# Install R kerenl on Ubuntu AWS/Aliyun

1. system dynamic libraries
```bash
sudo apt-get install gfortran
sudo apt-get install build-essential 
sudo apt-get install libxt-dev 
sudo apt-get install libcurl4-openssl-dev
sudo apt-get install libxml++2.6-dev
sudo apt-get install libssl-dev
sudo apt-get install libopenblas-dev
sudo apt-get install libfontconfig1 libxrender1
```

2. Create r-env 
```bash
conda create -n r -c r r-essentials r-base
Conda activate r
conda install -c r r-pheatmap 
conda install  bioconductor-clusterprofiler bioconductor-deseq
# conda install bioconductor-tximport
```
3. Commdline run R, and install jupyter R  

Run R 
```bash
R
```
then, install
```R
IRkernel::installspec(user=FALSE)
```


4. Open jupyter lab:

```bash
nohup jupyter lab --allow-root &
```


FAQ 1. fixed libXreder not found

libXrender.so.1: cannot open shared object file: No such file or directory


sudo apt-get install libfontconfig1 libxrender1

来自 <https://www.cyberciti.biz/faq/debian-ubuntu-linux-wkhtmltopdf-error-while-loading-shared-libraries-libxrender-so-1/> 


FAQ 2. fixed libopenblas not found

sudo apt-get install libopenblas-dev


来自 <https://stackoverflow.com/questions/36893382/scipy-installation-issue-getting-importerror-libopenblas-so-0-cannot-open-sha> 