require 'spec_helper'

describe 'global to_create' do
  before do
    define_model('User', name: :string)
    define_model('Post', name: :string)

    FactoryGirl.define do
      to_create {|instance| instance.name = 'persisted!' }

      trait :override_to_create do
        to_create {|instance| instance.name = 'override' }
      end

      factory :user do
        name 'John Doe'

        factory :child_user

        factory :child_user_with_trait do
          override_to_create
        end
      end

      factory :post do
        name 'Great title'

        factory :child_post

        factory :child_post_with_trait do
          override_to_create
        end
      end
    end
  end

  it 'handles base to_create' do
    FactoryGirl.create(:user).name.should == 'persisted!'
    FactoryGirl.create(:post).name.should == 'persisted!'
  end

  it 'handles child to_create' do
    FactoryGirl.create(:child_user).name.should == 'persisted!'
    FactoryGirl.create(:child_post).name.should == 'persisted!'
  end

  it 'handles child to_create with trait' do
    FactoryGirl.create(:child_user_with_trait).name.should == 'override'
    FactoryGirl.create(:child_post_with_trait).name.should == 'override'
  end

  it 'handles inline trait override' do
    FactoryGirl.create(:child_user, :override_to_create).name.should == 'override'
    FactoryGirl.create(:child_post, :override_to_create).name.should == 'override'
  end

  it 'uses to_create globally across FactoryGirl.define' do
    define_model('Company', name: :string)

    FactoryGirl.define do
      factory :company
    end

    FactoryGirl.create(:company).name.should == 'persisted!'
    FactoryGirl.create(:company, :override_to_create).name.should == 'override'
  end
end

describe 'global skip_create' do
  before do
    define_model('User', name: :string)
    define_model('Post', name: :string)

    FactoryGirl.define do
      skip_create

      trait :override_to_create do
        to_create {|instance| instance.name = 'override' }
      end

      factory :user do
        name 'John Doe'

        factory :child_user

        factory :child_user_with_trait do
          override_to_create
        end
      end

      factory :post do
        name 'Great title'

        factory :child_post

        factory :child_post_with_trait do
          override_to_create
        end
      end
    end
  end

  it 'does not persist any record' do
    FactoryGirl.create(:user).should be_new_record
    FactoryGirl.create(:post).should be_new_record
  end

  it 'does not persist child records' do
    FactoryGirl.create(:child_user).should be_new_record
    FactoryGirl.create(:child_post).should be_new_record
  end

  it 'honors overridden to_create' do
    FactoryGirl.create(:child_user_with_trait).name.should == 'override'
    FactoryGirl.create(:child_post_with_trait).name.should == 'override'
  end

  it 'honors inline trait to_create' do
    FactoryGirl.create(:child_user, :override_to_create).name.should == 'override'
    FactoryGirl.create(:child_post, :override_to_create).name.should == 'override'
  end
end
