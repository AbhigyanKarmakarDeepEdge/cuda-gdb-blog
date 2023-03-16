# cuda-gdb-blog
This is the source code to reproduce the experiments shown in the blog

Requirements:
CUDA (Full CUDA Toolkit)
cuda-gdb
cmake
gcc
g++


Steps

1. Compile the source with\n 
	nvcc -g -G test__memory_err.cu -o test__memory_err
	or
	sh build.sh

2. Execute program 
	./test__memory_err

3. Execute executible with cuda-gdb
	cuda-gdb test__memory_err
	
3. Inside cuda-gdb execute the full program
	run
	
4. Isolate line by using autostep
	autostep 5 for 7
	run
	(Press y when asked whether it should restart execution)
	
5. Focus on segment
	In my case with the following error statement
	[Current focus set to CUDA kernel 0, grid 1, block (4,0,0), thread (0,0,0), device 0, sm 8, warp 0, lane 0]
	Autostep precisely caught exception at test__memory_err.cu:10 (0x555555b2ac10)
	
	cuda device 0 sm 8 warp 0 lane 0

6.	Check focus
	cuda device sm warp lane block thread
	
7.  Get lane information
	info cuda lanes
	
