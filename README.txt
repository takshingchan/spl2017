
Informed Group-Sparse Representation for Singing Voice Separation


                Tak-Shing Chan and Yi-Hsuan Yang
     Music and Audio Computing Lab, Academia Sinica, Taiwan


To  reproduce  the  results of T.-S. T. Chan and Y.-H. Yang, "In-
formed group-sparse representation for singing voice separation,"
Signal Processing Letters, 2016, please do the following:

1  Download the iKala dataset to the "Datasets\iKala" directory:
   http://mac.citi.sinica.edu.tw/ikala/

2  Download the MUS dataset to the "Datasets\DSD100" directory:
   http://liutkus.net/DSD100.zip

3  Run run_melodia.m to generate the vocal  annotations  for  the
   MUS dataset (requires MELODIA and Sonic Annotator)

4  To reproduce the experiments, run reproduce.m

5  The dictionaries have been pre-generated for your convenience.
   To regenerate them, run gen_codebooks.m (requires SPAMS)

If you find this software useful, please cite our paper.

Tak-Shing Chan
Yi-Hsuan Yang
4 September 2016
