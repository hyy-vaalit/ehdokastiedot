# coding: UTF-8
namespace :seed do

  namespace :redis do

    desc 'Reset Redis keys as a workaround for poor object oriented design'
    task :reset_keys => :environment do
      puts 'Resetting Redis keys'

      # FIXME: Oliosuunnittelu :(
      REDIS.del 'checking_minutes_ready'
      REDIS.del 'drawing_status'
      REDIS.del 'candidate_draw_status'
      REDIS.del 'alliance_draw_status'
      REDIS.del 'coalition_draw_status'
      REDIS.del 'final_result_status'
      REDIS.del 'tulos-alustava.txt'
      REDIS.del 'tulos-lopullinen.txt'

      REDIS.del 'mailaddress'
      REDIS.del 'total_vote_count'
      REDIS.del 'right_to_vote'
      REDIS.del 'votes_accepted'
      REDIS.del 'candidates_to_select'
      REDIS.del 'checking_minutes_username'
      REDIS.del 'checking_minutes_password'
    end
  end
end