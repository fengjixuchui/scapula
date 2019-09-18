if(CMAKE_INSTALL_PREFIX)
    set(ENV{CMAKE_INSTALL_PREFIX} "${CMAKE_INSTALL_PREFIX}")
else()
    set(CMAKE_INSTALL_PREFIX "$ENV{CMAKE_INSTALL_PREFIX}")
endif()

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR aarch64)
set(TOOLCHAIN_TRIPLE aarch64-linux-gnu)

string(CONCAT LD_FLAGS
    "-L${CMAKE_INSTALL_PREFIX}/lib "
    "-z max-page-size=4096 "
    "-z relro "
    "-z now "
    "--no-dynamic-linker "
    "-nostdlib "
    "-pie "
    "-static"
)

find_program(CMAKE_C_COMPILER ${TOOLCHAIN_TRIPLE}-gcc)
if(NOT CMAKE_C_COMPILER)
    message(FATAL_ERROR "Unable to find ${TOOLCHAIN_TRIPLE}-gcc")
else()
    set(CMAKE_CXX_COMPILER ${CMAKE_C_COMPILER})
endif()

find_program(CMAKE_AS ${TOOLCHAIN_TRIPLE}-as)
if(NOT CMAKE_AS)
    message(FATAL_ERROR "Unable to find ${TOOLCHAIN_TRIPLE}-as")
endif()

find_program(LD_BIN ${TOOLCHAIN_TRIPLE}-ld)
if(NOT LD_BIN)
    message(FATAL_ERROR "Unable to find ${TOOLCHAIN_TRIPLE}-ld")
endif()

find_program(AR_BIN ${TOOLCHAIN_TRIPLE}-ar)
if(NOT AR_BIN)
    message(FATAL_ERROR "Unable to find ${TOOLCHAIN_TRIPLE}-ar")
endif()

find_program(OBJCOPY_BIN ${TOOLCHAIN_TRIPLE}-objcopy)
if(NOT OBJCOPY_BIN)
    message(FATAL_ERROR "Unable to find ${TOOLCHAIN_TRIPLE}-objcopy")
endif()

set(CMAKE_C_ARCHIVE_CREATE
    "${AR_BIN} qc <TARGET> <OBJECTS>"
)

set(CMAKE_CXX_ARCHIVE_CREATE
    "${AR_BIN} qc <TARGET> <OBJECTS>"
)

set(CMAKE_C_LINK_EXECUTABLE
    "${LD_BIN} ${LD_FLAGS} <OBJECTS> -o <TARGET> <LINK_LIBRARIES> "
)

set(CMAKE_CXX_LINK_EXECUTABLE
    "${LD_BIN} ${LD_FLAGS} <OBJECTS> -o <TARGET> <LINK_LIBRARIES>"
)

set(CMAKE_C_CREATE_SHARED_LIBRARY
    "${LD_BIN} ${LD_FLAGS} -shared <OBJECTS> -o <TARGET>"
)

set(CMAKE_CXX_CREATE_SHARED_LIBRARY
    "${LD_BIN} ${LD_FLAGS} -shared <OBJECTS> -o <TARGET>"
)

set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_CXX_COMPILER_WORKS 1)
