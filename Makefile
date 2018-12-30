# Assembler is NASM
ASM = nasm

# Format of object file is linux
LINUX_FORMAT = elf32

# Flags used in assemblying phase
ASMFLAGS =

# Where to install. Default is /usr/lib
INSTDIR = /usr/lib

# Linker is ld
LINKER = ld

# Share libbrary option for linker
SHLIB = -shared

all: libkobi.so

libkobi.so: kobi.o
	gcc -m32 kobi.o -shared -o libkobi.so 
	echo "Done"

kobi.o: kobi.asm 
	$(ASM) -f $(LINUX_FORMAT) $(ASMFLAGS) -o kobi.o kobi.asm

clean:
	-rm kobi.o libkobi.so

install: libkobi.so
	@if [ -d $(INSTDIR) ]; \
	    then \
	    cp libkobi.so $(INSTDIR);\
	    chmod a+x $(INSTDIR)/libkobi.so;\
	    echo "Installed in $(INSTDIR)";\
	 else \
	    echo "Sorry, $(INSTDIR) does not exist";\
	 fi

uninstall:
	@if [ -d $(INSTDIR) ]; \
	    then \
	    rm $(INSTDIR)/libkobi.so;\
	    echo "Uninstalling finished";\
	 else \
	    echo "Sorry, $(INSTDIR) does not exist";\
	 fi
