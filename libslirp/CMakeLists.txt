cmake_minimum_required(VERSION 3.0.0)
project(slirp VERSION 4.7.0 LANGUAGES C)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/build-aux)

include(CMakePackageConfigHelpers)

if(WIN32)
    add_compile_definitions(_CRT_SECURE_NO_WARNINGS _WINSOCK_DEPRECATED_NO_WARNINGS)
endif()

find_package(glib REQUIRED)

set(SLIRP_MAJOR_VERSION ${slirp_VERSION_MAJOR})
set(SLIRP_MINOR_VERSION ${slirp_VERSION_MINOR})
set(SLIRP_MICRO_VERSION ${slirp_VERSION_PATCH})

set(SLIRP_VERSION_STRING "\"${slirp_VERSION_MAJOR}.${slirp_VERSION_MINOR}.${slirp_VERSION_PATCH}\"")

configure_file(${CMAKE_CURRENT_LIST_DIR}/src/libslirp-version.h.in ${CMAKE_CURRENT_BINARY_DIR}/generate/libslirp-version.h)

add_library(slirp STATIC
    ${CMAKE_CURRENT_LIST_DIR}/src/arp_table.c
    ${CMAKE_CURRENT_LIST_DIR}/src/bootp.c
    ${CMAKE_CURRENT_LIST_DIR}/src/cksum.c
    ${CMAKE_CURRENT_LIST_DIR}/src/dhcpv6.c
    ${CMAKE_CURRENT_LIST_DIR}/src/dnssearch.c
    ${CMAKE_CURRENT_LIST_DIR}/src/if.c
    ${CMAKE_CURRENT_LIST_DIR}/src/ip6_icmp.c
    ${CMAKE_CURRENT_LIST_DIR}/src/ip6_input.c
    ${CMAKE_CURRENT_LIST_DIR}/src/ip6_output.c
    ${CMAKE_CURRENT_LIST_DIR}/src/ip_icmp.c
    ${CMAKE_CURRENT_LIST_DIR}/src/ip_input.c
    ${CMAKE_CURRENT_LIST_DIR}/src/ip_output.c
    ${CMAKE_CURRENT_LIST_DIR}/src/mbuf.c
    ${CMAKE_CURRENT_LIST_DIR}/src/misc.c
    ${CMAKE_CURRENT_LIST_DIR}/src/ncsi.c
    ${CMAKE_CURRENT_LIST_DIR}/src/ndp_table.c
    ${CMAKE_CURRENT_LIST_DIR}/src/sbuf.c
    ${CMAKE_CURRENT_LIST_DIR}/src/slirp.c
    ${CMAKE_CURRENT_LIST_DIR}/src/socket.c
    ${CMAKE_CURRENT_LIST_DIR}/src/state.c
    ${CMAKE_CURRENT_LIST_DIR}/src/stream.c
    ${CMAKE_CURRENT_LIST_DIR}/src/tcp_input.c
    ${CMAKE_CURRENT_LIST_DIR}/src/tcp_output.c
    ${CMAKE_CURRENT_LIST_DIR}/src/tcp_subr.c
    ${CMAKE_CURRENT_LIST_DIR}/src/tcp_timer.c
    ${CMAKE_CURRENT_LIST_DIR}/src/tftp.c
    ${CMAKE_CURRENT_LIST_DIR}/src/udp.c
    ${CMAKE_CURRENT_LIST_DIR}/src/udp6.c
    ${CMAKE_CURRENT_LIST_DIR}/src/util.c
    ${CMAKE_CURRENT_LIST_DIR}/src/version.c
    ${CMAKE_CURRENT_LIST_DIR}/src/vmstate.c
)

target_compile_definitions(slirp PRIVATE
    "G_LOG_DOMAIN=\"Slirp\""
    "BUILDING_LIBSLIRP"
)

target_compile_options(slirp PRIVATE -Wmissing-prototypes -Wstrict-prototypes -Wredundant-decls -Wwrite-strings)

target_include_directories(slirp PRIVATE
    ${CMAKE_CURRENT_BINARY_DIR}/generate

    ${glib_INCLUDE_DIRS}

    PUBLIC "$<INSTALL_INTERFACE:include>"
)

target_link_libraries(slirp PRIVATE ${glib_LIBRARIES})

if(WIN32)
    target_link_libraries(slirp PRIVATE ws2_32 iphlpapi)
elseif(APPLE)
    target_link_libraries(slirp PRIVATE resolv)
endif()

set_target_properties(slirp PROPERTIES PUBLIC_HEADER "${CMAKE_CURRENT_LIST_DIR}/src/libslirp.h;${CMAKE_CURRENT_BINARY_DIR}/generate/libslirp-version.h")

install(TARGETS slirp EXPORT slirpTargets
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
    PUBLIC_HEADER DESTINATION include/slirp
)

install(EXPORT slirpTargets FILE slirpTargets.cmake DESTINATION cmake)

configure_package_config_file(${CMAKE_CURRENT_SOURCE_DIR}/build-aux/slirpConfig.cmake.in
    "${CMAKE_CURRENT_BINARY_DIR}/slirpConfig.cmake"
    INSTALL_DESTINATION cmake
    NO_SET_AND_CHECK_MACRO
    NO_CHECK_REQUIRED_COMPONENTS_MACRO
)

write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/slirpConfigVersion.cmake"
    VERSION "${slirp_VERSION_MAJOR}.${slirp_VERSION_MINOR}.${slirp_VERSION_PATCH}"
    COMPATIBILITY AnyNewerVersion
)

install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/slirpConfig.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/slirpConfigVersion.cmake
    DESTINATION cmake
)
