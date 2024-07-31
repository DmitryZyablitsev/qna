lock "~> 3.19.1"

set :application, "qna"
set :repo_url, "git@github.com:DmitryZyablitsev/qna.git"
set :branch, 'main'

set :deploy_to, "/home/deployer/qna"
set :deploy_user, 'deployer'

set :bundle_jobs, 1

append :linked_files, "config/database.yml", 'config/master.key', 'config/thinking_sphinx.yml'

append :linked_dirs, '.bundle', "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"

after 'deploy:publishing', 'unicorn:restart'
