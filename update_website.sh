# Directory
cd dropbox/code/website/

read -p "Enter commit description: " description

# Remove public folder
rm -r public

# Add, commit, push code
echo
git add .
git commit -m $description
git push -u origin master

# Ask to build book
read -p "Re-build econometrics notes? [y/n]" answer
if [[ $answer = y ]]
then
 # Build book
 cd courses/econometrics
 Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
 Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"
 cd -
fi

# Update website
echo
hugo

# Add, commit, push website
echo
cd public
git add .
git commit -m "Update website"
git push origin master

sleep 3
exit

