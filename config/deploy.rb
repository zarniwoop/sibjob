set :application, "sibjob"
set :repository,  "git@github.com:zarniwoop/sibjob.git"
set :domain, "sibjob.bajink.com"

set :user, "jabink"
set :scm_username, "zarniwoop"
set :applicationdir, "/home/#{user}/#{domain}/apps/#{application}"

set :deploy_to, "#{applicationdir}"

set :scm, "git"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :app, "#{domain}"
role :web, "#{domain}"
role :db,  "#{domain}", :primary => true

set :use_sudo, false
ssh_options[:forward_agent] = true
default_run_options[:pty] = true  # Must be set for the password prompt from git to work
set :branch, "master"
set :deploy_via, :remote_cache

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end