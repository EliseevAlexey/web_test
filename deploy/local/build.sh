script_dir="$(dirname "$0")"
source "$script_dir/local.env"
git_root_dir="$(git rev-parse --show-toplevel)"
docker build -t $APP_NAME "$git_root_dir/app"
