#homedir=/opt/ibs_lib/apps/neuron/8.2.6/GCC/1220/H100

# Remove nrn if it is already installed
if [ -d nrn ]; then
	echo -e "\n#####################"
	echo -e "Removing previous nrn folder"
	echo -e "#####################\n"

 	rm -rf nrn
	
fi

if [ -d nrn ]; then
	echo -e "\n#####################"
	echo -e "Removing previous install folder"
	echo -e "#####################\n"

 	rm -rf  install
	
fi

#git clone https://github.com/neuronsimulator/nrn -b 8.2.6
git clone https://github.com/neuronsimulator/nrn
cd nrn

mkdir build 
cd build

# module files in olaf are in /opt/ibs_lib/modulefiles/
echo -e "\n##############"
echo -e "Loading module files"
echo -e "##############\n"

# Set environment variables

module purge   # purge any loaded modules

module load gcc/12.2.0 pgi/23.5 bison/3.8.2 flex/2.6.4 cmake/3.28.1 python/.3.12.3
module load /opt/ibs_lib/modulefiles/libraries/.cuda/25.1
module load /opt/ibs_lib/apps/nvhpc/25.1/modulefiles/nvhpc/25.1

# Set CUDA paths explicitly
#export NVHPC_CUDA_HOME=/opt/ibs_lib/apps/nvhpc/25.1/Linux_x86_64/25.1/cuda 
#export PATH=$NVHPC_CUDA_HOME/bin:$PATH
#export LD_LIBRARY_PATH=$NVHPC_CUDA_HOME/lib64:$LD_LIBRARY_PATH

# For headers (critical for cuda_profiler_api.h)
#export CPATH=$NVHPC_CUDA_HOME/include:$CPATH
#export CMAKE_INCLUDE_PATH=$NVHPC_CUDA_HOME/include:$CMAKE_INCLUDE_PATH

#export MPI_HOME=/opt/ibs_lib/apps/nvhpc/25.1/Linux_x86_64/25.1/comm_libs/mpi
#export MPI_C_COMPILER=$MPI_HOME/bin/mpicc
#export MPI_CXX_COMPILER=$MPI_HOME/bin/mpicxx


#export MPI_CXX_COMPILER=/opt/ibs_lib/apps/nvhpc/25.1/Linux_x86_64/25.1/comm_libs/mpi/bin/mpicxx
#export MPI_CXX_INCLUDE_PATH=/opt/ibs_lib/apps/nvhpc/25.1/Linux_x86_64/25.1/comm_libs/12.6/openmpi4/openmpi-4.1.5/include/
#export MPI_CXX_LIBRARIES=/opt/ibs_lib/apps/nvhpc/25.1/Linux_x86_64/25.1/comm_libs/12.6/openmpi4/openmpi-4.1.5/lib/libmpi.so


export CMAKE_INCLUDE_PATH=/opt/ibs_lib/apps/readline/8.2/include:$CMAKE_INCLUDE_PATH
export CMAKE_LIBRARY_PATH=/opt/ibs_lib/apps/readline/8.2/lib:$CMAKE_LIBRARY_PATH

export LD_LIBRARY_PATH=/opt/ibs_lib/apps/python/3.12.3/GCC/1220/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/ibs_lib/apps/gcc/12.2.0/lib64

export LD_LIBRARY_PATH=/opt/ibs_lib/apps/gcc/12.2.0/lib64:$LD_LIBRARY_PATH 
export CXXFLAGS="-I/opt/ibs_lib/apps/gcc/12.2.0/include -L/opt/ibs_lib/apps/gcc/12.2.0/lib64"

#export MPI_HOME=/opt/ibs_lib/apps/nvhpc/25.1/Linux_x86_64/25.1/comm_libs/mpi
#export MPI_C_COMPILER=$MPI_HOME/bin/mpicc
#export MPI_CXX_COMPILER=$MPI_HOME/bin/mpicxx
#export MPI_C_COMPILER=/opt/ibs_lib/apps/nvhpc/25.1/Linux_x86_64/25.1/comm_libs/mpi/bin/mpicc
#export MPI_CXX_COMPILER=/opt/ibs_lib/apps/nvhpc/25.1/Linux_x86_64/25.1/comm_libs/mpi/bin/mpicxx
#export MPI_INCLUDE_PATH=/opt/ibs_lib/apps/nvhpc/25.1/Linux_x86_64/25.1/comm_libs/12.6/openmpi4/openmpi-4.1.5/include
#export MPI_LIBRARY_PATH=/opt/ibs_lib/apps/nvhpc/25.1/Linux_x86_64/25.1/comm_libs/12.6/openmpi4/openmpi-4.1.5/lib

#export MPI_HOME=/opt/ibs_lib/apps/nvhpc/25.1/Linux_x86_64/25.1/comm_libs/12.6/openmpi4/openmpi-4.1.5
#export MPI_C_COMPILER=$MPI_HOME/bin/mpicc
#export MPI_CXX_COMPILER=$MPI_HOME/bin/mpicxx
#export MPI_INCLUDE_PATH=$MPI_HOME/include
#export MPI_LIBRARY_PATH=$MPI_HOME/lib
#export LD_LIBRARY_PATH=$MPI_LIBRARY_PATH:$LD_LIBRARY_PATH
#export PATH=$MPI_HOME/bin:$PATH
#export CMAKE_PREFIX_PATH=$MPI_HOME:$CMAKE_PREFIX_PATH


#echo $MPI_HOME
#echo $MPI_CXX_COMPILER



echo -e "\n##############"
echo -e "Cmake ..." 
echo -e "############## \n"

cmake .. -DCMAKE_INSTALL_PREFIX=$HOME/install \
 -DNRN_ENABLE_CORENEURON=ON \
 -DCORENRN_ENABLE_GPU=ON \
 -DCORENRN_ENABLE_NMODL=ON \
 -DNRN_ENABLE_INTERVIEWS=OFF \
 -DNRN_ENABLE_RX3D=OFF \
 -DCMAKE_C_COMPILER=nvc \
 -DCMAKE_CXX_COMPILER=nvc++ \
 -DCMAKE_CUDA_ARCHITECTURES=90 \
 -DCMAKE_C_FLAGS="-O3 -g" \
 -DCMAKE_CXX_FLAGS="-O3 -g"  \
 #-DCMAKE_CXX_FLAGS="-O3 -g -Wl,-rpath=/opt/ibs_lib/apps/gcc/12.2.0/lib64 -L/opt/ibs_lib/apps/gcc/12.2.0/lib64" \
 #-DCMAKE_EXE_LINKER_FLAGS="-Wl,-rpath=/opt/ibs_lib/apps/gcc/12.2.0/lib64 -L/opt/ibs_lib/apps/gcc/12.2.0/lib64" \
 -DCMAKE_BUILD_TYPE=Custom 

echo -e "\n##############"
echo -e "Making -j"
echo -e "##############"
make -j


echo -e "\n##############"
echo -e "Making install step" 
echo -e "##############"
#make install
