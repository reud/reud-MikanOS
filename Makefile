run-qemu:
	./mikanos-build/devenv/run_qemu.sh ./efi/${EFI}

run-qemu-edk2:
	cd edk2 && \
	source ./edksetup.sh && \
	build && \
	cd .. && \
	./mikanos-build/devenv/run_qemu.sh ./edk2/Build/MikanLoaderX64/DEBUG_CLANG38/X64/Loader.efi

day01-hello-create:
	cd mikanos-build/day01/c && \
	clang -target x86_64-pc-win32-coff \
		  -mno-red-zone \
		  -fno-stack-protector \
		  -fshort-wchar \
		  -Wall \
		  -o ./../../../out/hello.o \
		  -c hello.c && \
	lld-link /subsystem:efi_application /entry:EfiMain /out:./../../../efi/hello.efi ./../../../out/hello.o

day03-kernel-compile:
	clang++ -O2 -Wall -g --target=x86_64-elf -ffreestanding -mno-red-zone \
	-fno-exceptions -fno-rtti \
	-std=c++17 \
	-c chapters/3/kernelMain/main.cpp \
	-o chapters/3/kernelMain/main.o && \
	ld.lld --entry KernelMain -z norelro --image-base 0x100000 --static \
	-o kernel.elf ./chapters/3/kernelMain/main.o

day03-run-qemu:
	./mikanos-build/devenv/run_qemu.sh ./kernel.elf

setup:
	make -C /home/reud/Projects/reud-MikanOS/edk2/BaseTools/Source/C && \
	ln -s /home/reud/Projects/reud-MikanOS/mikanos/MikanLoaderPkg ./edk2/MikanLoaderPkg

day04a:
	export BASEDIR="./mikanos-build/devenv/x86_64-elf" && \
	export EDK2DIR="./edk2" && \
	export CPPFLAGS="\
	-I$BASEDIR/include/c++/v1 -I$BASEDIR/include -I$BASEDIR/include/freetype2 \
	-I$EDK2DIR/MdePkg/Include -I$EDK2DIR/MdePkg/Include/X64 \
	-nostdlibinc -D__ELF__ -D_LDBL_EQ_DBL -D_GNU_SOURCE -D_POSIX_TIMERS \
	-DEFIAPI='__attribute__((ms_abi))'" && \
	export LDFLAGS="-L$BASEDIR/lib" && \
	clang++ -I ./x86_64-elf/include/c++/v1 \
	-I ./x86_64-elf/include \
	-nostdlibinc -D__ELF__ -D_LDBL_EQ_DBL -D_GNU_SOURCE -D_POSIX_TIMERS \
	-O2 \
	--target=x86_64-elf \
	-fno-exceptions \
	-ffreestanding \
	-Wall \
	-g \
	-mno-red-zone \
	-fno-rtti \
	-std=c++17 \
	-c ./mikanos/kernel/main.cpp && \
	ld.lld -L ./x86_64-elf/lib \
	--entry KernelMain \
	-z norelro \
	--image-base 0x100000 \
	--static \
	-o kernel.elf main.o && \
	cd edk2 && \
	source ./edksetup.sh && \
	build && \
	/home/reud/Projects/reud-MikanOS/mikanos-build/devenv/run_qemu.sh Build/MikanLoaderX64/DEBUG_CLANG38/X64/Loader.efi /home/reud/Projects/reud-MikanOS/kernel.elf