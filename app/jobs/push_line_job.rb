require 'line/bot'

class PushLineJob < ApplicationJob

  def self.line_notice
    today = Date.today.midnight.in_time_zone('UTC')
    tomorrow = Date.tomorrow.midnight.in_time_zone('UTC')

    notification_recs = User.joins(:user_setting, :authentications, subjects: {subject_details: :subject_reviews})
                                .where(user_setting: { remind_line: :line_receive })
                                .where(authentications: { provider: 'line'})
                                .where(subject_reviews: { review_at: today...tomorrow})
                                .order('
                                          users.id
                                        , subjects.id
                                        , subject_details.id
                                        , subject_reviews.review_number
                                      ')
                                .select('
                                          users.id as user_id
                                        , users.first_name
                                        , users.last_name
                                        , authentications.id as authentication_id
                                        , authentications.uid
                                        , subjects.id as subject_id
                                        , subjects.title
                                        , subject_details.id as subject_detail_id
                                        , subject_details.chapter
                                        , subject_details.start_page
                                        , subject_details.end_page
                                        , subject_details.start_at
                                        , subject_reviews.id as subject_review_id
                                        , subject_reviews.review_number
                                        , subject_reviews.review_at
                                      ')

      pre_user_id = ''
      pre_uid = ''
      msg_text = ''

      notification_recs.each do |notification_rec|

        if (pre_user_id != notification_rec.user_id) then
          # ユーザーが変わった場合は前ユーザーにメッセージを送信
          if (pre_user_id != '') then
            push_line(pre_uid, msg_text)
          end

          msg_text = "#{I18n.t('notifications.line.title')}\n"
          msg_text += "#{I18n.t('notifications.line.message')}\n"
        end

        msg_text += "\n"
        msg_text += "- #{notification_rec.title}\n"
        msg_text += "  #{I18n.t('notifications.line.chapter')}: #{notification_rec.chapter}\n"
        msg_text += "  #{I18n.t('notifications.line.page')}: #{notification_rec.start_page}〜#{notification_rec.end_page}\n"
        msg_text += "  #{I18n.t('notifications.line.start_date')}: #{notification_rec.start_at.strftime('%Y/%m/%d/')}\n"
        msg_text += "  #{I18n.t('notifications.line.review_number')}: #{notification_rec.review_number}#{I18n.t('notifications.line.review_number_suffix')}\n"
        msg_text += "  #{I18n.t('notifications.line.review_time')}: #{notification_rec.review_at.strftime('%H:%M')}\n"

        pre_user_id = notification_rec.user_id
        pre_uid = notification_rec.uid
      end

      if (msg_text != '') then
        # メッセージがある場合は最後のユーザーにメッセージを送信
        push_line(pre_uid, msg_text)
      end
  end

  private

  def self.push_line(uid, msg_text)
    message = {
          type: 'text',
          text: msg_text
        }
    response = line_client.push_message(uid, message)
  end

  def self.line_client
    Line::Bot::Client.new { |config|
      config.channel_secret = Rails.application.credentials.dig(:line, :push_channel_secret)
      config.channel_token = Rails.application.credentials.dig(:line, :push_channel_token)
    }
  end
end