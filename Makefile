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