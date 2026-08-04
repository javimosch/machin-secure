exec { "run":
  command => "echo $user_input",
}
file { "/tmp/x":
  mode => "0777",
}
password => "hardcoded123"
notify { "token: $token" }
