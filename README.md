# 8bit_datapath_AES
This is a hardware implementation of AES (Advanced Encryption Standard)[1] algorithm written in Verilog. Because the datapath is 8-bit wide, the overall design is very compact. The architecture was published in [2]. The SBox is taken from Canright's optimal construction [3]. Please read these two papers for the details of my implementation. 

How to run the code? 

1. Start Modelsim and enter the directory that contains all the implementaion files. 
2. Type "source tb.tcl" in the command line of Modelsim. 
3. You should be able to see the waveform now. (You can change the test vectors in aes_tb.v)

Future plans: 

1. Extend the current implementation (AES-128) to AES-256, which I am currently working on.

2. Extend this implementation to AES-192.

3. Replace Canright's Sbox by the Sbox implementation in [4], which was claimed to be even smaller than Canright's optimal construction. I used the modular approach to write this project, so any combinational implementation of SBox can be easily plugged into this architecture. 


[1] FIPS-197, Advanced Encryption Standard (AES), National Institute of Standards and Technology.

[2] Hämäläinen P, Alho T, Hännikäinen M, et al. Design and implementation of low-area and low-power AES encryption hardware core[C]//Digital System Design: Architectures, Methods and Tools, 2006. DSD 2006. 9th EUROMICRO Conference on. IEEE, 2006: 577-583.

[3] Canright D. A very compact Rijndael S-box[J]. 2004.

[4] Ueno R, Homma N, Sugawara Y, et al. Highly Efficient GF (2^ 8) Inversion Circuit Based on Redundant GF Arithmetic and Its Application to AES Design[M]//Cryptographic Hardware and Embedded Systems--CHES 2015. Springer Berlin Heidelberg, 2015: 63-80.
