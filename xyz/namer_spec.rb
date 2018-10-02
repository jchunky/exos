require_relative 'namer'
require 'date'
require 'ostruct'

describe XYZ::Namer do
  let(:target) do
    OpenStruct.new(
      :publish_on => Date.new(2012, 2, 7),
      :xyz_category_prefix => 'abc',
      :kind => 'magic_unicorn',
      :personal? => false,
      :id => 1337,
      :title => 'I <3 SPARKLY Sparkles!!1!'
    )
  end

  subject { XYZ::Namer.xyz_filename(target) }

  it 'works' do
    expect(subject).to match(/07abcmagicunicorn_1337_[0-9a-f]{8}_isparklysp\.jpg/)
  end

  it 'leaves square brackets' do
    target.title = 'i[sparkle]s'
    expect(subject).to match(/07abcmagicunicorn_1337_[0-9a-f]{8}_i\[sparkle\]\.jpg/)
  end

  it 'personalizes' do
    target[:personal?] = true
    target.age = 42
    expect(subject).to match(/07abcmagicunicorn_042_1337_[0-9a-f]{8}_isparklysp\.jpg/)
  end

  it 'handles nil age' do
    target[:personal?] = true
    target.age = nil
    expect(subject).to match(/07abcmagicunicorn_000_1337_[0-9a-f]{8}_isparklysp\.jpg/)
  end

  it 'handles short titles' do
    target.title = 'O HAI'
    expect(subject).to match(/07abcmagicunicorn_1337_[0-9a-f]{8}_ohai\.jpg/)
  end
end
