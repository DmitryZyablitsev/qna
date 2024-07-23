lock "~> 3.19.1"

set :application, "qna"
set :repo_url, "git@github.com:DmitryZyablitsev/qna.git"
set :branch, 'main'

set :deploy_to, "/home/deployer/qna"
set :deploy_user, 'deployer'

# set :rbenv_ruby, '3.2.3'

# set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
# set :rbenv_map_bins, %w{rake gem bundle ruby rails}
# set :rbenv_roles, :all # default value

set :bundle_jobs, 1

append :linked_files, "config/database.yml", 'config/master.key'

append :linked_dirs, '.bundle', "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"
