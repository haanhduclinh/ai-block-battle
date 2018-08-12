#!/usr/bin/env ruby
require 'pry' if ENV['DEBUG']
require_relative 'lib/bot/constant_define'
require_relative 'lib/bot/game_matrix'
require_relative 'lib/bot/flip'
require_relative 'lib/bot/command'
require_relative 'lib/bot/formatter'
require_relative 'lib/bot/game'
require_relative 'lib/bot/state'
require_relative 'lib/bot/settings'
require_relative 'lib/bot/bot'
require_relative 'lib/bot/player'
require 'matrix'

def main
  $stdout.sync = true # sets up immediate output flush
  Bot.new.run
end

main
