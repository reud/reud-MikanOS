run-qemu:
	./mikanos-build/devenv/run_qemu.sh ./efi/${EFI}

run-qemu-edk2:
	source edk2/edksetup.sh && \
	cd edk2 && \
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