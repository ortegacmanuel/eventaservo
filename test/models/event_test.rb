require 'test_helper'

class EventTest < ActiveSupport::TestCase
  setup do
    @event = events(:one)
  end

  test 'evento havas kreinton' do
    assert_not_nil Event.reflect_on_association(:user)
  end

  test 'evento havas landon' do
    assert_not_nil Event.reflect_on_association(:country)
  end

  test 'evento havas ŝatatojn' do
    assert_not_nil Event.reflect_on_association(:country)
  end

  test 'evento havas partoprenantojn' do
    assert_not_nil Event.reflect_on_association(:participants)
  end

  test 'titolo necesas' do
    event       = events(:one)
    event.title = nil
    assert event.invalid?
  end

  test 'priskribo necesas' do
    event             = events(:one)
    event.description = nil
    assert event.invalid?
  end

  test 'urbo necesas' do
    event       = events(:one)
    event.city = nil
    assert event.invalid?
  end

  test 'lando necesas' do
    event       = events(:one)
    event.country_id = nil
    assert event.invalid?
  end

  test 'komenca dato necesas' do
    event       = events(:one)
    event.date_start = nil
    assert event.invalid?
  end

  test 'fina dato necesas' do
    event       = events(:one)
    event.date_end = nil
    assert event.invalid?
  end

  test 'kodo necesas' do
    event       = events(:one)
    event.code = nil
    assert event.invalid?
  end

  test 'fina dato devas esti post komenca dato' do
    event            = events(:one)
    event.date_start = Date.today
    event.date_end   = Date.today - 1.day
    assert_not event.save
  end

  test 'forigas kaj malforigas la eventon, sed ne el la datumbazo' do
    @event.delete!
    assert_equal @event.deleted, true

    @event.undelete!
    assert_equal @event.deleted, false
  end

  test 'serĉado' do
    event = events(:brazilo)
    assert Event.search('brazilo').exists?(id: event.id)
  end

  test 'priskribo ne povas esti pli ol 400 signoj' do
    new_event = events(:one)
    new_event.description = SecureRandom.hex(201) # Pli ol 400 signoj
    assert new_event.invalid?
  end

  test 'titolo devas estive Titleize-ita' do
    title = "GRANDA TITOLO"
    @event.update_attribute(:title, title)
    assert_equal title.titleize, @event.title
  end

  test 'retejo devas enhavi http se ankoraŭ ne havas ĝin' do
    site = 'google.com'
    @event.update_attribute(:site, site)
    assert_equal "http://#{site}", @event.site
  end

  test 'ne aldonu http se retejo jam havas ĝin' do
    site = 'https://google.com'
    @event.update_attribute(:site, site)
    assert_equal site, @event.site
  end
end
