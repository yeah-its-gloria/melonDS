include(FindPackageHandleStandardArgs)

if(MSVC)
	option(archive_IS_STATIC "Whether the given build of libarchive should be treated as static. This is only relevant for MSVC builds." OFF)
endif()

find_path   (archive_INCLUDE_DIR NAMES archive.h)
find_library(archive_LIBRARY     NAMES archive)

find_package_handle_standard_args(archive DEFAULT_MSG archive_LIBRARY archive_INCLUDE_DIR)

if(archive_FOUND)
	set(archive_LIBRARIES    "${archive_LIBRARY}")
	set(archive_INCLUDE_DIRS "${archive_INCLUDE_DIR}")
endif()

mark_as_advanced(archive_INCLUDE_DIR archive_LIBRARY)
