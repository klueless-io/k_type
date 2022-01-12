# frozen_string_literal: true

require 'spec_helper'

module TestComposite
  class ComponentBase
    include KType::Composite

    def initialize
      @parent = nil
      @children = []
    end
  end

  class Parent < TestComposite::ComponentBase
    def add_child(child_klass)
      @children << child_klass.new(self)
    end
  end

  class Child < TestComposite::ComponentBase
    def initialize(parent)
      super()
      attach_parent(parent)
    end
  end
end

# RSpec.describe KType::Composite do
#   subject { instance }

#   let(:instance) { TestComposite::ComponentBase.new }

#   it { is_expected.to respond_to(:parent) }
#   it { is_expected.to respond_to(:attach_parent) }
#   it { is_expected.to respond_to(:navigate_up) }
#   it { is_expected.to respond_to(:children) }

#   context 'when component is Parent' do
#     let(:instance) { parent }

#     let(:parent) { TestComposite::Parent.new }

#     context '.parent' do
#       subject { instance.parent }

#       it { is_expected.to be_nil }
#     end

#     context 'when parent adds child' do
#       before { instance.add_child(TestComposite::Child) }

#       context '.children' do
#         subject { instance.children }

#         it { is_expected.not_to be_nil }
#         it { is_expected.to have_attributes(length: 1) }

#         context '.parent' do
#           subject { instance.parent }

#           it { is_expected.to be_nil }
#         end

#         context '.navigate_up' do
#           subject { instance.navigate_up }

#           it { is_expected.to be_a(TestComposite::Parent) }
#           it { is_expected.to eq(parent) }
#         end

#         context '.root?' do
#           subject { instance.root? }

#           it { is_expected.to be_truthy }
#         end

#         context '.children.first' do
#           subject { first_child }

#           let(:first_child) { instance.children.first }

#           it { is_expected.to be_a(TestComposite::Child) }

#           context '.root?' do
#             subject { first_child.root? }

#             it { is_expected.to be_falsey }
#           end

#           context '.children.first.parent' do
#             subject { first_child.parent }

#             it { is_expected.to be_a(TestComposite::Parent) }
#             it { is_expected.to eq(parent) }
#           end

#           context '.children.first.navigate_up' do
#             subject { first_child.navigate_up }

#             it { is_expected.to be_a(TestComposite::Parent) }
#             it { is_expected.to eq(parent) }
#           end
#         end
#       end
#     end
#   end

#   context 'when component is Child' do
#     let(:instance) { child }
#     let(:parent) { TestComposite::Parent.new }
#     let(:child) { TestComposite::Child.new(parent) }

#     context '.parent' do
#       subject { instance.parent }

#       it { is_expected.not_to be_nil }
#       it { is_expected.to be_a(TestComposite::Parent) }
#     end

#     context '.children' do
#       subject { instance.children }

#       it { is_expected.not_to be_nil }
#       it { is_expected.to have_attributes(length: 0) }
#     end
#   end
#   # describe Statusable do
#   #   before do
#   #     stub_const 'Foo', Class.new
#   #     Foo.class_eval{ include Statusable }
#   #     Foo.class_eval{ statuses published: "foo", draft: "bar"}
#   #   end

#   #   context '#statuses' do
#   #     it 'sets STATUSES for a model' do
#   #       FOO::STATUSES.should == ["foo", "bar"]
#   #     end
#   #   end
#   # end
# end
