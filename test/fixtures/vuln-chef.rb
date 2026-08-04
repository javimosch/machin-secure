execute "run" do
  command "echo #{user_input}"
end
password "hardcoded123"
file "/tmp/x" do
  mode "0777"
end
template "/etc/app.conf" do
  variables password: "secret"
end
NOPASSWD
