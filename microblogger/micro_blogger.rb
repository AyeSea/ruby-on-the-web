require 'rubygems'
require 'jumpstart_auth'
require 'bitly'

class MicroBlogger
	attr_reader :client

	def initialize
		puts "Initializing..."
		@client = JumpstartAuth.twitter
	end

	def tweet(message)
		if message.length <= 140
			@client.update(message)
		else
			puts "You can't tweet a message longer than 140 characters!"
		end
	end

	def dm(target, message)
		puts "Trying to send #{target} this direct message:"
		puts message
		message = "d @#{target} #{message}"

		if followers_list.include?(target)
			tweet(message)
		else
			puts "You can only send a DM to people who follow you."
		end
	end

	def spam_my_followers(message)
		followers = followers_list
		followers.each do |follower|
			dm(follower, message)
		end
	end

	def followers_list
		screen_names = []
		@client.followers.each do |follower|
			screen_names << @client.user(follower).screen_name
		end
		screen_names
	end

	def everyones_last_tweet
		friends = @client.friends
		friends.sort_by { |friend| @client.user(friend).screen_name.downcase }

		friends.each do |friend|
			name = @client.user(friend).screen_name
			last_message = @client.user(friend).status.text
			timestamp = @client.user(friend).status.created_at
			puts "#{name}'s last tweet at #{timestamp.strftime("%A, %b %d")}:"
			puts last_message
			puts ""
		end
	end

	def run
		puts "Welcome to the JSL Twitter Client!"
		command = ""

		while command != "q"
			printf "Enter command: "
			input = gets.chomp
			parts = input.split(" ")
			command = parts[0]

			case command
			when "q" then puts "Goodbye!"
			when "t" then tweet(parts[1..-1].join(" "))
			when "dm" then dm(parts[1], parts[2..-1].join(" "))
			when "spam" then spam_my_followers(parts[1..-1].join(" "))
			when "elt" then everyones_last_tweet
			when "s" then shorten(parts[1])
			when "turl" then tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))
			else
				puts "Sorry, I don't know how to #{command}"
			end
		end
	end

	def shorten(original_url)
		bitly = Bitly.new("hungryacademy", 'R_430e9f62250186d2612cca76eee2dbc6')
		puts "Shortening this URL: #{original_url}"
		return bitly.shorten(original_url).short_url
	end
end


Bitly.use_api_version_3
blogger = MicroBlogger.new
blogger.run