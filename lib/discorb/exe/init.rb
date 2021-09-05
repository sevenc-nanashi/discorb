# description: Make files for the project.

require "optparse"
require_relative "../utils/colored_puts"

$pwd = Dir.pwd

FILES = {
  "main.rb" => <<~'RUBY',
    require "discorb"
    require "dotenv"

    Dotenv.load

    client = Discorb::Client.new

    client.once :ready do
      puts "Logged in as #{client.user}"
    end

    client.run ENV["%<token>"]
  RUBY
  ".env" => <<~BASH,
    %<token>=Y0urB0tT0k3nHer3.Th1sT0ken.W0ntWorkB3c4useItH4sM34n1ng
  BASH
  ".gitignore" => <<~GITIGNORE,
    *.gem
    *.rbc
    /.config
    /coverage/
    /InstalledFiles
    /pkg/
    /spec/reports/
    /spec/examples.txt
    /test/tmp/
    /test/version_tmp/
    /tmp/
    
    # Used by dotenv library to load environment variables.
    .env
    
    # Ignore Byebug command history file.
    .byebug_history
    
    ## Specific to RubyMotion:
    .dat*
    .repl_history
    build/
    *.bridgesupport
    build-iPhoneOS/
    build-iPhoneSimulator/
    
    ## Specific to RubyMotion (use of CocoaPods):
    #
    # We recommend against adding the Pods directory to your .gitignore. However
    # you should judge for yourself, the pros and cons are mentioned at:
    # https://guides.cocoapods.org/using/using-cocoapods.html#should-i-check-the-pods-directory-into-source-control
    #
    # vendor/Pods/
    
    ## Documentation cache and generated files:
    /.yardoc/
    /_yardoc/
    /doc/
    /rdoc/
    
    ## Environment normalization:
    /.bundle/
    /vendor/bundle
    /lib/bundler/man/
    
    # for a library or gem, you might want to ignore these files since the code is
    # intended to run in multiple environments; otherwise, check them in:
    # Gemfile.lock
    # .ruby-version
    # .ruby-gemset
    
    # unless supporting rvm < 1.11.0 or doing something fancy, ignore this:
    .rvmrc
    
    # Used by RuboCop. Remote config files pulled in from inherit_from directive.
    # .rubocop-https?--*

    # This gitignore is from github/gitignore.
    # https://github.com/github/gitignore/blob/master/Ruby.gitignore
  GITIGNORE
}

def make_files
  FILES.each do |file, content|
    File.write($pwd + "/#{file}", format(content, token: $values[:token]))
  end
end

def bundle_init
  File.write($pwd + "/Gemfile", <<~RUBY)
    # frozen_string_literal: true

    source "https://rubygems.org"

    git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

    gem "discorb", "~> 0.2.5"
    gem "dotenv", "~> 2.7"
  RUBY
  `bundle update`
  `bundle install`
end

def git_init
  `git init`
end

opt = OptionParser.new "A tools to make a new client."

$values = {
  bundle: true,
  git: true,
  token: "TOKEN",
}

opt.on("-b", "--[no-]bundle", "Whether to use bundle. Default to true.") do |v|
  $values[:bundle] = v
end

opt.on("-g", "--[no-]git", "Whether to initialize git. Default to true") do |v|
  $values[:git] = v
end

opt.on("-t", "--token", "The name of token environment variable. Default to TOKEN.") do |v|
  $values[:token] = v
end

opt.parse!(ARGV[1..])

git_init if $values[:git]
bundle_init if $values[:bundle]

make_files

puts "Successfully made a simple client at #{$pwd}."
