{
  backticks = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vr28l9vckavnrb9pnqrhcmnk3wsvvpas8jjh165w2rzv3sdkws5";
      type = "gem";
    };
    version = "1.0.2";
  };
  coderay = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jvxqxzply1lwp7ysn94zjhh57vc14mcshw1ygw14ib8lhc00lyw";
      type = "gem";
    };
    version = "1.1.3";
  };
  daemons = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l5gai3vd4g7aqff0k1mp41j9zcsvm2rbwmqn115a325k9r7pf4w";
      type = "gem";
    };
    version = "1.3.1";
  };
  docker-compose = {
    dependencies = ["backticks"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p3fcbl6nkwzxaqgcwm9xib76bg363dzks4dyw5j4rz7sqk1wkdr";
      type = "gem";
    };
    version = "1.1.12";
  };
  docker-sync = {
    dependencies = ["daemons" "docker-compose" "dotenv" "gem_update_checker" "os" "terminal-notifier" "thor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jlp527d23s4iiazvq339dycrgjws2wcxw2z6mcq92b8h51iwf6h";
      type = "gem";
    };
    version = "0.5.14";
  };
  dotenv = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iym172c5337sm1x2ykc2i3f961vj3wdclbyg1x6sxs3irgfsl94";
      type = "gem";
    };
    version = "2.7.6";
  };
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12lpwaw82bb0rm9f52v1498bpba8aj2l2q359mkwbxsswhpga5af";
      type = "gem";
    };
    version = "1.13.1";
  };
  gem_update_checker = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ckbz4q3q59kkv138n0cmsyida0wg45pwscxzf5vshxcrxhmq3x7";
      type = "gem";
    };
    version = "0.2.0";
  };
  method_source = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pnyh44qycnf9mzi1j6fywd5fkskv3x7nmsqrrws0rjn5dd4ayfp";
      type = "gem";
    };
    version = "1.0.0";
  };
  os = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12fli64wz5j9868gpzv5wqsingk1jk457qyqksv9ksmq9b0zpc9x";
      type = "gem";
    };
    version = "1.1.1";
  };
  pry = {
    dependencies = ["coderay" "method_source"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iyw4q4an2wmk8v5rn2ghfy2jaz9vmw2nk8415nnpx2s866934qk";
      type = "gem";
    };
    version = "0.13.1";
  };
  rb-inotify = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jm76h8f8hji38z3ggf4bzi8vps6p7sagxn3ab57qc0xyga64005";
      type = "gem";
    };
    version = "0.10.1";
  };
  terminal-notifier = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1slc0y8pjpw30hy21v8ypafi8r7z9jlj4bjbgz03b65b28i2n3bs";
      type = "gem";
    };
    version = "2.0.0";
  };
  thor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yhrnp9x8qcy5vc7g438amd5j9sw83ih7c30dr6g6slgw9zj3g29";
      type = "gem";
    };
    version = "0.20.3";
  };
}