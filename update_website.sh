# Directory
cd dropbox/website/

# Set git
git config --global user.email matteo.courthoud@uzh.ch
git config --global user.name matteocourthoud

read -p "Enter commit description: " description

# Remove public directory if it exists
git submodule update --init --recursive
rm -r public/
git submodule add -f -b master https://github.com/matteocourthoud/matteocourthoud.github.io.git public

# Add, commit, push code
git add .
git commit -m $description
git push -u origin master

# Build book
cd courses/econometrics
Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::pdf_book')"
cd -

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

