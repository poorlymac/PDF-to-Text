#!/bin/bash
POPPLER=0.74.0
rm -rf poppler-$POPPLER*
curl -O https://poppler.freedesktop.org/poppler-$POPPLER.tar.xz
tar -xf poppler-$POPPLER.tar.xz
# Patch the CMakeLists.txt to do as mutch of a static compile as possible
patch poppler-$POPPLER/CMakeLists.txt<<'EOF'
--- poppler-$POPPLER/CMakeLists.txt	2018-12-07 03:22:06.000000000 +1100
+++ poppler-$POPPLER_build/CMakeLists.txt	2019-01-06 13:51:15.000000000 +1100
@@ -396,7 +396,8 @@
   poppler/Movie.cc
   poppler/Rendition.cc
 )
-set(poppler_LIBS ${FREETYPE_LIBRARIES})
+#set(poppler_LIBS ${FREETYPE_LIBRARIES})
+set(poppler_LIBS /usr/local/lib/libfreetype.a bz2 expat /usr/local/lib/libpng.a)
 if(ENABLE_SPLASH)
   set(poppler_SRCS ${poppler_SRCS}
     poppler/SplashOutputDev.cc
@@ -419,14 +420,16 @@
   )
 endif()
 if(FONTCONFIG_FOUND)
-  set(poppler_LIBS ${poppler_LIBS} ${FONTCONFIG_LIBRARIES})
+  #set(poppler_LIBS ${poppler_LIBS} ${FONTCONFIG_LIBRARIES})
+  set(poppler_LIBS ${poppler_LIBS} /usr/local/lib/libfontconfig.a)
 endif()
 
 if(JPEG_FOUND)
   set(poppler_SRCS ${poppler_SRCS}
     poppler/DCTStream.cc
   )
-  set(poppler_LIBS ${poppler_LIBS} ${JPEG_LIBRARIES})
+  #set(poppler_LIBS ${poppler_LIBS} ${JPEG_LIBRARIES})
+  set(poppler_LIBS ${poppler_LIBS} /usr/local/lib/libjpeg.a)
 endif()
 if(ENABLE_ZLIB)
   set(poppler_SRCS ${poppler_SRCS}
@@ -456,7 +459,7 @@
   set(poppler_SRCS ${poppler_SRCS}
     poppler/JPEG2000Stream.cc
   )
-  set(poppler_LIBS ${poppler_LIBS} openjp2)
+  set(poppler_LIBS ${poppler_LIBS} /usr/local/lib/libopenjp2.a)
 else ()
   set(poppler_SRCS ${poppler_SRCS}
     poppler/JPXStream.cc
@@ -472,10 +475,12 @@
   set(poppler_LIBS ${poppler_LIBS} gdi32)
 endif()
 if(PNG_FOUND)
-  set(poppler_LIBS ${poppler_LIBS} ${PNG_LIBRARIES})
+  #set(poppler_LIBS ${poppler_LIBS} ${PNG_LIBRARIES})
+  set(poppler_LIBS ${poppler_LIBS} /usr/local/lib/libpng.a)
 endif()
 if(TIFF_FOUND)
-  set(poppler_LIBS ${poppler_LIBS} ${TIFF_LIBRARIES})
+  #set(poppler_LIBS ${poppler_LIBS} ${TIFF_LIBRARIES})
+  set(poppler_LIBS ${poppler_LIBS} /usr/local/lib/libtiff.a)
 endif()
 
 if(MSVC)
EOF
cd poppler-$POPPLER

# Prepare Build, most of this from hombrew/Formulas/poppler.rb
mkdir build
cd build
/usr/local/bin/cmake .. \
	-DBUILD_GTK_TESTS=OFF \
	-DENABLE_CMS=none \
	-DENABLE_GLIB=OFF \
	-DENABLE_QT5=OFF \
	-DENABLE_XPDF_HEADERS=ON \
	-DWITH_GObjectIntrospection=ON \
	-DBUILD_SHARED_LIBS=OFF # Make libpoppler a static library

	# -DENABLE_LIBOPENJPEG=none \
# Make pdftotext
make pdftotext

# Check what libraries are dynamically linked, want no /usr/local's
otool -L utils/pdftotext
echo "Check there are no /usr/local libraries linked"

# Clean up
mv utils/pdftotext ../..
cd ../..
rm -rf poppler-$POPPLER*

# Open Platypus
open -a "Platypus.app" "PDF to Text.platypus"
