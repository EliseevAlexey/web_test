script_dir="$(dirname "$0")"
source "$script_dir/local.env"
git add . && git commit -m "$@" && git push
$SSH_COMMAND 'cd git/web_test/deploy && git pull && ./deploy.sh'
