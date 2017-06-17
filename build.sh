#!/bin/bash

### Installation Docs
InstallationallDocuments=('A' 'Android-terminal' 'Android-Studio' 'Android-Eclipse'
'Android-VisualStudio' 'iOS' 'OSX' 'Linux' 'Windows' 'Windows-Phone' 'Tizen')
InstallationchaptersWithFolders=('Android-terminal' 'Android-Studio' 'Android-Eclipse'
'Android-VisualStudio' 'iOS' 'Linux' 'Windows' 'Windows-Phone' 'Tizen')
InstallationchaptersWithOutFolders=('A' 'OSX')

### Programmers Guide
PGallDocuments=('blank' 'index' 'about' 'basic_concepts' 'sprites' 'actions' 'scenes'
'ui_components' 'other_node_types' 'event_dispatch' '3d' 'scripting' 'physics'
'audio' 'advanced_topics' 'vr')
PGallChapters=('about' 'basic_concepts' 'sprites' 'actions' 'scenes' 'ui_components'
'other_node_types' 'event_dispatch' '3d' 'scripting' 'physics' 'audio' 'advanced_topics' 'vr')
PGchaptersWithFolders=('basic_concepts' 'sprites' 'actions' 'scenes' 'ui_components'
'other_node_types' '3d' 'physics' 'advanced_topics' 'vr')
PGchaptersWithOutFolders=('about' 'event_dispatch' 'scripting' 'audio')

### Services
ServicesallDocuments=('sdkbox')
ServiceschaptersWithFolders=('sdkbox')

### Editors and Tools
EditorsAndToolsallDocuments=('studio' 'cocosCLTool' 'cocos')
EditorsAndToolschaptersWithFolders=('studio' 'cocos')

### Shared
misc=('blank' 'index')

### Turn on globbing (BASH 4 required)
#foundDirs=()
#shopt -s globstar

SED="/usr/bin/sed"

