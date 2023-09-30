require 'line/bot'

class ReviewNotificationJob < ApplicationJob
  TIME_ZONE_OF_DB = 'UTC'
  TIME_ZONE_TO_DISPLAY = 'Tokyo'

  def self.line_notification
    send_notification('line')
  end

  def self.mail_notification
    send_notification('mail')
  end

  def self.send_notification(medium)
    today = Date.today.midnight.in_time_zone(TIME_ZONE_OF_DB)
    tomorrow = Date.tomorrow.midnight.in_time_zone(TIME_ZONE_OF_DB)

    notification_recs = User.joins(:user_setting, subjects: { subject_details: :subject_reviews })
                            .select('
                                      users.id as user_id
                                    , users.email
                                    , users.first_name
                                    , users.last_name
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
                            .order('
                                      users.id
                                    , subjects.id
                                    , subject_details.id
                                    , subject_reviews.review_number
                                  ')
                            .where(subject_reviews: { review_at: today...tomorrow })

                            case medium
                            when 'line'
                              notification_recs =
                                notification_recs.joins(:authentications)
                                                  .select('
                                                            authentications.id as authentication_id
                                                          , authentications.uid
                                                        ')
                                                  .where(authentications: { provider: 'line' })
                                                  .where(user_setting: { remind_line: :line_receive })
                            when 'mail'
                              notification_recs =
                                notification_recs.where(user_setting: { remind_mail: :mail_receive })
                            end

    pre_user_id = ''
    pre_email = ''
    pre_uid = ''
    msg_text = ''

    notification_recs.each do |notification_rec|
      if pre_user_id != notification_rec.user_id
        # ユーザーが変わった場合は前ユーザーにメッセージを送信
        if pre_user_id != ''
          case medium
          when 'line'
            push_line(pre_uid, msg_text)
          when 'mail'
            send_mail(pre_email, msg_text)
          end
        end

        msg_text = "#{I18n.t('notifications.body_title')}\n"
        msg_text += "#{I18n.t('notifications.message')}\n"
      end

      msg_text += "\n"
      msg_text += "- #{notification_rec.title}\n"
      msg_text += "  #{I18n.t('notifications.chapter')}: #{notification_rec.chapter}\n"
      msg_text += "  #{I18n.t('notifications.page')}: #{notification_rec.start_page}〜#{notification_rec.end_page}\n"
      msg_text += "  #{I18n.t('notifications.start_date')}: #{notification_rec.start_at.in_time_zone(TIME_ZONE_TO_DISPLAY).strftime('%Y/%m/%d')}\n"
      msg_text += "  #{I18n.t('notifications.review_number')}: #{notification_rec.review_number}#{I18n.t('notifications.review_number_suffix')}\n"
      msg_text += "  #{I18n.t('notifications.review_time')}: #{notification_rec.review_at.in_time_zone(TIME_ZONE_TO_DISPLAY).strftime('%H:%M')}\n"

      pre_user_id = notification_rec.user_id
      pre_email = notification_rec.email

      case medium
      when 'line'
        pre_uid = notification_rec.uid
      end
    end

    if msg_text != ''
      # メッセージがある場合は最後のユーザーにメッセージを送信
      case medium
      when 'line' then
        push_line(pre_uid, msg_text)
      when 'mail' then
        send_mail(pre_email, msg_text)
      end
    end
  end

  def self.send_mail(email, msg_text)
    NotificationMailer.review_notification(email, msg_text).deliver_now
  end

  def self.push_line(uid, msg_text)
    message = {
      type: 'text',
      text: msg_text
    }
    response = line_client.push_message(uid, message)
  end

  def self.line_client
    Line::Bot::Client.new do |config|
      config.channel_secret = Rails.application.credentials.dig(:line, :push_channel_secret)
      config.channel_token = Rails.application.credentials.dig(:line, :push_channel_token)
    end
  end
end
