require 'slack-ruby-bot'
require 'chronic'
require 'dice_bag'
require 'faraday'
require 'json'

class DiceBot < SlackRubyBot::Bot

  match(/roll a (?<notation>\w*)/) do |client, data, match|
    bag = DiceBag::Bag.new(match[:notation])
    client.say(text: ":d20: #{bag.dump}", channel: data.channel)
  end

  command ':d20:' do |client, data, match|
    bag = DiceBag::Bag.new("d20")
    client.say(text: ":d20: Its be a #{bag.dump.to_sentence}", channel: data.channel)
  end

  operator '%' do |client, data, match|
    bag = DiceBag::Bag.new(match['expression'])
    result = bag.roll_once
    client.say(text: "> :d20: #{result}", channel: data.channel)
    client.say(text: "> _Rolled:_ #{bag.roll_record.to_sentence}", channel: data.channel)
  end
end

DiceBot.run