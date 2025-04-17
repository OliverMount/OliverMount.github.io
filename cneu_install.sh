#homedir=/opt/ibs_lib/apps/neuron/8.2.6/GCC/1220/H100
cd ..

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
module purge   
module load gcc/12.2.0 pgi/23.5 bison/3.8.2 flex/2.6.4 cmake/3.28.1 python/.3.12.3

module load /opt/ibs_lib/modulefiles/libraries/.cuda/25.1
module load /opt/ibs_lib/apps/nvhpc/25.1/modulefiles/nvhpc/25.1


export MPI_CXX_COMPILER=/opt/ibs_lib/apps/nvhpc/25.1/Linux_x86_64/25.1/comm_libs/mpi/bin/mpicxx
export MPI_CXX_INCLUDE_PATH=/opt/ibs_lib/apps/nvhpc/25.1/Linux_x86_64/25.1/comm_libs/12.6/openmpi4/openmpi-4.1.5/include/
export MPI_CXX_LIBRARIES=/opt/ibs_lib/apps/nvhpc/25.1/Linux_x86_64/25.1/comm_libs/12.6/openmpi4/openmpi-4.1.5/lib/libmpi.so

export CMAKE_INCLUDE_PATH=/opt/ibs_lib/apps/readline/8.2/include:$CMAKE_INCLUDE_PATH
export CMAKE_LIBRARY_PATH=/opt/ibs_lib/apps/readline/8.2/lib:$CMAKE_LIBRARY_PATH

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
 -DCMAKE_BUILD_TYPE=Custom 

#echo -e "\n##############"
#echo -e "Making -j"
#echo -e "##############"
#make -j


echo -e "\n##############"
echo -e "Making install step" 
echo -e "##############"
#make install
