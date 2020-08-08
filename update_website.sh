# Directory
cd dropbox/code/website/

read -p "Enter commit description: " description

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
rm -r public
hugo

# Add, commit, push website
echo
cd public
git remote set-url origin  https://github.com/matteocourthoud/matteocourthoud.github.io
git add .
git commit -a -m "Update website"
git push -f

sleep 3
exit

