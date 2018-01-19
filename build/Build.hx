import sys.FileSystem;

class Build
{
   static var haxelibExtra:Array<String> = [ ];
   static var builds = ["libprotobuf", "protoc" ];
   static var toolExt = Sys.systemName()=="Windows" ? ".exe" : "";
   static var debugExt = "";
   static var debugFlag = [];
   static var commandError = false;

   public static function command(exe:String, args:Array<String>)
   {
      if (exe=="haxelib")
         args = args.concat(haxelibExtra);

      Sys.println(exe +" " + args.join(' '));
      if (Sys.command(exe,args)!=0)
         commandError = true;
   }

   public static function libprotobufBuild()
   {
      command("haxelib", ["run","hxcpp","libprotobuf.xml","-Dstatic_link" ] );
   }

   public static function protocBuild()
   {
      sys.FileSystem.createDirectory("../bin");
      command("haxelib", ["run","hxcpp","protoc.xml" ] );
   }

  /*
  proto_text is a tool that converts protobufs into a form we can use more
  compactly within TensorFlow. It's a bit like protoc, but is designed to
  produce a much more minimal result so we can save binary space.
  We have to build it on the host system first so that we can create files
  that are needed for the runtime building.
  */


   static function deleteDirRecurse(dir:String)
   {
      for(file in FileSystem.readDirectory(dir))
      {
         var path = dir + "/" + file;
         if (FileSystem.isDirectory(path))
            deleteDirRecurse(path);
         else
            FileSystem.deleteFile(path);
      }
      FileSystem.deleteDirectory(dir);
   }


   public static function cleanBuild()
   {
      for(dir in ["obj", "../lib", "../bin" ])
      {
         try {
            deleteDirRecurse(dir);
         } catch(d:Dynamic) { }
      }
   }

   public static function main()
   {
      //haxelibExtra.push("-DHXCPP_M64");

      var option:String = null;
      var args = Sys.args();
      var a = 0;
      while(a<args.length)
      {
         var arg = args[a];
         if (arg.substr(0,1)=='-')
         {
            if (arg=="-debug")
            {
               debugFlag = ["-debug"];
               debugExt = "-debug";
            }
            else if (arg=="-dirty")
            {
               haxelibExtra.push(arg);
               a++;
               haxelibExtra.push(args[a]);
            }
            else
               haxelibExtra.push(arg);
         }
         else if (option==null)
            option = arg;
         else
         {
            option = null;
            break;
         }
         a++;
      }

      if (option=="all")
      {
         for(build in builds)
         {
            Sys.println('$build...');
            Reflect.field(Build, build + "Build")();
            if (commandError)
            {
               Sys.println('There were errors building $build');
               Sys.exit(-1);
            }
         }
      }
      else if (option=="clean")
      {
         cleanBuild();
      }
      else
      {
         if (builds.indexOf(option)<0)
         {
            Sys.println("Usage: haxe --run Build.hx target [-arg1 -arg2 ...]");
            Sys.println(' target = one of :$builds or "all" or "clean"');
            Sys.exit(-1);
         }

         Reflect.field(Build, option + "Build")();
      }
   }
}
