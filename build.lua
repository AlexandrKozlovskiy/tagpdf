-- Build script for tagpdf
packageversion="0.62"
packagedate="2019-10-16"

module   = "tagpdf"
ctanpkg  = "tagpdf"

local ok, mydata = pcall(require, "ulrikefischerdata.lua")
if not ok then
  mydata= {email="XXX",github="XXX",name="XXX"}
end

uploadconfig = {
  pkg     = ctanpkg,
  version = "v"..packageversion.." "..packagedate,
  author  = mydata.name,
  license = "lppl1.3c",
  summary = "Tools for experimenting with tagging using pdfLaTeX and LuaLaTeX",
  ctanPath = "/macros/latex/contrib/tagpdf",
  repository = mydata.github .. "tagpdf",
  bugtracker = mydata.github .. "tagpdf/issues",
  support    = mydata.github .. "tagpdf/issues",
  uploader = mydata.name,
  email    = mydata.email,
  update   = true ,
  topic=    "tagged-pdf",
  note     = [[This version should be installed together with the just uploaded l3kernel/l3experimental! Uploaded automatically by l3build...]],
  description=[[The package offers tools to experiment with tagging and accessibility using pdfLATEX and LuaTEX. It isn't meant for production but allows the user to try out how difficult it is to tag some structures; to try out how much tagging is really needed; to test what else is needed so that a pdf works e.g. with a screen reader. Its goal is to get a feeling for what has to be done, which kernel changes are needed, how packages should be adapted.]],
  announcement_file="ctan.ann"              
}

checkengines = {"pdftex", "luatex"}
checkconfigs = {"build","config-pdftex","config-luatex"}
checkruns = 3
checksuppfiles = {"texmf.cnf"}

if os.getenv('TRAVIS')  then 
   excludetests = {"test-pdfresources-exist"}
end 

sourcefiledir = "./source"

tagfiles = {"source/*.md",
            "source/**/tag*.sty",
            "source/**/tag*.def",
            "source/**/*.lua",
            "source/*.tex",
            "Readme.md"}

function update_tag (file,content,tagname,tagdate)
 tagdate = string.gsub (packagedate,"-", "/")
 if string.match (file, "%.sty$" ) then
  content = string.gsub (content,  
                         "\\ProvidesExplPackage {(.-)} {.-} {.-}",
                         "\\ProvidesExplPackage {%1} {" .. tagdate.."} {"..packageversion .. "}")
  return content                         
 elseif string.match (file, "%.def$") then
  content = string.gsub (content,  
                         "\\ProvidesExplFile {(.-)} {.-} {.-}",
                         "\\ProvidesExplFile {%1} {" .. tagdate.."} {"..packageversion .. "}")                         
  return content 
 elseif string.match (file, "^Readme.md$") then
   content = string.gsub (content,  
                         "Version: %d%.%d+",
                         "Version: " .. packageversion )
   content = string.gsub (content,  
                         "version%-%d%.%d+",
                         "version-" .. packageversion ) 
   content = string.gsub (content,  
                         "for %d%.%d+",
                         "for " .. packageversion ) 
   content = string.gsub (content,  
                         "%d%d%d%d%-%d%d%-%d%d",
                         packagedate )
   local imgpackagedate = string.gsub (packagedate,"%-","--")                          
   content = string.gsub (content,  
                         "%d%d%d%d%-%-%d%d%-%-%d%d",
                         imgpackagedate)                                                                                                     
   return content                            
 elseif string.match (file, "%.md$") then
   content = string.gsub (content,  
                         "Packageversion: %d%.%d+",
                         "Packageversion: " .. packageversion )
   content = string.gsub (content,  
                         "Packagedate: %d%d%d%d/%d%d/%d%d",
                         "Packagedate: " .. tagdate )                      
   return content
 elseif string.match (file, "%.lua$" ) then
  content = string.gsub (content,  
                         '(version%s*=%s*")%d%.%d+(",%s*--TAGVERSION)',
                         "%1"..packageversion.."%2")
  content = string.gsub (content,  
                         '(date%s*=%s*")%d%d%d%d%-%d%d%-%d%d(",%s*--TAGDATE)',
                         "%1"..packagedate.."%2")                                                  
  return content                         
 elseif string.match (file, "%.tex$" ) then
   content = string.gsub (content,  
                         "package@version{%d%.%d+}",
                         "package@version{" .. packageversion .."}" )
   content = string.gsub (content,  
                         "package@date{%d%d%d%d%-%d%d%-%d%d}",
                         "package@date{" .. packagedate .."}" )                      
   return content   
 end
 return content
 end

-- ctan setup
docfiles = {"source/tagpdf.tex","source/tagpdf.bib","source/link-figure-input.tex","source/pac3.PNG","source/examples/**/*.tex", "source/examples/**/*.pdf"}
textfiles= {"source/CTANREADME.md"}
excludefiles ={"*/pdfresources.sty","*/hluatex-experimental.def"}
ctanreadme= "CTANREADME.md"

typesetexe = "lualatex"
packtdszip   = false
installfiles = {
                "**/*.sty",
                "**/*.def",
                "**/*.lua"
               }  
               
sourcefiles  = {
                "**/*.sty",
                "**/*.def",
                "**/*.lua"
               }
                            
typesetfiles = {"tagpdf.tex"}

typesetruns = 4



-- kpse.set_program_name ("kpsewhich")
-- if not release_date then
-- dofile ( kpse.lookup ("l3build.lua"))
-- end
