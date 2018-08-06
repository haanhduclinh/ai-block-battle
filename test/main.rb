#!/usr/bin/env ruby

require_relative '../lib/bot/constant_define'
require_relative '../lib/bot/command'
require_relative '../lib/bot/formatter'
require_relative '../lib/bot/game'
require_relative '../lib/bot/state'
require_relative '../lib/bot/settings'
require_relative '../lib/bot/bot'
require_relative '../lib/bot/player'
require 'pry'

def test_data
  File.read("#{File.dirname(__FILE__)}/input.txt")
end

def main
  $stdout.sync = true # sets up immediate output flush
  Bot.new.run(test_data)
end

main
