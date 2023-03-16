#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <iostream>
#include <stdio.h>
__global__ void test__kernel(float* buf, float* result, size_t size)
{
	int i = (blockIdx.x + blockIdx.y * gridDim.x + gridDim.x * gridDim.y * blockIdx.z) * (blockDim.x * blockDim.y * blockDim.z) + (threadIdx.z * (blockDim.x * blockDim.y)) + (threadIdx.y * blockDim.x) + threadIdx.x;	
	result[i] = buf[i] * buf[i+1];
}

void test__add()
{
	float* buf1, * sum;
	float* g_buf1, * g_sum;
	size_t size = 1000;

	buf1 = new float[size];
	sum = new float[size];

	cudaMalloc((void**)&g_buf1, sizeof(float) * size);
	cudaMalloc((void**)&g_sum, sizeof(float) * size);

	//Set vals for host buffers
	for (int i=0 ; i<size ; i++)	buf1[i] = i*0.1;

	cudaMemcpy(g_buf1, buf1, sizeof(float) * (size), cudaMemcpyHostToDevice);

	test__kernel << <dim3(1, size/32 + 1), dim3(32) >> > (g_buf1, g_sum, size);
	cudaDeviceSynchronize();
	
	cudaMemcpy(sum, g_sum, sizeof(float) * size, cudaMemcpyDeviceToHost);
	for (int i=0 ; i<size ; i++)	std::cout << sum[i] << ", ";
	std::cout << std::endl;
}


int main()
{
	test__add();
}
