import sys.FileSystem;

class MakeHaxelib
{
   static function mkdir(dirName:String)
   {
      FileSystem.createDirectory(dirName);
   }


   static function copyRecurse(src:String, dest:String)
   {
      if ( FileSystem.isDirectory(src) )
      {
         mkdir(dest);
         for(file in FileSystem.readDirectory(src))
         {
            if (file.substr(0,1)=="." || file=="modules" ||file=="bin"||file=="lib"||file=="protobux"||file=="obj"||
                file=="testing" || file=="testdata" )
               continue;

            copyRecurse(src+"/"+file, dest+"/"+file);
         }
      }
      else
      {
         sys.io.File.copy(src, dest);
      }
   }

   public static function main()
   {
      var dest = "protobux";
      copyRecurse(".",dest);
      copyRecurse("modules/protobuf/src/google/protobuf",dest+"/"+"modules/protobuf/src/google/protobuf");

   }
}

