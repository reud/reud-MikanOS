run-qemu:
	./mikanos-build/devenv/run_qemu.sh ./efi/${EFI}

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