# protobux
hxcpp build system for libprotobuf

To create a 'protoc' executable for you platform, run:
```
cd build
haxelib run hxcpp protoc.xml
```


To link your project against the libprotobuf files, include the `build/libprotobuf.xml` in your project build.xml file, eg:
```
 <import name="${haxelib:protobux}/build/libprotobuf.xml" />
```


To generate the files for haxelib, run:
```
haxe --run MakeHaxelib.hx
```
