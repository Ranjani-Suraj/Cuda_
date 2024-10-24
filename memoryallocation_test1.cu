//WE START BY Developing a function that takes in a starting variable, a condition, 
#include <memory>
#include <iostream>
#include <cstdio>
#include <cuda_runtime.h>
//#include <helper_cuda.h>
#include <cuda.h>

__global__ void get_i(dim3 _threadIdx, dim3 _blockIdx, dim3 _blockDim, int dimensions, int* result)
{   
    if (dimensions != 1 && dimensions !=2 && dimensions !=3){
        return;
    }
    if(dimensions >= 1){
        result[0] = _threadIdx.x+(_blockIdx.x*_blockDim.x);
    }
    if (dimensions >= 2){
        result[1] = _threadIdx.y+(_blockIdx.y*_blockDim.y);
    }
    if (dimensions == 3){
        result[2] = _threadIdx.z+(_blockIdx.z*_blockDim.z);
    }
}

__global__ void get_counts(void** args, int num_args, int* counts){
    int max = 0;
    int size_arg;
    for (int i = 0; i < num_args; i+=1){
        size_arg = sizeof(args[i]);
        if(size_arg>max){
            max = size_arg;
        }
    }
    cudaDeviceProp devicePropv;
    cudaGetDeviceProperties(&devicePropv, 0);
    int max_gpu = devicePropv.maxThreadsPerBlock;

    //int max_gpu must be a multiple of 32;

    if(max>max_gpu){
        counts[0] = ceil((double)max/(double)256);
        counts[1] = max_gpu;
    }
    else{
        counts[0] = 1;
        if (size_arg%32 == 0){
            counts[1] = size_arg;
        }
        else {
            while (size_arg%32 != 0){
                size_arg+=1;
            }
            counts[1] = size_arg;
        }
        
    }
}

//
//__global__ void loop(int args[][], pointFunction_t kernel_func, void* output){
//    int* counts;
//    get_counts(args, size(args), counts);
    //
    //*output = kernel_func<<<counts[0], counts[1]>>>();
//}




// __global__ void VecAdd(float* A, float* B, float* C)
// {
//     int *i;
//     get_i(dim3 threadIdx, dim3 blockIdx, dim3 blockDim, 1, i);
//     C[i[0]] = A[i[0]] + B[i[0]];
// }



// // Main program
// int main()
// {
//     // Number of bytes to allocate for N doubles
//     size_t bytes = N*sizeof(double);

//     // Allocate memory for arrays A, B, and C on host
//     double *A = (double*)malloc(bytes);
//     double *B = (double*)malloc(bytes);
//     double *C = (double*)malloc(bytes);

//     // Allocate memory for arrays d_A, d_B, and d_C on device
//     double *d_A, *d_B, *d_C;
//     cudaMalloc(&d_A, bytes);
//     cudaMalloc(&d_B, bytes);
//     cudaMalloc(&d_C, bytes);

//     // Fill host arrays A and B
//     for(int i=0; i<N; i++)
//     {
//         A[i] = 1.0;
//         B[i] = 2.0;
//     }

//     // Copy data from host arrays A and B to device arrays d_A and d_B
//     cudaMemcpy(d_A, A, bytes, cudaMemcpyHostToDevice);
//     cudaMemcpy(d_B, B, bytes, cudaMemcpyHostToDevice);

//     // Set execution configuration parameters
//     //      thr_per_blk: number of CUDA threads per grid block
//     //      blk_in_grid: number of blocks in grid


//     // int thr_per_blk = 256;
//     // int blk_in_grid = ceil( float(N) / thr_per_blk );

//     int counts[2];
//     int *args = {A, B}
//     get_counts(args, 2, counts)
//     VecAdd<<<counts[0], counts[1]>>>(A, B, C);

//     // Launch kernel
//     //add_vectors<<< blk_in_grid, thr_per_blk >>>(d_A, d_B, d_C);

//     // Copy data from device array d_C to host array C
//     cudaMemcpy(C, d_C, bytes, cudaMemcpyDeviceToHost);

//     // Verify results
//     double tolerance = 1.0e-14;
//     for(int i=0; i<N; i++)
//     {
//         if( fabs(C[i] - 3.0) > tolerance)
//         {
//             printf("\nError: value of C[%d] = %d instead of 3.0\n\n", i, C[i]);
//             exit(1);
//         }
//     }

//     // Free CPU memory
//     free(A);
//     free(B);
//     free(C);

//     // Free GPU memory
//     cudaFree(d_A);
//     cudaFree(d_B);
//     cudaFree(d_C);

//     printf("\n---------------------------\n");
//     printf("__SUCCESS__\n");
//     printf("---------------------------\n");
//     printf("N                 = %d\n", N);
//     printf("Threads Per Block = %d\n", thr_per_blk);
//     printf("Blocks In Grid    = %d\n", blk_in_grid);
//     printf("---------------------------\n\n");

//     return 0;
// }

// // int main()
// // {
    
// //     // Kernel invocation with N threads
// //     int A[] = {1, 2, 3};
// //     int B[] = {4, 5, 6};
// //     int C[] = {7, 8, 9};
// //     int counts[2];
// //     int *args = {A, B, C}
// //     get_counts(args, 3, counts)
// //     VecAdd<<<counts[0], counts[1]>>>(A, B, C);
    
// // }



// nvcc -std=c++11 -c -arch=sm_20   
// memoryallocation.cu g++ -o test memoryallocation.cpp alg.cpp test.cpp matrix_cuda.o 
// -L/usr/local/cuda-7.5/lib64  -I/usr/local/cuda-7.5/include -lopenblas -lpthread -lcudart -lcublas  -fopenmp -O3 -Wextra -std=c++11

