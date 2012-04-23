#! /usr/bin/ruby1.9.1

# gem install 'twitter'
require 'twitter'
require 'json'

# -- CONFIG --
client = Twitter::Client.new(
    :consumer_key =>       'fgnXdqtGNVjc3GvEPpaipA',
    :consumer_secret =>    'lC7M4xwqbsGU76lrCCqBfzBwRppO4ol6nf034RVhg',
    :oauth_token =>        '18565111-jKjGzW0MlurKHfJ1WhWiov7wgHBvwsX9IJzwKtVb7',
    :oauth_token_secret => 'U8UpDmAMnT4lVo3SnEY4W2Xt2XozMaGF6OwWAk4KQTw'
)
Output_dir = './friends_ids'
# -- ////// --

force = (ARGV.length > 0 && ARGV[0] == '--force')

if !File.directory?(Output_dir)
    Dir.mkdir('Output_dir')
end

usernames = JSON.parse(File.read('all_usernames_uniq.json'))

usernames.each {|u|

    if (!force && File.exists?("#{Output_dir}/#{u}.json"))
        puts "file already exists for @#{u}, skipping."
        next
    end

    cursor = -1
    friends_ids = []

    while (cursor != 0)

        begin
        resp = client.friend_ids(u, :cursor => cursor).to_hash
        rescue Twitter::Error::ServiceUnavailable => err
            puts "Error: Service Unavailable (#{err.message}). Waiting 10 sec."
            resp = {'ids'=>[], 'next_cursor'=>-1}
            sleep 10

        rescue Twitter::Error::Unauthorized => err
            puts "Error: Unauthaurized (#{err.message}). Skipping @#{u}."
            resp = {'ids'=>[], 'next_cursor'=>0}

        rescue Twitter::Error::NotFound => err
            puts "Error: Not Found (#{err.message}). Skipping @#{u}."
            resp = {'ids'=>[], 'next_cursor'=>0}

        rescue Twitter::Error::BadRequest => err
            puts "Error: Bad Request (#{err.message})."
            if (err.message.start_with? 'Rate limit exceeded')

                rate_limit = client.rate_limit_status.to_hash
                reset_time = rate_limit['reset_time_in_seconds']
                remaining_time = reset_time - Time.now.to_i

                puts "Rate limit exceeded. Waiting #{remaining_time} sec."
                resp = {'ids'=>[], 'next_cursor'=>-1}
                sleep remaining_time+1

            end

        rescue Twitter::Error::InternalServerError => err
            puts "Error: Internal Server Error (#{err.message})."
            puts "Waiting 2 seconds."
            sleep 2
            resp = {'ids'=>[], 'next_cursor'=>0}

        end

        friends_ids.concat resp['ids']
        cursor = resp['next_cursor']

    end

    f = File.open("#{Output_dir}/#{u}.json", 'w')
    f.write(JSON.unparse(friends_ids))
    f.close

    puts "@#{u} ok (#{friends_ids.length} friends)."
}
puts "end."
