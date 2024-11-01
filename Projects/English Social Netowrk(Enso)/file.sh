for file in $(git ls-files --modified --others --exclude-standard '*.sql'); do
    git add "$file"
    filename=$(basename "$file")
    git commit -m "Add/update stored procedure: $filename"
done