cleanUp() {
  echo "cleaning up cruft..."
  rm -rf print/
  rm -rf _layout.html5
  rm -rf static-pages/*.html static-pages/*.bak static-pages/*.orig
}

exitScript() {
  echo "exiting...."
  exit 0
}

exitScriptAfterStaging() {
  echo "staging version of the guide at: cocos2d.github.io"
  exitScript
}

exitScriptIncorrectParameters() {
  echo "incorrect parameter provided... use --help if you need to"
  exitScript
}

exitScriptNotEnoughParameters() {
  echo "you need to provide a parameter to run this script... use --help if you need to"
  exitScript
}

deployToGitHub() { ## deploy docs to GitHub Pages
  echo "deploying to GitHub Pages..."
  rsync -ah site/ ../cocos2d.github.io
  cd ../cocos2d.github.io
  git add .
  git commit -m 'published automatically from cocos-docs build script'
  git push
  cd ../cocos-docs
}

deployToProduction() { ## deploy docs to Production
  echo "deploying to Production, via rsync..."
  rsync -avh site/* docops@cocos2dx:documentation/.

  echo 'deployment is done, if no errors were shown above this line...'
}

hello() {
  echo "Building the Cocos Documentation..."
  echo ""
  echo "You can pass in --help for help on how to use this script."
  echo ""
  echo "output is in site/... and this is what is deployed."
  echo ""
}

help() {
  ## State what we need for this script to run
  echo "this script reqires: "
  echo ""
  echo "mkdocs: http://www.mkdocs.org/"
  echo "Pandoc: http://johnmacfarlane.net/pandoc/getting-started.html"
  echo "a LaTex Distribution: http://www.tug.org/mactex/downloading.html"
  echo "run: sudo /usr/local/texlive/2014basic/bin/universal-darwin/tlmgr update --self"
  echo "run: sudo /usr/local/texlive/2014basic/bin/universal-darwin/tlmgr install collection-fontsrecommended"
  echo "run: sudo /usr/local/texlive/2014basic/bin/universal-darwin/tlmgr install ec ecc"
  echo "export TEXROOT=/usr/local/texlive/2014basic/bin/universal-darwin/"
  echo "export PATH=\$TEXROOT:\$PATH"
  echo ""
  echo "available options: "
  echo ""
  echo "--help - get help with running this script"
  echo "--all - build absolutely everything and deploy staging versions. This does not deploy to production"
  echo "--staging - deploys site/ to staging via rsync. This does NOT build anything. This does not deploy to production"
  echo "--production - deploys site/ to production via rsync. This does NOT build anything."

  echo ""
}

prep() { ## these things happen for any docs that are built.
  echo "prepping environment..."
  rm -R docs/*
  rm -R site/*
  mkdir -p docs
}

prepPost() { ## these things happen after mkdocs build so we have everything in site/ that
## we need for deployment
  echo "copying resources to site/..."
  #for i in ${CocosAll[@]}; do
  #  rsync -a theme/img site/cocos/${i}/
  #done
  for i in ${InstallationallDocuments[@]}; do
    rsync -a theme/img site/installation/${i}/
  done
  for i in ${ServicesallDocuments[@]}; do
    rsync -a theme/img site/services/${i}/
  done
  for i in ${PGallChapters[@]}; do
    rsync -a theme/img site/programmers-guide/${i}/
  done
}

buildAll() { ## build absolutely everything.
  echo "building absolutely everything..."
  prep
  prepAPIRefDocs
  #prepCocosDocs
  prepEditorsAndToolsDocs
  prepDeprecatedDocs
  prepInstallationDocs
  prepServicesDocs
  prepTutorialsDocs
  prepWorkflowDocs
  prepProgrammersGuide
  buildMarkdown
  prepPost
  buildProgrammersGuidePrint
  prepStaticHTMLPages
  buildStaticHTMLPages
  buildAPIRef
  fetchLegacyAPIRef
  deployLegacyDocs
  deployToGitHub
  cleanUp
}

buildSlim() { ## build a slimed version
  echo "building everything, except print media and api-refs..."
  prep
  prepAPIRefDocs
  #prepCocosDocs
  prepEditorsAndToolsDocs
  prepDeprecatedDocs
  prepInstallationDocs
  prepServicesDocs
  prepTutorialsDocs
  prepWorkflowDocs
  prepProgrammersGuide
  buildMarkdown
  prepPost
  #buildProgrammersGuidePrint
  prepStaticHTMLPages
  buildStaticHTMLPages
  #buildAPIRef
  #deployLegacyDocs
  deployToGitHub
  cleanUp
}

prepAPIRefDocs() { ## prep API-Ref
  echo "prepping API-Ref docs..."
  mkdir -p docs/api-ref
  cp api-ref/index.md docs/api-ref/index.md
}

prepEditorsAndToolsDocs() { ## prep Editors And Tools Docs
  echo "prepping Editors And Tools docs..."
  rsync -ah editors_and_tools docs/
}

prepDeprecatedDocs() { ## prep Deprecated Docs
  echo "prepping Deprecated docs..."
  rsync -ah deprecated docs/
}

prepInstallationDocs() { ## prep Installation Docs
  echo "prepping Installation docs..."
  for i in ${InstallationchaptersWithFolders[@]}; do
    rsync -a installation/${i}-web docs/installation/
    mv docs/installation/${i}-web docs/installation/${i}-img
    cp installation/${i}.md docs/installation/${i}.md
  done

  for i in ${InstallationchaptersWithOutFolders[@]}; do
    cp installation/${i}.md docs/installation/${i}.md
  done
}

prepServicesDocs() { ## prep Services Docs
  echo "prepping Services docs..."
  for i in ${ServiceschaptersWithFolders[@]}; do
    rsync -a services/${i}-web docs/services/
    mv docs/services/${i}-web docs/services/${i}-img
    cp services/${i}.md docs/services/${i}.md
  done
}

prepTutorialsDocs() { ## prep Tutorials Docs
  echo "prepping Tutorials docs..."
  rsync -ah tutorials docs/
}

prepWorkflowDocs() { ## prep Workflow Docs
  echo "prepping Workflow docs..."
  rsync -ah workflows docs/
}

prepProgrammersGuide() { ## prep Programmers Guide
  echo "prepping Programmers Guide..."
  for i in ${PGchaptersWithFolders[@]}; do
    rsync -a programmers-guide/${i}-web docs/programmers-guide/
    mv docs/programmers-guide/${i}-web docs/programmers-guide/${i}-img
    cp programmers-guide/${i}.md docs/programmers-guide/${i}.md
  done

  for i in ${PGchaptersWithOutFolders[@]}; do
    cp programmers-guide/${i}.md docs/programmers-guide/${i}.md
  done

  for i in ${misc[@]}; do
    cp ${i}.md docs/${i}.md
  done
}

prepStaticHTMLPages() {
  echo "prepping the static pages we need outside of the MKDocs build process..."

  cd static-pages/

  ## Copy the build index.html page so that we can add the sections.
  ## We can't do this as part of MkDocs as it would require these pages
  ## be listed in the TOC. Also, Pandoc would also need it's resouces since it
  ## finds links to them in the markdown when building
  cp ../site/index.html .
  ${SED} -i .bak -E -f index.sed index.html
  cp index.html ../site/.

  ## Copy the 404 as our template for each new page
  ## replace the 404 content with our key
  cp ../site/404.html .
  mv 404.html template.orig

  ${SED} -i .bak -e 's#href=\"index.html\"#href=\"../index.html\"#g' template.orig
  ${SED} -i .bak -e 's/.\/css\//..\/css\//g' template.orig
  ${SED} -i .bak -e 's/.\/js\//..\/js\//g' template.orig
  ${SED} -i .bak -e 's/.\/mkdocs..\/js\//..\/mkdocs\/js\//g' template.orig
  ${SED} -i .bak -e 's/cocos\/cocos\//..\/cocos\/cocos\//g' template.orig
  ${SED} -i .bak -e 's/programmers-guide\//..\/programmers-guide\//g' template.orig
  ${SED} -i .bak -e 's/installation\//..\/installation\//g' template.orig
  ${SED} -i .bak -e 's/services\//..\/services\//g' template.orig
  ${SED} -i .bak -e 's/api-ref\//..\/api-ref\//g' template.orig
  ${SED} -i .bak -e 's/editors_and_tools\//..\/editors_and_tools\//g' template.orig
  ${SED} -i .bak -E -f template.sed template.orig

  cd ..
}

buildStaticHTMLPages() {
  echo "building the static pages we need outside of the MKDocs build process..."
  echo "output is in site/static-pages/..."

  cd static-pages/

  ## copy template to each page we need
  ## replace the key in each page with it's content
  cp template.orig installation.html
  cp template.orig theBasics.html
  cp template.orig toolchain.html
  cp template.orig api-ref.html
  cp template.orig programmers-guide.html
  ${SED} -i .bak -f installation.sed installation.html
  ${SED} -i .bak -f theBasics.sed theBasics.html
  ${SED} -i .bak -f toolchain.sed toolchain.html
  ${SED} -i .bak -f api-ref.sed api-ref.html
  ${SED} -i .bak -f programmers-guide.sed programmers-guide.html

  ## sync html pages and images with site/ so they get published
  rsync -a *.html ../site/static-pages/
  rsync -a *.png ../site/static-pages/

  cd ..
}

buildMarkdown() {
  ## Now we can use MKDocs to build the static content
  echo "building all of the markdown files we use..."
  echo "MKDocs Build..."
  mkdocs build --clean
}

buildProgrammersGuidePrint() {
  ## create HTML docs from the markdown files in the above array
  #echo "prepping Programmers Guide print versions..."
  echo "building Programmers Guide print versions..."
  mkdir -p print

  ## We need these items to build the print versions
  for i in ${PGchaptersWithFolders[@]}; do
    rsync -a programmers-guide/${i}-print print/
    mv print/${i}-print print/${i}-img
    cp programmers-guide/${i}.md print/${i}.md
  done

  for i in ${PGchaptersWithOutFolders[@]}; do
    cp programmers-guide/${i}.md print/${i}.md
  done

  for i in ${misc[@]}; do
    cp ${i}.md print/${i}.md
  done

  cp styling/solarized-light.css styling/main.css styling/style.css styling/_layout.html5 print/.
  cp programmers-guide/title.md print/index.md


  cd print/

  for i in "${PGallDocuments[@]}"; do
    pandoc -s --template "_layout" --css "solarized-light.css" -f markdown -t html5 -o ${i}.html ${i}.md
  done

  ## create a PDF from the styled HTML
  echo "building Programmers Guide ePub..."

  pandoc -S --epub-stylesheet="style.css" -o "ProgrammersGuide.epub" \
  index.html \
  blank.html \
  about.html \
  blank.html \
  basic_concepts.html \
  blank.html \
  sprites.html \
  blank.html \
  actions.html \
  blank.html \
  scenes.html \
  blank.html \
  ui_components.html \
  blank.html \
  other_node_types.html \
  blank.html \
  event_dispatch.html \
  blank.html \
  3d.html \
  blank.html \
  scripting.html \
  blank.html \
  physics.html \
  blank.html \
  audio.html \
  blank.html \
  vr.html \
  blank.html \
  advanced_topics.html \
  blank.html

  echo "building Programmers Guide PDF..."
  pandoc -s ProgrammersGuide.epub --variable mainfont=Arial --variable monofont="Andale Mono" -o ProgrammersGuide.pdf --latex-engine=xelatex
  echo ""

  cd ..

  echo "copying Programmers Guide ePub and PDF to site/..."
  cp print/ProgrammersGuide.pdf print/ProgrammersGuide.epub site/.
}

buildAPIRef() { ## builds the API Reference from the Cocos2d-x/v3-docs repo
  echo "building the API References..."

  mkdir -p site/api-ref/cplusplus/v3x
  mkdir -p site/api-ref/js

  echo "building the C++ API Reference..."
  cd ../cocos2d-x
  git checkout v3
  git pull origin v3
  cd docs
  doxygen doxygen.config
  rsync -ah html/ ../../cocos-docs/site/api-ref/cplusplus/v3x

  echo "building the JavaScript API Reference..."
  cd ../web/tools/jsdoc_toolkit/
  ant
  mkdir ../../../../cocos-docs/site/api-ref/js/v3x
  rsync -ah out/jsdoc/ ../../../../cocos-docs/site/api-ref/js/v3x

  cd ../../../../cocos-docs

  ## replace the api-ref index.html that MKDocs built with the one we build from SED
  rm -rf site/api-ref/index.html
  cp site/static-pages/api-ref.html site/api-ref/.
  mv site/api-ref/api-ref.html site/api-ref/index.html
}

deployLegacyDocs() {
  ## This deploys the legacy docs that are also needed until they are moved under
  ## this new unified structure

  echo "copying legacy docs that still need a home for now...."
  rsync -ah catalog manual release-notes tutorial site/
}

fetchLegacyAPIRef() {
  ## This downloads the legacy api-ref and puts it where it needs to go.
  echo "downloading the legacy api-refs to deploy...."
  cd static-pages/
  wget http://cocos2d-x.org/docs/api-refs.tar.gz
  tar xvf api-refs.tar.gz
  cd ..

  echo "copying older API-Ref versions, these don't change, static, no need to build..."
  rsync -ah static-pages/api-refs/ site/api-ref
}


main() {
  ## display opening message to user
  hello

  ## See what parameters the user has supplied.
  if (( $# == 1 )); then
    if [[ "--help" =~ $1 ]]; then ## user asked for help
      help
      exitScript
    elif [[ "--all" =~ $1 ]]; then ## builds absolutely every step
      buildAll
      exitScriptAfterStaging
    elif [[ "--slim" =~ $1 ]]; then ## builds a trimmed down version
      buildSlim
      exitScriptAfterStaging
    elif [[ "--staging" =~ $1 ]]; then ## deploys site/ to staging
      deployToGitHub
      exitScript
    elif [[ "--production" =~ $1 ]]; then ## deploys site/ to production
      deployToProduction
      exitScript
    elif [[ "--legacyapi" =~ $1 ]]; then ## brings down legacy site/
      fetchLegacyAPIRef
      exitScript
    else
      exitScriptIncorrectParameters
    fi
  else
    exitScriptNotEnoughParameters
  fi
}

## run our script.
main $1
