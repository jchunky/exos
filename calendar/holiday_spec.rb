require_relative 'holiday'

describe Calendar::Holiday do

  subject { double.extend(Calendar::Holiday) }

  let(:now) { Time.now.utc }

  describe "mothersday" do
    it { subject.date_for_mothersday(Time.utc(1986, 2, 1)).should eq(Time.utc(1986, 2, 9)) }
    it { subject.date_for_mothersday(Time.utc(2012, 2, 1)).should eq(Time.utc(2012, 2, 12)) }
    it { subject.date_for_mothersday(Time.utc(2012, 2, 12)).should eq(Time.utc(2012, 2, 12)) }
    it { subject.date_for_mothersday(Time.utc(2012, 2, 13)).should eq(Time.utc(2013, 2, 10)) }

    it "defaults to today" do
      expected = subject.date_for_mothersday(Time.utc(now.year, now.month, now.day))
      subject.date_for_mothersday.should eq(expected)
    end
  end

  describe "fathersday" do
    it { subject.date_for_fathersday(Time.utc(1986, 11, 1)).should eq(Time.utc(1986, 11, 9)) }
    it { subject.date_for_fathersday(Time.utc(2012, 11, 1)).should eq(Time.utc(2012, 11, 11)) }
    it { subject.date_for_fathersday(Time.utc(2012, 11, 11)).should eq(Time.utc(2012, 11, 11)) }
    it { subject.date_for_fathersday(Time.utc(2012, 11, 12)).should eq(Time.utc(2013, 11, 10)) }

    it "defaults to today" do
      expected = subject.date_for_fathersday(Time.utc(now.year, now.month, now.day))
      subject.date_for_fathersday.should eq(expected)
    end

  end
end
