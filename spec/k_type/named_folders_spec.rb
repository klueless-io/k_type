# frozen_string_literal: true

# attr_accessor :current_target_folder

RSpec.describe KType::NamedFolders do
  let(:instance) { described_class.new }
  let(:sample_assets_folder) { File.join(Dir.getwd, 'spec', 'sample-assets') }
  let(:target_folder) { File.join(sample_assets_folder, 'target') }
  let(:webpack_folder) { File.join(target_folder, 'config') }
  let(:slide_folder) { '~/slides' }

  describe '#initialize' do
    subject { instance }

    it { is_expected.not_to be_nil }

    describe '.folders' do
      subject { instance.folders }

      it { is_expected.to be_empty }
    end
  end

  describe '#debug' do
    subject { instance }

    before do
      instance.add(:app, target_folder)
      instance.add(:webpack, instance.join(:app, 'config'))
    end

    it { subject.debug } # (title: 'custom title')
  end

  describe '#add' do
    context 'when no folder supplied' do
      subject { instance.add(:app) }

      it { expect { subject }.to raise_error(KType::Error, 'No folder part provided') }
    end

    context 'when absolute folder' do
      subject { instance.add(:app, target_folder) }

      it { is_expected.to eq(target_folder) }
    end

    context 'when home folder (aka ~)' do
      subject { instance.add(:app, slide_folder) }

      it { is_expected.to eq(File.expand_path(slide_folder)) }
    end

    context 'when file parts' do
      subject { instance.add(:app, target_folder, 'a', 'b') }

      it { is_expected.to eq(File.join(target_folder, 'a', 'b')) }
    end

    context 'when file parts and first part is a lookup folder_key' do
      subject do
        instance.add(:app, target_folder, 'a')
        instance.add(:abc, :app, 'b', 'c')
      end

      it { is_expected.to eq(File.join(target_folder, 'a', 'b', 'c')) }
    end

    describe '.folders' do
      subject { instance.folders }

      context ':app (or root) folder' do
        before { instance.add(:app, target_folder) }

        # May want to support :default or :root here
        it { is_expected.to include(app: target_folder) }

        context ':when duplicate named folder' do
          before do
            instance.add(:app, target_folder)
            instance.add(:app, target_folder)
          end

          subject { instance.folders }

          it do
            is_expected
              .to  include(app: target_folder)
              .and have_attributes(length: 1)
          end
        end

        context ':when duplicated key but different folder' do
          before do
            instance.add(:app, 'abc')
            instance.add(:app, 'xyz')
          end

          subject { instance.folders }

          it do
            # Last in, wins
            is_expected
              .to  include(app: 'xyz')
              .and have_attributes(length: 1)
          end
        end

        context ':package folder is aliased to :app folder' do
          before { instance.add(:package, :app) }

          it do
            is_expected
              .to  include(app: target_folder)
              .and include(package: target_folder)
          end
        end
        context 'webpack folder is a sub-folder of :app' do
          before { instance.add(:webpack, instance.join(:app, 'config')) }

          it do
            is_expected
              .to  include(app: target_folder)
              .and include(webpack: webpack_folder)
          end
        end
        context 'slide folder uses tilda expansion' do
          before { instance.add(:slide, slide_folder) }

          it do
            is_expected
              .to  include(app: target_folder)
              .and include(slide: File.expand_path(slide_folder))
          end
        end
      end
    end
  end

  describe '#join' do
    # Join for joining named folders to sub-folders
    before { instance.add(:app, target_folder) }

    context 'join folder' do
      subject { instance.join(:app, 'config') }

      it { is_expected.to eq(File.join(target_folder, 'config')) }

      context 'join multiple subfolders' do
        subject { instance.join(:app, 'config', 'more') }

        it { is_expected.to eq(File.join(target_folder, 'config', 'more')) }
      end
    end
  end

  describe '#get_filename' do
    # get_filename for joining named folders to sub-folders + file (alias to #join)
    before { instance.add(:app, target_folder) }
    context 'get_filename folder' do
      subject { instance.get_filename(:app, 'output.txt') }

      it { is_expected.to eq(File.join(target_folder, 'output.txt')) }

      context 'get_filename multiple subfolders' do
        subject { instance.get_filename(:app, 'config', 'output.txt') }

        it { is_expected.to eq(File.join(target_folder, 'config', 'output.txt')) }
      end
    end
  end

  describe '#get' do
    before { instance.add(:app, target_folder) }

    context 'get registered folder' do
      subject { instance.get(:app) }

      it { is_expected.to eq(target_folder) }
    end

    context 'get unknown folder' do
      subject { instance.get(:xxx) }

      it { expect { subject }.to raise_error(KType::Error, 'Folder not found, this folder key not found: xxx') }
    end
  end

  describe '.folder_keys' do
    subject { instance.folder_keys }

    context 'add some folders' do
      before do
        instance.add(:app, target_folder)
        instance.add(:webpack, instance.join(:app, 'config'))
      end

      it { is_expected.to eq(%i[app webpack]) }
    end
  end

  describe '.current' do
    subject { instance.current }

    context 'no folders' do
      it { is_expected.to be_nil }
    end

    context 'when first folder added' do
      before { instance.add(:app, target_folder) }

      it { is_expected.to eq(:app) }

      context 'when second folder added' do
        before { instance.add(:webpack, instance.join(:app, 'config')) }

        it { is_expected.to eq(:app) }

        describe '.current=' do
          context 'when valid folder key' do
            before { instance.current = :webpack }

            it { is_expected.to eq(:webpack) }
          end
          context 'when invalid folder key' do
            subject { instance.current = :xxx }

            it { expect { subject }.to raise_error(KType::Error, 'Folder not found, this folder key not found: xxx') }
          end
        end
      end
    end
  end

  describe '#clone' do
    let(:copy) { instance.clone }

    before do
      instance.add(:app, target_folder)
      instance.add(:webpack, instance.join(:app, 'config'))

      copy.add(:custom, '/custom')
    end

    context 'original' do
      let(:target) { instance }

      context '.count' do
        subject { target.folders.count }

        it { is_expected.to eq(2) }
      end

      context '.folders' do
        subject { target.folders }

        it { is_expected.to have_key(:app).and have_key(:webpack) }
        it { is_expected.not_to have_key(:custom) }
      end
    end

    context 'copy' do
      let(:target) { copy }

      context '.count' do
        subject { target.folders.count }

        it { is_expected.to eq(3) }
      end

      context '.folders' do
        subject { target.folders }

        it { is_expected.to have_key(:app).and have_key(:webpack).and have_key(:custom) }
      end
    end
  end

  describe '#to_h' do
    subject { instance.to_h }

    context 'add some folders' do
      before do
        instance.add(:app, target_folder)
        instance.add(:webpack, instance.join(:app, 'config'))
      end

      it do
        is_expected
          .to  include(app: target_folder)
          .and include(webpack: webpack_folder)
      end
    end
  end
end
