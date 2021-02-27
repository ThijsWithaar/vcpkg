vcpkg_buildpath_length_warning(37)

vcpkg_from_github(
	OUT_SOURCE_PATH SOURCE_PATH
	#REPO giaf/blasfeo
	#REF 0.1.2
	#SHA512 3430a1c03c55e68abea158f2f7bd234b1c8c30e99dfef57adae334494b99bbf76649d3cff45fa8f20ab475b8918f7b9d03e3b62edc6665c71785e9fd192aad04
	REPO ThijsWithaar/blasfeo
	REF msvc-nasm
	SHA512 31c8b96ea019906e4ea0036c995c2a1d079852ae421ec46cb1630deb256eae826cb4ad7d4b0d40073e3ac9fc3148b452f39757fa882eeccfee67789e981e4d7e
	HEAD_REF master
)

if(WIN32)
	vcpkg_acquire_msys(MSYS_ROOT
		PACKAGES binutils make
		DIRECT_PACKAGES
			"https://repo.msys2.org/msys/x86_64/gcc-9.3.0-1-x86_64.pkg.tar.xz"
			76af0192a092278e6b26814b2d92815a2c519902a3fec056b057faec19623b1770ac928a59a39402db23cfc23b0d7601b7f88b367b27269361748c69d08654b2
			"https://repo.msys2.org/msys/x86_64/zlib-1.2.11-1-x86_64.pkg.tar.xz"
			b607da40d3388b440f2a09e154f21966cd55ad77e02d47805f78a9dee5de40226225bf0b8335fdfd4b83f25ead3098e9cb974d4f202f28827f8468e30e3b790d
			"https://repo.msys2.org/msys/x86_64/mpc-1.1.0-1-x86_64.pkg.tar.xz"
			7d0715c41c27fdbf91e6dcc73d6b8c02ee62c252e027f0a17fa4bfb974be8a74d8e3a327ef31c2460721902299ef69a7ef3c7fce52c8f02ce1cb47f0b6e073e9
			"https://repo.msys2.org/msys/x86_64/mpfr-4.1.0-1-x86_64.pkg.tar.zst"
			d64fa60e188124591d41fc097d7eb51d7ea4940bac05cdcf5eafde951ed1eaa174468f5ede03e61106e1633e3428964b34c96de76321ed8853b398fbe8c4d072
			"https://repo.msys2.org/msys/x86_64/gmp-6.2.0-1-x86_64.pkg.tar.xz"
			1389a443e775bb255d905665dd577bef7ed71d51a8c24d118097f8119c08c4dfe67505e88ddd1e9a3764dd1d50ed8b84fa34abefa797d257e90586f0cbf54de8
			"https://repo.msys2.org/msys/x86_64/isl-0.22.1-1-x86_64.pkg.tar.xz"
			f4db50d00bad0fa0abc6b9ad965b0262d936d437a9faa35308fa79a7ee500a474178120e487b2db2259caf51524320f619e18d92acf4f0b970b5cbe5cc0f63a2
	)
	# Needed so the build can call gcc and it's shared libraries:
	set(ENV{PATH} "$ENV{PATH};${MSYS_ROOT}/usr/bin")

	# Yasm does support GAS syntax, but not the pre-processor that blasfeo relies upon.
	#vcpkg_find_acquire_program(YASM)
	#message("BLASFEO YASM: ${YASM}")

	set(BLASFEO_TARGET X64_AUTOMATIC)
else()
	set(BLASFEO_TARGET GENERIC)
endif()

vcpkg_configure_cmake(
	SOURCE_PATH ${SOURCE_PATH}
	PREFER_NINJA
	OPTIONS
		-DBLASFEO_HP_API=ON
		-DBLASFEO_BENCHMARKS=OFF
		-DBLASFEO_EXAMPLES=OFF
		-DBLASFEO_TESTING=OFF
		-DTARGET=${BLASFEO_TARGET}
		-DGAS=${MSYS_ROOT}/usr/bin/gcc
	OPTIONS_RELEASE
		-DCMAKEPACKAGE_INSTALL_DIR=${CURRENT_PACKAGES_DIR}/share/blasfeo
		-DPKGCONFIG_INSTALL_DIR=${CURRENT_PACKAGES_DIR}/lib/pkgconfig
	OPTIONS_DEBUG
		-DCMAKEPACKAGE_INSTALL_DIR=${CURRENT_PACKAGES_DIR}/debug/share/blasfeo
		-DPKGCONFIG_INSTALL_DIR=${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets(CONFIG_PATH cmake)
#vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

file(INSTALL ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
