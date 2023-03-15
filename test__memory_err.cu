constexpr size_t NUM_BLOCKS = 8;
constexpr size_t THREADS_PER_BLOCK = 16;

__global__ void example(int **data) {
	size_t threadID = threadIdx.x;
	size_t blockID = blockIdx.x * blockDim.x;
	size_t globalID = threadID + blockID;
	
	*(data[threadID]) = threadID;
	*(data[blockID]) = blockID;
	*(data[globalID]) = globalID;
}

int main(int argc, char *argv[]) {
	int *host_data[NUM_BLOCKS * THREADS_PER_BLOCK];
	int **dev_data;
	const int zero = 0;

	/*Allocate an integer for each thread in each block */
	for (int block = 0; block < NUM_BLOCKS; block++) 
	{
		for (int thread = 0; thread < THREADS_PER_BLOCK; thread++) 
		{
			int idx = thread + block * THREADS_PER_BLOCK;
			cudaMalloc(&host_data[idx], sizeof(int));
			cudaMemcpy(host_data[idx], &zero, sizeof(int),
			cudaMemcpyHostToDevice);
		}
	}

	/* This inserts an error into block 4, thread 8*/
	host_data[4 * THREADS_PER_BLOCK + 8] = NULL;

	/* Copy the array of pointers to the device */
	cudaMalloc((void**)&dev_data, sizeof(host_data));
	cudaMemcpy(dev_data, host_data, sizeof(host_data), cudaMemcpyHostToDevice);
	
	/* Execute example */
	example <<< NUM_BLOCKS, THREADS_PER_BLOCK >>> (dev_data);
	cudaDeviceSynchronize();
}