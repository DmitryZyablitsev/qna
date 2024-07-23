server "31.129.63.43", user: "deployer", roles: %w{app db web}, primary: true
set :rails_env, :production
 set :ssh_options, {
   keys: %w(/home/dmitry-z/.ssh/id_rsa),
   forward_agent: true,
   auth_methods: %w(publickey password),
   port: 2222
 }
