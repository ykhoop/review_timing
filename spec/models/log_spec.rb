require 'rails_helper'

RSpec.describe Log, type: :model do
  describe 'バリデーション' do
    context 'ログレベル、プログラム、ログ内容がある場合' do
      it 'ログを登録できる' do
        log = FactoryBot.build(:log)
        expect(log).to be_valid
      end
    end

    context 'ログレベルがない場合' do
      it 'ログを登録できない' do
        log = FactoryBot.build(:log, log_level: nil)
        expect(log).to be_invalid
      end
    end

    context 'プログラムがない場合' do
      it 'ログを登録できない' do
        log = FactoryBot.build(:log, program: nil)
        expect(log).to be_invalid
      end
    end

    context 'ログ内容がない場合' do
      it 'ログを登録できない' do
        log = FactoryBot.build(:log, log_content: nil)
        expect(log).to be_invalid
      end
    end
  end

  describe 'メソッド' do
    describe 'logger!' do
      it 'ログを登録できる' do
        Log.logger!(:warn, 'test_program', 'test_log_content')
        log = Log.last
        expect(log.log_level).to eq 'warn'
        expect(log.program).to eq 'test_program'
        expect(log.log_content).to eq 'test_log_content'
      end
    end
  end
end
