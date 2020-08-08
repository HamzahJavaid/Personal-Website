# Directory
cd dropbox/code/website/

# Set git
git config --global user.email matteo.courthoud@uzh.ch
git config --global user.name matteocourthoud

read -p "Enter commit description: " description

# Add, commit, push code
echo
git add .
git commit -m $description
git push

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

# Re-init public
# rm -r public
# git submodule add -f -b master https://github.com/matteocourthoud/matteocourthoud.github.io public

# Update website - NOT WORKING AT THE MOMENT
echo
hugo

# Add, commit, push website
echo
cd public
git add .
git commit -m "Update website"
git push

sleep 3
exit

