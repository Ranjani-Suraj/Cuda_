# Cuda_

The above code has 2 main functions that are intended to aid CUDA users that are just starting out: 
1)  get_i() It will get you your thread indices and block indices based on how many dimensions you are working with
2)  get_counts() will give you the number of blocks and number of blocks to use in the GPU based on the size of your arguments

Once you have downloaded the code to your system, run the following code on your command line:

$ nvcc   -rdc=true -c -o temp.o memoryallocation_test1.cu  

$ nvcc -dlink -o memoryallocation_test1.o temp.o -       

$ rm -f libgpu.a   

$ ar cru libgpu.a memoryallocation_test1.o temp.o 

This will create a library so that you can use the code. 

After that, if you want to run code using these syntax changes, you need to run your file using the following code on your command line (assuming you are using cpp). An example of the usage of this code is given in main.cpp. 

$ ranlib libgpu.a 

$ g++ main.cpp -L. -lgpu -o main -L/usr/local/cuda/lib64 -lcudart 

$ ./main 

$ 

 
