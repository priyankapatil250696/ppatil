!/bin/bash


echo "Logging in with personal access token."
export GH_TOKEN=$BACKUP_GITHUB_PAT
gh auth setup-git

echo "Downloading repositories for" $BACKUP_GITHUB_OWNER
gh repo list $BACKUP_BITHUB_OWNER --json "name" --limit 4 --template '{{range .}}{{ .name }}{{"\n"}}{{end}}' | xargs -L1 -I {} gh repo clone $BACKUP_GITHUB_OWNER/{}

echo "downloaded repositories...."
find . -maxdepth 1 -type d 

echo "Uploading to S3 bucket" $BACKUP_BUCKET_NAME "in region" $BACKUP_AWS_REGION
aws s3 sync --region=$BACKUP_AWS_REGION . s3://$BACKUP_BUCKET_NAME/github.com/$BACKUP_GITHUB_OWNER/ 'date "+%Y-%m-%d"'/

echo "Complete."
