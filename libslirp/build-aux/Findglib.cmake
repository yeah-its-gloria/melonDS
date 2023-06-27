include(FindPackageHandleStandardArgs)

find_path   (glib_INCLUDE_DIR NAMES glib.h)
find_library(glib_LIBRARY     NAMES glib glib-2.0)

find_package_handle_standard_args(glib DEFAULT_MSG glib_LIBRARY glib_INCLUDE_DIR)

if(glib_FOUND)
	set(glib_LIBRARIES    "${glib_LIBRARY}")
	set(glib_INCLUDE_DIRS "${glib_INCLUDE_DIR}")
endif()

mark_as_advanced(glib_BINARY glib_INCLUDE_DIR glib_LIBRARY)
