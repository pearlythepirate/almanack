require 'spec_helper'

module Almanack
  describe Configuration do

    describe "#title" do
      it "can be set and accessed" do
        config = Configuration.new
        config.title = "Discworld Holidays"
        expect(config.title).to eq("Discworld Holidays")
      end
    end

    describe "#theme" do
      it "can be set and accessed" do
        config = Configuration.new
        config.theme = "custom"
        expect(config.theme).to eq("custom")
      end
    end

    describe "#theme_root" do
      specify "it raises an error if no theme can be found" do
        config = Configuration.new
        config.theme = "nonexistent"
        expect { config.theme_root }.to raise_error(Configuration::ThemeNotFound)
      end
    end

    describe "#days_lookahead" do
      specify { expect(Configuration.new.days_lookahead).to eq(30) }

      specify "it can be set" do
        config = Configuration.new
        config.days_lookahead = 365
        expect(config.days_lookahead).to eq(365)
      end
    end

    describe "#feed_lookahead" do
      specify { expect(Configuration.new.feed_lookahead).to eq(365) }

      specify "it can be set" do
        config = Configuration.new
        config.feed_lookahead = 30
        expect(config.feed_lookahead).to eq(30)
      end
    end

    describe "#add_events" do
      it "adds a simple event collection event source" do
        config = Configuration.new
        expect(config.event_sources.size).to eq(0)

        config.add_events [
          { title: "Hogswatch" }
        ]

        expect(config.event_sources.size).to eq(1)
        expect(config.event_sources.first).to be_an_instance_of(EventSource::Static)
      end
    end

    describe "#ical_feed" do
      it "adds an iCal feed event source" do
        config = Configuration.new
        expect(config.event_sources.size).to eq(0)

        config.add_ical_feed "https://www.google.com/calendar/ical/61s2re9bfk01abmla4d17tojuo%40group.calendar.google.com/public/basic.ics"

        expect(config.event_sources.size).to eq(1)
        expect(config.event_sources.first).to be_an_instance_of(EventSource::IcalFeed)
      end
    end

    describe "#meetup_group" do
      it "adds a Meetup group event source" do
        config = Configuration.new
        expect(config.event_sources.size).to eq(0)

        config.add_meetup_group(group_urlname: "CHC-JS", key: "secrettoken")

        expect(config.event_sources.size).to eq(1)
        expect(config.event_sources.first).to be_an_instance_of(EventSource::MeetupGroup)
      end
    end

    describe "#cache_expiry" do
      it "is 15 minutes by default" do
        expect(Configuration.new.cache_expiry).to eq(900)
      end

      it "can be set" do
        config = Configuration.new
        config.cache_expiry = 3600
        expect(config.cache_expiry).to eq(3600)
      end
    end

    describe "#cache_responses" do
      it "is enabled by default" do
        expect(Configuration.new.cache_responses).to be(false)
      end

      it "can be disabled" do
        config = Configuration.new
        config.cache_responses = true
        expect(config.cache_responses).to be(true)
      end
    end

  end
end
