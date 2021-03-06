require 'test_helper'

class OpeningNotificationTest < ActionMailer::TestCase
  def test_opening_notify
    o = Factory.create :opening
    res = Notifier.create_notify_opening(o)
    assert_equal 'test@example.com', *res.to
    assert_equal "New Opening Posted: #{o.headline}", res.subject
    assert_equal NOTIFICATION_ADDRESS, *res.from
  end

  def test_event_notify
    e = Factory.create :event
    res = Notifier.create_notify_event(e)
    assert_equal ADMIN_ADDRESS, *res.to
    assert_equal "New Event Posted", res.subject
    assert_equal NOTIFICATION_ADDRESS, *res.from
  end
end
