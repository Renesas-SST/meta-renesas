# Environment setup, support building kernel modules with kernel src in SDK
export KERNELSRC="$SDKTARGETSYSROOT/usr/src/kernel"
export KERNELDIR="$SDKTARGETSYSROOT/usr/src/kernel"
export HOST_EXTRACFLAGS="-I${OECORE_NATIVE_SYSROOT}/usr/include/ -L${OECORE_NATIVE_SYSROOT}/usr/lib"

# Environment setup, support missing path in qt6.sh when using SDK
export PATH=$OECORE_NATIVE_SYSROOT/usr/bin/qt6:$PATH
export QT_CONF_PATH=$OECORE_NATIVE_SYSROOT/usr/bin/qt6/qt.conf
export OE_QMAKE_LIBDIR_QT=`qmake -query QT_INSTALL_LIBS`
export OE_QMAKE_INCDIR_QT=`qmake -query QT_INSTALL_HEADERS`
export OE_QMAKE_PATH_HOST_BINS=$OECORE_NATIVE_SYSROOT/usr/bin/qt6
export QMAKESPEC=`qmake -query QT_INSTALL_LIBS`/mkspecs/linux-oe-g++
